#!/bin/bash
if ! test -e devenv/_password 
then echo "Please type password for devenv"
     read PASSWORD
     echo $PASSWORD >devenv/_password
fi
test -e base-ssh/id_rsa ||  ssh-keygen -t rsa -f base-ssh/id_rsa -N '' 
cp base-ssh/id_* devenv
for i in \
    base-java base-ssh base-hadoop hadoop \
    zeppelin sparkjobserver  \
    base-scala devenv 
do docker build -t bddk/$i $i || exit 1
done
