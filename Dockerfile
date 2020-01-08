FROM php:7.4-apache
MAINTAINER Lukas Paiskr <lukas@pasysdev.cz>

RUN docker-php-source extract \
&& apt-get update \
&& apt-get install sudo \
&& apt-get -y install cron \
&& apt-get -y install curl \
&& apt-get -y install git \
&& apt-get install -y mc \
&& docker-php-ext-install mysqli pdo pdo_mysql \
&& a2enmod rewrite \
&& a2enmod ssl \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& docker-php-source delete

# xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

ARG XDEBUG_INI=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo "xdebug.default_enable = off" >> ${XDEBUG_INI} \
    && echo "xdebug.remote_enable = on" >> ${XDEBUG_INI} \
    && echo "xdebug.remote_autostart = off" >> ${XDEBUG_INI} \
    && echo "xdebug.remote_connect_back = on" >> ${XDEBUG_INI} \
    && echo "xdebug.remote_port = 9001" >> ${XDEBUG_INI} \
    && echo "xdebug.idekey = docker" >> ${XDEBUG_INI}

# Copy custom php.ini file
COPY /build/docker/developer/php.ini /usr/local/etc/php/php.ini

COPY . /var/www/html/

# Run the command on container startup
CMD ./build/docker/developer/start.sh
