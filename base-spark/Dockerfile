FROM shaz/1-ssh
WORKDIR /app/
USER app
COPY *.txt /app/
RUN wget --progress=dot:giga $(cat myurl.txt 2>/dev/null || cat url.txt) 
RUN sudo chown -Rvf app /app ; tar xzvf spark-1.5.2-bin-without-hadoop.tgz ; mv /app/spark-1.5.2-bin-without-hadoop /app/spark ; rm *.tgz
