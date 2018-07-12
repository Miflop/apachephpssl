# FROM php:7.1-apache

# WORKDIR /var/www/html

# RUN sudo pecl install sqlsrv
# RUN sudo pecl install pdo_sqlsrv
# RUN echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini
# RUN echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini
# RUN apt-get install libapache2-mod-php7.1 apache2
# RUN a2dismod mpm_event
# RUN a2enmod mpm_prefork
# RUN a2enmod php7.1
# RUN echo "extension=pdo_sqlsrv.so" >> /etc/php/7.1/apache2/conf.d/30-pdo_sqlsrv.ini
# RUN echo "extension=sqlsrv.so" >> /etc/php/7.1/apache2/conf.d/20-sqlsrv.ini



FROM php:5.6.36-fpm
RUN apt-get update ;\
RUN apt-get install -y --no-install-recommends \
RUN freetds-dev freetds-bin freetds-common libdbd-freetds libsybdb5 libqt4-sql-tds libqt5sql5-tds ;\
RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so ;\
RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a ;\
RUN RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mssql ;\
RUN docker-php-ext-configure mssql

RUN openssl req -x509 -nodes -days 36500 -newkey rsa:4096 -keyout /etc/ssl/server.key -out /etc/ssl/server.crt -subj "/C=AA/ST=AA/L=Internet/O=Docker/OU=www.miflop.com/CN=miflop" \
    && a2enmod ssl

ADD miflopssl.conf /etc/apache2/sites-enabled/

EXPOSE 443

CMD ["apache2-foreground"]
