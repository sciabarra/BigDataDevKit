#!/bin/bash
# to be run in the Amazon Linux Image
# change "changeme" in your password
echo "ec2-user:${PASSWORD:-changeme}" | chpasswd
yum update -y && yum install -y docker git nginx gcc-c++ make
curl --silent --location https://rpm.nodesource.com/setup_5.x | bash -
yum install -y nodejs
printf "\\n\\n\\n\\n\\n\\n\\n" | openssl req -x509 -newkey rsa:2048 -keyout /etc/nginx/cert.key -out /etc/nginx/cert.pem -days 30000 -nodes
/sbin/chkconfig nginx on
cd /tmp
git clone https://github.com/krishnasrinivas/wetty
npm install -g pty
cd wetty
npm install -g
echo "/usr/bin/node /usr/lib/node_modules/wetty/app.js -p 3000 &"  >>/etc/rc.d/rc.local
cat <<EOF >/etc/nginx/conf.d/wetty.conf
server {
   listen       443;
   server_name  localhost;
   root         html;
    ssl                  on;
    ssl_certificate      cert.pem;
    ssl_certificate_key  cert.key;
    ssl_session_timeout  5m;
    ssl_protocols  SSLv2 SSLv3 TLSv1;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers   on;
   location ^~ /wetty/ {
    proxy_pass http://127.0.0.1:3000/wetty/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_read_timeout 43200000;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-NginX-Proxy true;
  }
}
EOF
service nginx start
bash /etc/rc.d/rc.local
