#!/bin/sh

echo 'Running startup script:'

# Wait for db to be ready: (https://docs.docker.com/compose/startup-order/)
wait-for-it -t 0 ${DB_ADDR}:${DB_PORT}

# Additional configuration:
# echo 'Additional configuration:'
cd /var/www/html
php setup/setup.php install /var/www/config.json --yes

# Add plugin directory:
mkdir -p Customizing/global/plugins/Services/Repository/RepositoryObject
cd Customizing/global/plugins/Services/Repository/RepositoryObject

# Add optional plugins:
git clone -b release_7 --single-branch https://github.com/srsolutionsag/H5P.git H5P
git clone -b release_7 --single-branch https://github.com/Minervis-GmbH/BigBlueButton-Ilias-Plugin.git BigBlueButton/
git clone -b release7 --single-branch https://github.com/internetlehrer/MultiVc MultiVc

# Finished:
echo 'Ready for setup: http://localhost/'
echo 'root:homer'
