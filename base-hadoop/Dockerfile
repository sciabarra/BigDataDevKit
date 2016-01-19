FROM bddk/base-ssh
WORKDIR /app/
COPY *.txt /app/
RUN wget --progress=dot:giga $(cat myurl.txt 2>/dev/null || cat url.txt)
USER app
RUN sudo chown -Rvf app /app ; tar xzvf hadoop-2.6.2.tar.gz ; mv /app/hadoop-2.6.2 /app/hadoop ; rm *.tar.gz 
