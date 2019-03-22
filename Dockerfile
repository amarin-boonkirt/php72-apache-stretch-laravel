FROM php:7.2-apache-stretch

WORKDIR "/var/www"

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive
ARG WEB_UID=1000
ARG WEB_GID=1000

RUN usermod -u ${WEB_UID} www-data
RUN groupmod -g ${WEB_GID} www-data

RUN apt-get update \
    && apt-get install -y nano gettext-base git libmcrypt-dev mysql-client mcrypt apt-utils zlib1g-dev unzip libmemcached-dev libpng-dev \
    && pecl install memcached \
    && docker-php-ext-install mbstring tokenizer mysqli pdo_mysql zip sockets exif gd


RUN chown -R ${WEB_GID}:${WEB_UID} /var/www
