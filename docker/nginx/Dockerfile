FROM nginx:1.18.0-alpine
ENV APP_ROOT /usr/src/laravel-app

RUN mkdir -p $APP_ROOT

RUN apk update && \
    apk add --no-cache bash
COPY ./public $APP_ROOT/public
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80