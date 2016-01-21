FROM bddk/base-java
WORKDIR /app/
USER app
RUN sudo yum install -y which
COPY *.txt /app/
RUN wget --progress=dot:giga $(cat myurl.txt 2>/dev/null || cat url.txt)
RUN sudo chown -Rvf app /app ; tar xzvf zeppelin-0.5.5-incubating-bin-all.tgz ; mv /app/zeppelin-0.5.5-incubating-bin-all /app/zeppelin ; rm *.tgz
EXPOSE 8080
VOLUME /app/Dropbox
ENTRYPOINT /app/zeppelin/bin/zeppelin.sh
