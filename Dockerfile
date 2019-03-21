FROM happywork/php-fpm:latest

RUN mkdir -p /build

COPY ./composer.json /build/composer.json

WORKDIR /build

RUN php -d memory_limit=-1 `which composer` install
