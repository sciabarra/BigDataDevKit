FROM bddk/base-scala
RUN apt-get -y install python-numpy
USER app
WORKDIR /app
RUN git clone https://github.com/kanaka/noVNC noVNC 
RUN git clone https://github.com/kanaka/websockify noVNC/utils/websockify
ENV ENV=/app/.shinit
RUN echo 'bash' >/app/.shinit 
