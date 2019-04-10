FROM registry.cn-beijing.aliyuncs.com/rdc-builds/php:7.1 

WORKDIR /build

COPY ./composer.json /build/composer.json

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
        wget \

    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/freetype2/freetype \
        --with-jpeg-dir=/usr/include \

    && docker-php-ext-install \
        mbstring \
        pdo_mysql \
        zip \
        opcache \
        mcrypt \
        redis \
        gd \
        gmp \

    && apt-get clean \
    && apt-get autoclean \

    && php -d memory_limit=-1 `which composer` self-update \
    && php -d memory_limit=-1 `which composer` install \

    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*