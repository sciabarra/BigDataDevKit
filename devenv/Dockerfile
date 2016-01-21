FROM bddk/base-novnc
USER app
WORKDIR /app
COPY _password /app/_password 
COPY start-all.sh /app/bin/
RUN echo "app:$(cat /app/_password)" | sudo chpasswd ;\
    mkdir .vnc ;\
    printf "$(cat /app/_password)"'\n'"$(cat /app/_password)"'\nn\n' | vncpasswd -f  >.vnc/passwd ;\
    chmod 0600 .vnc/passwd ;\
    rm /app/_password ;\
    mkdir .ammonite .ssh ;\
    echo 'source /etc/profile' >.bashrc 
COPY predef.scala .ammonite/
COPY id_* .ssh/
EXPOSE 6080 5900
VOLUME /app/Dropbox
CMD bash /app/bin/start-all.sh
