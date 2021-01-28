# NPMパッケージの事前ビルド
FROM node:14.15.4-alpine AS nodejs
ENV APP_ROOT /usr/src/laravel-app

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

COPY package.json package-lock.json* $APP_ROOT/

RUN apk add --no-cache git && \
    npm install --no-progress

COPY . $APP_ROOT
RUN npm run production

# PHPコンテナの作成
FROM php:7.4.14-fpm-alpine
ENV APP_ROOT /usr/src/laravel-app
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

COPY composer.json composer.lock* $APP_ROOT/
COPY docker/php/etc/supervisor/conf.d/queue.conf /etc/supervisor/conf.d/queue.conf

SHELL ["/bin/sh", "-o", "pipefail", "-c"]
RUN apk update && \
    apk add --no-cache git mysql-client php7-sockets supervisor \
    bash=5.1.0-r0 && \
    git clone https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis && \
    docker-php-ext-install -j$(nproc) pdo_mysql sockets redis && \
    echo files=/etc/supervisor/conf.d/*.conf >> /etc/supervisord.conf && \
    wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q \
    | php -- --quiet --install-dir=/usr/local/bin --filename composer && \
    composer install --no-interaction --no-autoloader --no-scripts

COPY --from=nodejs $APP_ROOT $APP_ROOT
COPY --from=nodejs /usr/local/bin/node /usr/local/bin/
COPY --from=nodejs /usr/local/lib/ /usr/local/lib/
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

RUN composer dump-autoload --optimize

VOLUME $APP_ROOT/public/assets
