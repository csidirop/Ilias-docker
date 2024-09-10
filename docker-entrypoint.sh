#!/bin/bash

echo 'Running startup script:'

# Wait for db to be ready: (https://docs.docker.com/compose/startup-order/)
wait-for-it -t 0 ${DB_ADDR}:${DB_PORT}

# Install ILIAS:
php setup/setup.php install /var/www/config.json --yes

# Add plugin directory:
mkdir -p Customizing/global/plugins/Services/Repository/RepositoryObject
cd Customizing/global/plugins/Services/Repository/RepositoryObject

# Add optional plugins:
git clone -b release_8 --single-branch https://github.com/srsolutionsag/H5P.git H5P
# git clone -b release_8 --single-branch https://github.com/Minervis-GmbH/BigBlueButton-Ilias-Plugin.git BigBlueButton/
# git clone -b release8 --single-branch https://github.com/internetlehrer/MultiVc MultiVc
# ... Add more plugins here ...

# Install plugins:
cd ~/html
composer install --no-dev

# Start Java server:
java -jar /var/www/java-svr/ilServer.jar /var/www/java-svr/ilServer.ini start > /var/log/ilias/java_srv.log 2>&1 &
java -jar /var/www/java-svr/ilServer.jar /var/www/java-svr/ilServer.ini createIndex testilias_0

# Finished:
echo -e '\n\nILIAS Status:'
php /var/www/html/setup/setup.php status
java -jar /var/www/java-svr/ilServer.jar /var/www/java-svr/ilServer.ini status
echo -e '\n\nReady for setup:  http://localhost/'
echo -e '\nCredentials:  root:homer'
