#!/bin/sh
#
# collect info and update maia related config files 
#

get-info.sh

process-changes.sh

#
# configure apache for maia
#

# point to the maia mailguard directory
ln -s /usr/local/www/maia-mailguard /usr/local/www/apache24/data/

# set up php-fpm handler
cp freebsd/etc/php.conf /usr/local/etc/apache24/Includes

perl -pi -e 'print "LoadModule proxy_module libexec/apache24/mod_proxy.so\n" if  $. == 66' /usr/local/etc/ap
ache24/httpd.conf

perl -pi -e 'print "LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so\n" if  $. == 67' /usr/lo
cal/etc/apache24/httpd.conf

# enable index.php
perl -pi -e s/'DirectoryIndex index.html'/'DirectoryIndex index.php index.html'/g /usr/local/etc/apache24/ht
tpd.conf

cp -a /usr/local/etc/php.ini-production /usr/local/etc/php.ini

echo
echo "reloading http server"
apachectl restart

