#!/bin/bash
yum -y update && yum -y install docker git
service docker start
docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
docker run --name term -p 3000 --expose 3000 -dt nathanleclaire/wetty --sshhost $(hostmame -I) --sshuser ec2-user
