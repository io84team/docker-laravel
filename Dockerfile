FROM registry.cn-beijing.aliyuncs.com/rdc-builds/base:1.0

RUN apt-get update -yqq

# Base tools
RUN apt-get install -y software-properties-common \
    vim \
    vim-nox \
    zsh \
    git \
    curl \
    apt-utils \
    build-essential \
    locales \
    libpng-dev \
    wget \
    apt-transport-https \
    lsb-release \
    ca-certificates

RUN DEBIAN_FRONTEND=noninteractive

# PHP
RUN apt-get install -y software-properties-common
RUN yes | add-apt-repository ppa:ondrej/php
RUN gpg --keyserver keyserver.ubuntu.com --recv 4F4EA0AAE5267A6C
RUN gpg --export --armor 4F4EA0AAE5267A6C > key.asc
RUN cat key.asc | sudo apt-key add -
RUN apt-get update
RUN apt-get install -y \
        php7.2-cli \
        php7.2-common \
        php7.2-curl \
        php7.2-intl \
        php7.2-json \
        php7.2-xml \
        php7.2-mbstring \
        php7.2-mysql \
        php7.2-pgsql \
        php7.2-sqlite \
        php7.2-sqlite3 \
        php7.2-zip \
        php7.2-bcmath \
        php7.2-memcached \
        php7.2-gd \
        php7.2-dev \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libsqlite3-dev \
        sqlite3

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN mkdir -p /build

COPY ./composer.json /build/composer.json

WORKDIR /build

RUN php -d memory_limit=-1 `which composer` install

RUN rm -rf /root/.composer