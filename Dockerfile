FROM happywork/php-fpm:latest

RUN mkdir -p /build

COPY ./composer.json /build/composer.json

WORKDIR /build

