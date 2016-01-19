FROM shaz/1-zeppelin
USER app
RUN sudo yum install -y which
WORKDIR /app/
EXPOSE 8000
VOLUME /app/zeppelin/notebook
ENTRYPOINT /app/zeppelin/bin/zeppelin.sh
