FROM shaz/1-intellij
RUN groupadd -g 1000 app && useradd -g 1000 -u 1000 -d /app app -m -s /bin/bash ; chown -Rv app:app /app/
RUN echo "app ALL=(ALL)	NOPASSWD: ALL" >>/etc/sudoers ; sed -i 's/requiretty/!requiretty/' /etc/sudoers 
RUN apt-get -y install python-numpy
RUN wget --no-check-certificate -O/usr/local/bin/dropbox https://www.dropbox.com/download?dl=packages/dropbox.py ; chmod +x /usr/local/bin/dropbox
USER app
WORKDIR /app
RUN git clone https://github.com/kanaka/noVNC noVNC ; git clone https://github.com/kanaka/websockify noVNC/utils/websockify
RUN git clone https://github.com/krishnasrinivas/wetty ; cd wetty ; npm install
RUN wget --no-check-certificate -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
RUN echo 'bash' >/app/.shinit ; mkdir .ssh
