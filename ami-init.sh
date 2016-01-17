#!/bin/bash
# change password here
echo "ec2-user:changeme" | chpasswd
# end changes
yum -y update && yum -y install docker git nginx
service docker start
sed  -i -e 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
service sshd restart
mkdir /etc/cert
printf "\\n\\n\\n\\n\\n\\n\\n" | openssl req -x509 -newkey rsa:2048 -keyout /etc/cert/cert.key -out /etc/cert/cert.pem -days 30000 -nodes
docker pull nathanleclaire/wetty
docker run --name term-p "1443:1443" -v /etc/cert:/etc/cert -u term -d nathanleclaire/wetty app.js --port 1443 --sshhost $(hostname -I | awk '{ print $1}') --sshuser ec2-user --sslkey /etc/cert/cert.key --sslcert /etc/cert/cert.pem
# end script
