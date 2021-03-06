FROM php:8.0.1-apache 

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

RUN apt-get update \
    && apt-get install -y \
        libmcrypt-dev \
        libz-dev \
        libzip-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libgmp-dev \
        git \
        wget
        
RUN yes "" | pecl install mcrypt \
    && yes "" | pecl install redis

RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/freetype2/freetype \
        --with-jpeg-dir=/usr/include

RUN docker-php-ext-install \
        mbstring \
        pdo_mysql \
        zip \
        opcache \
        gd \
        gmp

RUN docker-php-ext-enable redis \
        mcrypt

RUN apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite

RUN mkdir -p /app \
    && chown -R www-data:www-data /app

VOLUME /app
WORKDIR /app

RUN rm -rf /var/www/html \
    && ln -s /app/public /var/www/html \
    && chown -R www-data:www-data /var/www/html
