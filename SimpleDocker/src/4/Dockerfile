FROM nginx

WORKDIR /server/

COPY ./server/hello.c /server/
COPY ./server/ss.sh /server/
COPY ./server/nginx/nginx.conf /etc/nginx/

RUN apt-get -y update && apt-get install -y gcc libfcgi-dev spawn-fcgi make nano

CMD ["/bin/bash", "./ss.sh"]