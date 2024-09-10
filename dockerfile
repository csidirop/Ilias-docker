# Baseimage PHP 8.0 with Apache2 on Debian 11 bullseye:
FROM php:8.0-apache
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
    mimetex \
    ffmpeg \
    npm \
    # Java Server:
    default-jdk \
    default-jre \
    maven \
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
    zip \
  && pecl install xmlrpc-1.0.0RC3 \
  docker-php-ext-enable xmlrpc

WORKDIR /var/www/html/

# Install ILIAS: (https://docu.ilias.de/ilias.php?baseClass=illmpresentationgui&cmd=layout&ref_id=367&obj_id=124784#get-code)
RUN git clone -b release_8 --depth 1 --single-branch https://github.com/ILIAS-eLearning/ILIAS.git . \
  && git config --global --add safe.directory /var/www/html
RUN mkdir /var/www/files/ \
  && mkdir /var/www/files/lucene \
  && mkdir /var/www/java-svr \
  && mkdir /var/log/ilias \
  && chown -R www-data:www-data /var/www/ \
  && chown -R www-data:www-data /var/log
USER www-data
RUN composer install --no-dev \
  && npm cache clean --force \
  && rm -rf node_modules package-lock.json \
  && npm install --package-lock-only \
  && npm clean-install --omit=dev --ignore-scripts \
  # Install Lucene RPC-Server https://github.com/ILIAS-eLearning/ILIAS/blob/release_8/Services/WebServices/RPC/lib/README.md
  && ln -s /var/www/html/Services/WebServices/RPC/lib/ilServer.jar /var/www/java-svr/

WORKDIR /var/www/html/
COPY data/ilServer.ini /var/www/java-svr
COPY data/php.ini /usr/local/etc/php/
COPY data/config.json /var/www/
# RUN php setup/setup.php install /var/www/config.json --yes
COPY docker-entrypoint.sh /

# Start apache2 (https://github.com/docker-library/php/blob/master/8.3/bullseye/apache/apache2-foreground)
CMD /docker-entrypoint.sh & apache2-foreground
