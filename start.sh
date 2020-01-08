#!/bin/bash
# !!! POZOR !!! při změně tohoto souboru nastavit práva (chmod 0777 start.sh) jinak to Docker nespustí.

# change permissions for mounted directories
chown -R www-data:www-data /var/www/html/logs

# Run cron
cron -f & rm -f /var/run/apache2/apache2.pid

# Run the apache process in the foreground, tying up this so docker does not return. Run react
#sudo -u www-data php /var/www/html/scripts/bootstrap_react.php 8080 prod >> /var/www/html/logs/stdout.log 2>&1 &
apachectl -D FOREGROUND
