#!/bin/bash
#uncomment and set values
#PASSWORD=app user password
#TOKEN=duckdns token
#HOST=duckdns host
#EMAIL=your email here
# change password here
PASSWD=${PASSWORD:?specify the password in PASSWORD envar}
DDTOKEN=${TOKEN:?duckdns token}
DDHOST=${HOST:?duckdns host}
LEEMAIL=${EMAIL:?letsencrypt email}
# end changes
# set app directory
mkdir /app 
if test -b /dev/sdb 
then if  file -sL /dev/sdb | grep "/dev/sdb: data"
     then mkfs.ext4 /dev/sdb
     fi
     echo "/dev/sdb /app ext4 defaults 0 0" >>/etc/fstab
     mount -a
fi
groupadd -g 1000 app 
useradd -g 1000 -u 1000 -d /app app
cp /etc/skel/.* /app
echo "app ALL=(ALL)	NOPASSWD: ALL" >>/etc/sudoers
echo "app:${PASSWD}" | chpasswd
chown -Rvf app:app /app
# install stuff
yum -y update && yum -y install docker tmux git nginx gcc make libffi-devel openssl-devel python-devel
curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
pip install butterfly
/sbin/chkconfig nginx on
/sbin/chkconfig docker on
gpasswd -a app docker
service docker start
service nginx stop
# prepare ssh access
sed  -i -e 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
# assign duckdns hostname
echo "curl http://www.duckdns.org/update?domains=${DDHOST}\&token=${DDTOKEN}\&ip=" >>/etc/rc.d/rc.local
bash /etc/rc.d/rc.local
# restore a backup of letsencrypt if provided
if test -n "$LETGZ"
then wget -O- "$LETGZ" | tar xzf - -C / 
fi
# generate a certificate with letsencrypt
if ! test -d /app/letsencrypt/live
then
  mkdir -p /app/letsencrypt
  chmod 0755 /app /app/letsencrypt
  docker run --rm \
    -p 80:80 -p 443:443 \
    --name letsencrypt \
    -v "/app/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -e "LETSENCRYPT_EMAIL=${LEEMAIL:?email}" \
    -e "LETSENCRYPT_DOMAIN1=${DDHOST}.duckdns.org" \
    quay.io/letsencrypt/letsencrypt:non-interactive auth \
     --email ${LEEMAIL:?email} -d ${DDHOST}.duckdns.org --agree-tos
fi
# fallback to selfsigned if it did not work
if ! test -e /app/letsencrypt/live/${DDHOST}.duckdns.org/fullchain.pem 
then 
  mkdir -p /app/letsencrypt/live/${HOST}.duckdns.org
  printf "\\n\\n\\n\\n\\n\\n\\n" |\
  openssl req -x509 -newkey rsa:2048 \
  -keyout  /app/letsencrypt/live/${HOST}.duckdns.org/privkey.pem \
  -out /app/letsencrypt/live/${HOST}.duckdns.org/fullchain.pem \
  -days 30000 -nodes
fi
chown -Rvf app:app /app
# nginx configuration
cat <<EOF >/etc/nginx/conf.d/proxies.conf
server {
   listen       443;
   server_name  localhost;
   root         html;
    ssl         on;
    ssl_certificate      /app/letsencrypt/live/${HOST}.duckdns.org/fullchain.pem;
    ssl_certificate_key  /app/letsencrypt/live/${HOST}.duckdns.org/privkey.pem;
    ssl_session_timeout  5m;
    ssl_protocols  SSLv2 SSLv3 TLSv1;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers   on;

  location ~ ^/(vnc\.html|websockify.*|include/.*|images/.*)$ {
    proxy_pass http://127.0.0.1:6080;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_read_timeout 43200000;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header Host \$http_host;
    proxy_set_header X-NginX-Proxy true;
  }

  location ~ ^/(index\.html|static/.*|ws.*)?$  {
    proxy_pass http://127.0.0.1:3000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_read_timeout 43200000;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header Host \$http_host;
    proxy_set_header X-NginX-Proxy true;
  }
}
EOF
echo "/usr/local/bin/butterfly.server.py --unsecure --host=127.0.0.1 --port=3000 &" >>/etc/rc.d/rc.local
service nginx start
service sshd restart
bash /etc/rc.d/rc.local
