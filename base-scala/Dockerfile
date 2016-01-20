FROM debian:jessie
RUN sed -i -e 's/httpredir.debian.org/ftp.us.debian.org/' /etc/apt/sources.list 
RUN groupadd -g 1000 app && useradd -g 1000 -u 1000 -d /app app -m -s /bin/bash ; chown -Rv app:app /app/
RUN apt-get update && apt-get -y install git wget sudo jwm curl vim net-tools python make gcc g++ ssh iceweasel tightvncserver tmux xterm chromium chromium-l10n
RUN echo "app ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers ; sed -i 's/requiretty/!requiretty/' /etc/sudoers
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash - ; apt-get -y install nodejs
COPY *.txt /
RUN wget --progress=dot:giga --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$(cat myjdk.txt 2>/dev/null || cat jdk.txt)" 
RUN wget --progress=dot:giga $(cat myide.txt || cat ide.txt)
RUN mkdir /usr/java ; tar xzvf jdk-*.tar.gz -C /usr/java ; tar xzvf ideaIC-*.tar.gz -C /usr/java ; rm *.tar.gz 
RUN ( echo export JAVA_HOME=$(ls -1d /usr/java/jdk*) ; echo export IDEA_HOME=$(ls -1d /usr/java/idea*) ; echo PATH='$JAVA_HOME/bin:$IDEA_HOME/bin:/usr/local/bin:$PATH' )>/etc/profile.d/java.sh
COPY system.jwmrc /etc/jwm/system.jwmrc
COPY sbt-launch.jar idea /usr/bin/
RUN curl -L -o /usr/bin/amm https://git.io/v0FGO ;\
    curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/bin/sbt ;\
    chmod 0755 /usr/bin/sbt  /usr/bin/idea /usr/bin/amm
