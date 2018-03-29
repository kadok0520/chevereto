FROM php:7-apache
MAINTAINER ""

ENV CHEVERETO_APACHE_RUN_USER www-data
ENV CHEVERETO_VERSION 1.0.9

# DB connection environment variables
ENV CHEVERETO_DB_HOST db
ENV CHEVERETO_DB_USERNAME chevereto
ENV CHEVERETO_DB_PASSWORD chevereto
ENV CHEVERETO_DB_NAME chevereto
ENV CHEVERETO_DB_PREFIX chv_

# Install required packages
RUN apt-get update && apt-get install -y libgd-dev

# Install php extensions that we need for Chevereto and its installer
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install \
    gd \
    mysqli \
    pdo \
    pdo_mysql
 
# Enable mod_rewrite for Chevereto
RUN a2enmod rewrite

# Download installer script
USER www-data
WORKDIR /var/www/html/

RUN curl -O chevereto.tgz https://github.com/Chevereto/Chevereto-Free/archive/1.0.9.tar.gz &&
    tar zxvf chevereto.tgz &&
    mv Chevereto-Free-1.0.9 Chevereto &&
    
#COPY settings.php app/settings.php

# Expose the image directory
VOLUME /var/www/html/Chevereto/images

# Change back to root user for normal Service start up
USER root
