FROM shaz/1-spark
USER app
RUN sudo yum install -y which
WORKDIR /app
CMD sudo /usr/sbin/sshd ; tail -f /dev/null
