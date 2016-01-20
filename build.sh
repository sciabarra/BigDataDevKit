#!/bin/bash
if ! test $(id -u)  == "1000"
then echo "Please run this script as 'app' user" ; exit 1
fi
if ! test -e devenv/_password 
then echo "Please type password for devenv"
     read PASSWORD
     echo $PASSWORD >devenv/_password
fi
test -e base-ssh/id_rsa ||  ssh-keygen -t rsa -f base-ssh/id_rsa -N '' 
cp base-ssh/id_* devenv
mkdir -p $HOME/Dropbox/IdeaProjects $HOME/Dropbox/zeppelin/notebook
for i in \
    base-java base-ssh base-hadoop hadoop \
    zeppelin sparkjobserver  \
    base-scala base-novnc devenv 
do docker build -t bddk/$i $i || exit 1
done
if ! test -e $HOME/dropbox.py ; then
wget --no-check-certificate -O$HOME/dropbox.py https://www.dropbox.com/download?dl=packages/dropbox.py 
chmod +x $HOME/dropbox.py
echo Please configure Dropbox to save your data using $HOME/dropbox.py
fi

