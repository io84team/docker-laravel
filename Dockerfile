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

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen

RUN update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

# Pythone
RUN apt-get install -y python2.7 \
    python-powerline \
    python-pip

# NPM
COPY node8x.sources.list /etc/apt/node8x.sources.list
RUN cat /etc/apt/node8x.sources.list >> /etc/apt/sources.list

RUN gpg --keyserver wwwkeys.pgp.net --recv-keys 1655A0AB68576280
RUN gpg --export -a 1655A0AB68576280 | apt-key add -
RUN apt-get update -yqq

RUN apt-get install -y --allow-unauthenticated nodejs \
    && npm install -g cnpm --registry=https://registry.npm.taobao.org

# PHP
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://mirror.xtom.com.hk/sury/php/apt.gpg
RUN sh -c 'echo "deb https://mirror.xtom.com.hk/sury/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'   
RUN apt-get update
RUN apt-get install -y --allow-downgrades --allow-remove-essential \
        --allow-change-held-packages \
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