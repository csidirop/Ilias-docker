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
git clone -b release_8 --single-branch https://github.com/Minervis-GmbH/BigBlueButton-Ilias-Plugin.git BigBlueButton/
git clone -b release8 --single-branch https://github.com/internetlehrer/MultiVc MultiVc

cd ~/html
php setup/setup.php build-artifacts -vvv
php setup/setup.php update --yes

# Finished:
echo -e '\n\nILIAS Status:'
php /var/www/html/setup/setup.php status
echo -e '\n\nReady for setup:  http://localhost/'
echo -e '\nCredentials:  root:homer'
