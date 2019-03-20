FROM registry.cn-beijing.aliyuncs.com/rdc-builds/php:7.1 

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
        
RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/freetype2/freetype \
        --with-jpeg-dir=/usr/include

RUN docker-php-ext-install \
        mbstring \
        pdo_mysql \
        zip \
        opcache \
        mcrypt \
        redis \
        gd \
        gmp

RUN apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN mkdir -p /opt/build

COPY ./composer.json /opt/build/composer.json

WORKDIR /opt/build

RUN php -d memory_limit=-1 `which composer` install

RUN rm -rf /usr/src /root/.composer