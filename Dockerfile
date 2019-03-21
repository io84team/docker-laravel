FROM php:alpine

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /build

COPY ./composer.json /build/composer.json

WORKDIR /build

