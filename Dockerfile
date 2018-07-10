FROM php:5.6-apache

# WORKDIR /var/www/html

# apt utils
RUN apt-get update && \
    apt-get install -y apt-utils && \
    rm -rf /var/lib/apt/lists/*

# mysql / mysqli
RUN docker-php-ext-install mysql mysqli
RUN docker-php-ext-install pdo_mysql

# mssql
RUN apt-get update && \
    apt-get install -y freetds-dev && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure mssql --with-libdir=lib/x86_64-linux-gnu && \
    docker-php-ext-install mssql

RUN docker-php-ext-configure pdo_dblib --with-libdir=lib/x86_64-linux-gnu && \
    docker-php-ext-install pdo_dblib

# rewrite
RUN a2enmod rewrite

# libpng
RUN apt-get update && \
    apt-get install -y sendmail libpng-dev

# zlib1g
RUN apt-get update && \
    apt-get install -y zlib1g-dev

# zlib
RUN apt-get update && \
    apt-get install -y zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install zip

# socket
RUN docker-php-ext-install sockets

# mbstring
RUN docker-php-ext-install mbstring

# zip
RUN docker-php-ext-install zip

# gd
RUN docker-php-ext-install gd

# Ini
COPY php.ini /usr/local/etc/php/

# RUN docker-php-ext-install mysqli

RUN openssl req -x509 -nodes -days 36500 -newkey rsa:4096 -keyout /etc/ssl/server.key -out /etc/ssl/server.crt -subj "/C=AA/ST=AA/L=Internet/O=Docker/OU=www.miflop.com/CN=miflop" \
    && a2enmod ssl

RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD miflopssl.conf /etc/apache2/sites-enabled/

EXPOSE 443

CMD ["apache2-foreground"]
