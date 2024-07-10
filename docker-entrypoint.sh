#!/bin/sh

echo 'Running startup script:'

# Wait for db to be ready: (https://docs.docker.com/compose/startup-order/)
wait-for-it -t 0 ${DB_ADDR}:${DB_PORT}

# Additional configuration:
# echo 'Additional configuration:'
cd /var/www/html
php setup/setup.php install /var/www/config.json --yes

# Finished:
echo 'Ready for setup: http://localhost/'
echo 'root:homer'
