FROM php:7.1-apache

# ------------ Basic setup ------------ #

RUN apt-get update \
 && apt-get install -y wget git gnupg zlib1g-dev libmcrypt-dev libldap2-dev libicu-dev g++ curl apt-transport-https debconf-utils unixodbc unixodbc-dev \
 && docker-php-ext-install zip \
 && docker-php-ext-install intl \
 && docker-php-ext-configure intl \
 && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
 && docker-php-ext-install ldap \
 && docker-php-ext-install pdo pdo_mysql mcrypt \
 && pecl install sqlsrv pdo_sqlsrv \
 && rm -rf /var/lib/apt/lists/* \
 && a2enmod rewrite \
 && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
 && mv /var/www/html /var/www/public \
 && curl -sS https://getcomposer.org/installer \
| php -- --install-dir=/usr/local/bin --filename=composer

# ------------ Install MS SQL client deps ------------ #

# adding custom MS repository
# this installs MS ODBC driver 17 which does not work with pdo sqlsrv yet
# we later downgrade to MS ODBC driver 13 but keep this as well
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# Debian 9 msodbcsql : https://packages.microsoft.com/debian/9/prod/pool/main/m/msodbcsql/
RUN wget https://packages.microsoft.com/debian/9/prod/pool/main/m/msodbcsql17/msodbcsql17_17.2.0.1-1_amd64.deb
RUN ACCEPT_EULA=Y dpkg -i msodbcsql17_17.2.0.1-1_amd64.deb

RUN apt-get -y install locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

RUN echo "extension=sqlsrv.so" >> /usr/local/etc/php/conf.d/docker-php-ext-sqlsrv.ini
RUN echo "extension=pdo_sqlsrv.so" >> /usr/local/etc/php/conf.d/docker-php-ext-pdo-sqlsrv.ini

WORKDIR /var/www/html

RUN docker-php-ext-install mysqli

RUN openssl req -x509 -nodes -days 36500 -newkey rsa:4096 -keyout /etc/ssl/server.key -out /etc/ssl/server.crt -subj "/C=AA/ST=AA/L=Internet/O=Docker/OU=www.miflop.com/CN=miflop" \
    && a2enmod ssl

ADD miflopssl.conf /etc/apache2/sites-enabled/

EXPOSE 443

CMD ["apache2-foreground"]
