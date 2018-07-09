FROM php:7.1-apache

WORKDIR /var/www/html

RUN rm /etc/apache2/sites-enabled/000-default.conf

RUN docker-php-ext-install mysqli pgsql pdo_pgsql

RUN openssl req -x509 -nodes -days 36500 -newkey rsa:4096 -keyout /etc/ssl/server.key -out /etc/ssl/server.crt -subj "/C=AA/ST=AA/L=Internet/O=Docker/OU=www.miflop.com/CN=miflop" \
    && a2enmod ssl

ADD miflopssl.conf /etc/apache2/sites-enabled/

EXPOSE 443

CMD ["apache2-foreground"]
