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
for i in \
    base-java base-ssh base-hadoop hadoop \
    zeppelin sparkjobserver  \
    base-scala base-novnc devenv 
do docker build -t bddk/$i $i || exit 1
done
if ! grep dropbox /etc/rc.d/rc.local >/dev/null
then sudo wget --no-check-certificate -O/usr/bin/dropbox https://www.dropbox.com/download?dl=packages/dropbox.py 
     sudo chmod +x /usr/bin/dropbox
     cd $HOME ;  wget -O - "http://www.dropbox.com/download?plat=lnx.x86_64" | tar xz
     echo "su - app -c '/usr/bin/dropbox start'" | sudo tee -a /etc/rc.d/rc.local >/dev/null
     echo Please configure Dropbox to save your data running $HOME/.dropbox-dist/dropboxd
fi
if ! grep docker-compose /etc/rc.d/rc.local >/dev/null
then echo "Build complete. You can start with 'docker-compose up' or reboot to start automatically"
     echo "/usr/bin/docker-compose -f $(pwd)/docker-compose.yml up -d" | sudo tee -a /etc/rc.d/rc.local >/dev/null
fi

