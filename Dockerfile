FROM nginx:alpine

WORKDIR /app

COPY ./static .
COPY ./conf/nginx.conf /etc/nginx/nginx.conf