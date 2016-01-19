FROM centos:6.7
RUN yum -y update && yum clean all && yum install -y rsync openssh-server openssh-clients sudo net-tools telnet wget tar gzip which less
COPY *.txt /
RUN wget --progress=dot:giga --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$(cat myurl.txt 2>/dev/null || cat url.txt)" ; rpm -ihv jdk* ; rm -f -v jdk*
ENV JAVA_HOME /usr
ENV PATH $PATH:$JAVA_HOME/bin
RUN groupadd -g 1000 app && useradd -g 1000 -u 1000 -d /app app
RUN echo "app ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers ; sed -i 's/requiretty/!requiretty/' /etc/sudoers
