#!/bin/bash
# change password here
echo "ec2-user:changeme" | chpasswd
yum -y update && yum -y install docker git
service docker start
sed  -i -e 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
service sshd restart
docker run --name term -p "8080:8080" -dt nathanleclaire/wetty app.js --port 8080 --sshhost $(hostname -I | awk '{ print $1}') --sshuser ec2-user
