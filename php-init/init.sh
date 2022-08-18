#!/bin/bash

WP_PREFIX=/var/www
DOMAIN_SUFFIX="iron.org.ua"

wp_install(){
	#apt update && apt -y install less
	test ! -e /usr/bin/mysql && apt update && apt -y install mariadb-client netcat
	if [ ! -e /usr/bin/wp ]; then
		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/bin/wp
		chmod +x /usr/bin/wp
	fi
	WP="/usr/bin/wp --allow-root"

	# Wait until mysql becore fully initialized
	echo "Waiting while MySQL port become open..."
	while ! nc -z mysql 3306; do
		sleep 1
	done

	$WP core download --path=/var/www/wp$1
	$WP config create --path=/var/www/wp$1 --dbhost=mysql --dbname=wp$1 --dbuser=wp$1 --dbpass=wp${i}pass --extra-php <<PHP
define('WP_MEMORY_LIMIT', '256M');
PHP
	$WP core install --path=/var/www/wp$1 --url=test$1.$DOMAIN_SUFFIX --title=test$1.$DOMAIN_SUFFIX --admin_user=test --admin_password=securetestpass$1 --admin_email=iron.udjin@gmail.com
}



for i in 1 2
do
	echo "Checking if wordpresses installed"
	if [ ! -e $WP_PREFIX/wp$i/wp-config.php ]; then
		echo "test$i.$DOMAIN_SUFFIX not installed. Installing..."
		wp_install $i
	else
		echo "Wordpress is installed on test$i.$DOMAIN_SUFFIX, exitting..."
	fi
done
php-fpm -F -y /opt/bitnami/php/etc/php-fpm.conf
