FROM bddk/base-java
COPY config id_rsa id_rsa.pub /root/.ssh/ 
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys ;\
 cp -Rvf /root/.ssh /app/.ssh ;\
 chmod 0600 /root/.ssh/* /app/.ssh/* ;\
 mkdir /app/data ;\
 chown app -Rvf /app  
RUN /etc/init.d/sshd start ; /etc/init.d/sshd stop
WORKDIR /app
USER app
CMD sudo /usr/sbin/sshd ; tail -f /dev/null
EXPOSE 22
