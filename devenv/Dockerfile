FROM shaz/1-wettynovnc
WORKDIR /app
COPY _password /app/_password 
COPY start-all.sh /app/bin/
RUN mkdir /app/home ;\
  sudo usermod app -d /app/home;\
  echo "app:$(cat /app/_password)" | sudo chpasswd ;
WORKDIR /app/home
RUN mkdir .vnc ;\
    printf "$(cat /app/_password)"'\n'"$(cat /app/_password)"'\nn\n' | vncpasswd -f  >.vnc/passwd ;\
    chmod 0600 .vnc/passwd ;\
    rm /app/_password
RUN mkdir .ammonite 
COPY predef.scala .ammonite/
ENV ENV=/app/.shinit
RUN echo 'bash' >.shinit ; echo 'source /etc/profile' >.bashrc ; mkdir .ssh
COPY id_* .ssh/
EXPOSE 6080 3000 5900
VOLUME /app/home
CMD bash /app/bin/start-all.sh
