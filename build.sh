#!/bin/bash
if ! test -e devenv/_password 
then echo "Please type password for devenv"
     read PASSWORD
     echo $PASSWORD >devenv/_password
fi
test -e base-ssh/id_rsa ||  ssh-keygen -t rsa -f base-ssh/id_rsa -N '' 
cp base-ssh/id_* devenv
docker build -t shaz/1-java base-java
docker build -t shaz/1-ssh base-ssh
docker build -t shaz/1-hadoop base-hadoop
docker build -t shaz/1-spark base-spark 
docker build -t shaz/1-zeppelin base-zeppelin
docker build -t shaz/1-intellij base-intellij
docker build -t shaz/1-wettynovnc base-wettynovnc
docker images | grep shaz/1
docker-compose build
