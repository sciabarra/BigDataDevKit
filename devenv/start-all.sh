#!/bin/bash
sudo /etc/init.d/ssh start 
export USER=app
rm -f /tmp/.X0-lock /tmp/.X11-unix/X0 /app/home/.ssh/known_hosts
vncserver -geometry 1280x720 :0 
cd /app/ ; ./noVNC/utils/launch.sh
