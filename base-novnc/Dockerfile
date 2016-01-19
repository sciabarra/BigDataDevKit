FROM bddk/base-novnc
RUN apt-get -y install python-numpy
USER app
WORKDIR /app
RUN git clone https://github.com/kanaka/noVNC noVNC ; git clone https://github.com/kanaka/websockify noVNC/utils/websockify
RUN wget --no-check-certificate -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
RUN echo 'bash' >/app/.shinit ; mkdir .ssh
