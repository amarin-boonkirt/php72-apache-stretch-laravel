FROM php:7.2-apache-stretch

WORKDIR "/var/www"

# Fix debconf warnings upon build
ARG TZ=America/Chicago
ARG LOCALE=en_US
ARG WEB_UID=1000
ARG WEB_GID=1000

RUN usermod -u ${WEB_UID} www-data
RUN groupmod -g ${WEB_GID} www-data

RUN apt-get update \
    && apt-get install -y locales locales-all nano gettext-base git libmcrypt-dev mysql-client mcrypt apt-utils zlib1g-dev unzip libmemcached-dev libjpeg-dev libpng-dev \
    && pecl install memcached \
    && docker-php-ext-configure gd --with-jpeg-dir=/usr \
    && docker-php-ext-install mbstring tokenizer mysqli pdo_mysql zip sockets exif gd \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN sed -i "s/#\ ${LOCALE}\.UTF-8\ UTF-8/${LOCALE}.UTF-8\ UTF-8/g" /etc/locale.gen && locale-gen

ENV LC_ALL ${LOCALE}.UTF-8
ENV TZ=${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN chown -R ${WEB_GID}:${WEB_UID} /var/www
