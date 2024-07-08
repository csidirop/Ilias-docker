# Baseimage PHP 7.4 with Apache2 on Debian 11 bullseye:
FROM php:7.4-apache
LABEL authors='Christos Sidiropoulos <Christos.Sidiropoulos@uni-mannheim.de>'

ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Upgrade system and install further php dependencies & composer:
RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install -y --no-install-recommends \
    locales \
    # database:
    mariadb-client \
    # for PHP modules:
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    libcurl4-openssl-dev \
    # ILIAS dependencies:
    ghostscript \
    graphicsmagick \
    graphicsmagick-imagemagick-compat \
    # openjdk-7-jdk \
    mimetex \
    ffmpeg \
    npm \
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
    # && apt-get autoremove -y \
    # && apt-get clean \
    # && rm -rf /var/lib/apt/lists/* \
    # apache mods:
    && a2enmod headers \
    && a2enmod expires \
    && a2enmod rewrite \
    # Gen locales:
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && sed -i '/de_DE.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen

# Install required PHP modules
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) \
    curl \
    gd \
    intl \
    mysqli \
    soap \
    xml \
    xmlrpc \
    zip 

# RUN echo "<VirtualHost *:80>\
#     ServerAdmin webmaster@example.com\
# \
#     DocumentRoot /var/www/html/\
#     <Directory /var/www/html/>\
#         Options FollowSymLinks -Indexes\
#         AllowOverride All\
#         Require all granted\
#     </Directory>\
# \
#     # Possible values include: debug, info, notice, warn, error, crit, alert, emerg.\
#     LogLevel warn\
# \
#     ErrorLog /var/log/apache2/error.log\
#     CustomLog /var/log/apache2/access.log combined\
# </VirtualHost>\
# " > /etc/apache2/sites-enabled/000-default.conf \
# && sed -i "s/memory_limit = .*/memory_limit = ${PHP_MEMORY_LIMIT}/" /etc/php/7.4/apache2/php.ini
# #....

WORKDIR /var/www/html/

# Install ILIAS: (https://docu.ilias.de/ilias.php?baseClass=illmpresentationgui&cmd=layout&ref_id=367&obj_id=0#get-code)
RUN git clone https://github.com/ILIAS-eLearning/ILIAS.git . \
  && git config --global --add safe.directory /var/www/html \
  && git checkout release_7
RUN composer install --no-dev \
    && npm clean-install --omit=dev --ignore-scripts \
    # &&  npm audit fix \
    && mkdir /var/www/files/ \
    && chown www-data:www-data `/var/www/html \
    && chown www-data:www-data `/var/www/files

# Start apache2 (https://github.com/docker-library/php/blob/master/8.3/bullseye/apache/apache2-foreground)
CMD apache2-foreground
