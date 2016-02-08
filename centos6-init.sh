#!/bin/bash
PASSWD=${1:?specify the password of the app user}
LEDOMAIN=${2:?fqdn of the host - fixed ip}
LEEMAIL=${3:?your email for letsencrypt}
# end changes
# set app directory
mkdir /app 
groupadd -g 1000 app 
useradd -g 1000 -u 1000 -d /app app
cp /etc/skel/.* /app
echo "app ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
echo "app:${PASSWD}" | chpasswd
chown -Rvf app:app /app
# install stuff
rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
yum -y update && yum -y install docker-io tmux git nginx18 gcc make libffi-devel openssl-devel python-devel
curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
pip install butterfly
/sbin/chkconfig nginx on
/sbin/chkconfig docker on
gpasswd -a app docker
service docker start
service nginx stop
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
    -e "LETSENCRYPT_DOMAIN1=${LEDOMAIN}" \
    quay.io/letsencrypt/letsencrypt:non-interactive auth \
     --email ${LEEMAIL:?email} -d ${LEDOMAIN} --agree-tos
fi
chown -Rvf app:app /app
# nginx configuration
cat <<EOF >/etc/nginx/conf.d/proxies.conf
server {
   listen       443;
   server_name  localhost;
   root         html;
    ssl         on;
    ssl_certificate      /app/letsencrypt/live/${LEDOMAIN}/fullchain.pem;
    ssl_certificate_key  /app/letsencrypt/live/${LEDOMAIN}/privkey.pem;
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

cat <<EOF >/etc/init.d/butterfly
#!/bin/bash
# chkconfig: - 50 50 
# description: Start/Stop butterfly
case "\$1" in
    start)
	if test -e /var/run/butterfly.pid -a -e /proc/\$(cat /var/run/butterfly.pid)
        then echo Butterfly is running
        else /usr/local/bin/butterfly.server.py --unsecure --host=127.0.0.1 --port=3000 &
             echo \$! >/var/run/butterfly.pid
        fi
        ;;
    stop)
       	if test -e /var/run/butterfly.pid -a -e /proc/\$(cat /var/run/butterfly.pid)
        then kill -9 \$(cat /var/run/butterfly.pid) ; rm /var/run/butterfly.pid
        else echo Butterfly is not running
        fi
       ;;
    status)
       	if test -e /var/run/butterfly.pid -a -e /proc/\$(cat /var/run/butterfly.pid)
        then echo Butterfly is running
        else echo Butterfly is not running
        fi
        ;;
    *)
        echo "Usage: butterfly {start|stop|status}"
        exit 1
        ;;
esac
exit \$?
EOF
chmod +x /etc/init.d/butterfly
/sbin/chkconfig butterfly
service buttefly start
service nginx start
