#!/bin/bash
sudo /etc/init.d/ssh start 
export USER=app
rm -f /tmp/.X0-lock /tmp/.X11-unix/X0 /app/home/.ssh/known_hosts
vncserver -geometry 1024x576 :0 
cd /app/wetty ; nodejs app.js -p 3000 & 
cd /app/ ; ./noVNC/utils/launch.sh
