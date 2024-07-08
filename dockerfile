# Baseimage PHP 7.4 with Apache2 on Debian 11 bullseye:
FROM php:7.4-apache
LABEL authors='Christos Sidiropoulos <Christos.Sidiropoulos@uni-mannheim.de>'

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Workaround for "E: Package 'php-XXX' has no installation candidate" from https://hub.docker.com/_/php/ :
RUN rm /etc/apt/preferences.d/no-debian-php

# Upgrade system and install further php dependencies & composer & image processing setup:
RUN apt-get update \
&& apt-get -y upgrade \
&& apt-get -y install -y --no-install-recommends \
# database & php dependencies:
    mariadb-client \
    libapache2-mod-php \
    php-curl \
    php-gd \
    php-intl \
    php-mysql \
    php-xml \
    php-zip \
    locales \
    # some dependencies:
    ghostscript \
    graphicsmagick \
    graphicsmagick-imagemagick-compat \
    # for newest composer version:
    git \
    unzip \
    # for docker entrypoint:
    wait-for-it \
    # newest composer version:
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir /usr/bin --filename composer \
    && php -r "unlink('composer-setup.php');" \
    # cleanup:
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # apache mods:
    && a2enmod headers \
    && a2enmod expires \
    && a2enmod rewrite \
    # Gen locales:
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen

# Install and setup Ilias:
RUN echo "<VirtualHost *:80>\
    ServerAdmin webmaster@example.com\
\
    DocumentRoot /var/www/html/\
    <Directory /var/www/html/>\
        Options FollowSymLinks -Indexes\
        AllowOverride All\
        Require all granted\
    </Directory>\
\
    # Possible values include: debug, info, notice, warn, error, crit, alert, emerg.\
    LogLevel warn\
\
    ErrorLog /var/log/apache2/error.log\
    CustomLog /var/log/apache2/access.log combined\
</VirtualHost>\
" > /etc/apache2/sites-enabled/000-default.conf \
&& sed -i "s/memory_limit = .*/memory_limit = ${PHP_MEMORY_LIMIT}/" /etc/php/7.4/apache2/php.ini
#....

WORKDIR /var/www/html/
RUN git clone https://github.com/ILIAS-eLearning/ILIAS.git . \
    && git config --global --add safe.directory /var/www/html
    # && git checkout release_7 \
# RUN composer install --no-dev \
#     && mkdir /var/www/files/ \
#     && chown www-data:www-data `/var/www/html \
#     && chown www-data:www-data `/var/www/files

RUN cat /etc/apache2/sites-enabled/000-default.conf

ENTRYPOINT ["tail", "-f", "/dev/null"]


    # lsb-release \
    # wget \
    # jq \
    # gettext \
