FROM shaz/1-ssh
WORKDIR /app/
USER app
COPY *.txt /app/
RUN wget --progress=dot:giga $(cat myurl.txt 2>/dev/null || cat url.txt)
RUN sudo chown -Rvf app /app ; tar xzvf zeppelin-0.5.5-incubating-bin-all.tgz ; mv /app/zeppelin-0.5.5-incubating-bin-all /app/zeppelin ; rm *.tgz
