FROM bddk/base-hadoop
WORKDIR /app/
USER app
VOLUME /app/Dropbox
COPY start-hadoop.sh /app/hadoop/
RUN echo "export JAVA_HOME=/usr" >>/app/hadoop/etc/hadoop/hadoop-env.sh  
COPY *.xml /app/hadoop/etc/hadoop/
RUN /app/hadoop/bin/hdfs namenode -format
EXPOSE 50010 50020 50070 50075 50090
EXPOSE 19888
EXPOSE 8020 8030 8031 8032 8033 8040 8042 8088
EXPOSE 49707 2122
CMD /app/hadoop/start-hadoop.sh ; \
tail -f /dev/null 
