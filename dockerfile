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
    libxslt-dev\
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
    pdo_mysql \
    soap \
    xsl \
    xml \
    xmlrpc \
    zip 

WORKDIR /var/www/html/

# Install ILIAS: (https://docu.ilias.de/ilias.php?baseClass=illmpresentationgui&cmd=layout&ref_id=367&obj_id=124784#get-code)
RUN git clone -b v7.30 --depth 1 --single-branch https://github.com/ILIAS-eLearning/ILIAS.git . \
  && git config --global --add safe.directory /var/www/html
RUN composer install --no-dev \
  && npm clean-install --omit=dev --ignore-scripts \
  # &&  npm audit fix \
  && mkdir /var/www/files/ \
  && mkdir /var/log/ilias \
  && chown -R www-data:www-data /var/www/html \
  && chown -R www-data:www-data /var/www/files \
  && chown -R www-data:www-data /var/log/ilias

USER www-data

COPY data/php.ini /usr/local/etc/php/
COPY data/config.json /var/www/
# RUN php setup/setup.php install /var/www/config.json --yes
COPY docker-entrypoint.sh /

# Start apache2 (https://github.com/docker-library/php/blob/master/8.3/bullseye/apache/apache2-foreground)
CMD /docker-entrypoint.sh & apache2-foreground
