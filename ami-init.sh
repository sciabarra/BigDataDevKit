#!/bin/bash
# change password here
echo "ec2-user:${PASSWORD:-changeMeRightNow}" | chpasswd
yum -y update && yum -y install docker git nginx
/sbin/chkconfig nginx on
/sbin/chkconfig docker on
service docker start
service nginx stop
sed  -i -e 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
# assign duckdns hostname
echo "curl http://www.duckdns.org/update?domains=${HOST:?duckdns hostname}\&token=${TOKEN:?ducns toker}\&ip=" >>/etc/rc.d/rc.local
bash /etc/rc.d/rc.local
docker run --rm -p 80:80 -p 443:443 --name letsencrypt \
    -v /etc/letsencrypt:/etc/letsencrypt \
    -e "LETSENCRYPT_EMAIL=${EMAIL:?email}" \
    -e "LETSENCRYPT_DOMAIN1=${HOST}.duckdns.org" \
    blacklabelops/letsencrypt install
cat <<EOF >/etc/nginx/conf.d/wetty.conf
server {
   listen       443;
   server_name  localhost;
   root         html;
    ssl         on;
    ssl_certificate      /etc/letsencrypt/live/${HOST}.duckdns.org/fullchain.pem;
    ssl_certificate_key  /etc/letsencrypt/live/${HOST}.duckdns.org/privkey.pem;
    ssl_session_timeout  5m;
    ssl_protocols  SSLv2 SSLv3 TLSv1;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers   on;
   location ^~ / {
    proxy_pass http://127.0.0.1:3000/;
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
docker pull nathanleclaire/wetty
docker run --name term -p "3000:3000" -u term -d \
--restart=always nathanleclaire/wetty app.js --port 3000 \
--sshhost $(hostname -I | awk '{ print $1}') \
--sshuser ec2-user
service nginx start
service sshd restart
