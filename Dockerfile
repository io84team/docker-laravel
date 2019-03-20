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
RUN apt-get install -y \
        php7-cli \
        php7-common \
        php7-curl \
        php7-intl \
        php7-json \
        php7-xml \
        php7-mbstring \
        php7-mysql \
        php7-pgsql \
        php7-sqlite \
        php7-sqlite3 \
        php7-zip \
        php7-bcmath \
        php7-memcached \
        php7-gd \
        php7-dev \
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