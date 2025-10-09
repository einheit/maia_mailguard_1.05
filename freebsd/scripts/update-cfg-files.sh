#!/bin/sh
#
# collect info and update maia related config files 
#

# get info
mydbpass=""
needsmarthost=0
localdb=0

echo -n "Enter the IP or resolvable name of the maia DB server:  "
read dbserver

echo
echo -n "Enter the maia database name (default: maia): "
read dbname
[ "${dbname}X" == "X" ] && dbname="maia"
    
echo
echo -n "Enter the maia db username (default: maia): "
read dbuser
[ "${dbuser}X" == "X" ] && dbuser="maia"
  
# get the maia password
echo
echo -n "Enter the maia db password: "
read mydbpass
echo

#
# get short hostname, domain name, and relayhost
#

shost=`hostname -s`
fqdn=`hostname -f`
domain=`echo $fqdn | sed s/${shost}\.//g`
  
echo "does this server require an smtp relayhost/smarthost?"
echo -n "enter relayhost if required, otherwise just press enter: "
read smarthost
[ "${smarthost}X" == "X" ] || needsmarthost=1
echo

#
# review settings - 
#

echo "Current settings..."
echo

echo "the short hostname is $shost"
echo
echo "the fully qualified hostname is $fqdn"
echo
echo "the domain seems to be $domain"
echo
echo "database user: $dbuser"
echo
echo "database name: $dbname"
echo
echo "password for maia db: $mydbpass"
echo

if [ $needsmarthost == 1 ]; then
  echo "SMTP smarthost: $smarthost"
else
  echo "no SMTP smarthost set"
fi

echo
echo "settings correct? hit <ENTER> to continue, CTRL-C to abort"
read junk

#
# final confirmation -
#

echo "HOST=$shost" > installer.tmpl
echo "FQDN=$fqdn" >> installer.tmpl
echo "DOMAIN=$domain" >> installer.tmpl
echo "DBSERVER=$dbserver" >> installer.tmpl
echo "DBUSER=$dbuser" >> installer.tmpl
echo "DBNAME=$dbname" >> installer.tmpl
echo "MAIAPASS=$mydbpass" >> installer.tmpl
echo "WEBSRV=$fqdn" >> installer.tmpl

[ $localdb == 1 ] && echo "DB_INSTALL" >> installer.tmpl
[ $needsmarthost == 1 ] && echo "RELAY=$smarthost" >> installer.tmpl

echo "installation parameters:"
cat installer.tmpl
echo 
echo "Verify the parameters above are correct"
echo
echo "If there are any incorrect parameters, echo "edit installer.tmpl 
echo "and hit enter to continue"
echo
echo read junk
read

# process changes

/bin/rm -f maia.conf maiad.conf config.php

cp freebsd/cfg_template/maia.conf.tmpl maia.conf
cp freebsd/cfg_template/maiad.conf.tmpl maiad.conf
cp freebsd/cfg_template/config.php.tmpl config.php

# modify the working copies of the config files in place
HOST=`grep HOST installer.tmpl | awk -F\= '{ print $2 }'`
FQDN=`grep FQDN installer.tmpl | awk -F\= '{ print $2 }'`
DOMAIN=`grep DOMA installer.tmpl | awk -F\= '{ print $2 }'`
dbhost=`grep DBSERVER installer.tmpl | awk -F\= '{ print $2 }'`
dbuser=`grep DBUSER installer.tmpl | awk -F\= '{ print $2 }'`
dbname=`grep DBNAME installer.tmpl | awk -F\= '{ print $2 }'`
passwd=`grep MAIAPASS installer.tmpl | awk -F\= '{ print $2 }'`
websrv=`grep WEBSRV installer.tmpl | awk -F\= '{ print $2 }'`

export HOST FQDN DOMAIN dbhost passwd websrv

 echo "modifying maia base_url"
 inline-edit.sh example.com ${websrv}/maia maia.conf

 echo "editing HOST"
 inline-edit.sh __HOST__ $HOST maiad.conf
 echo "editing DOMAIN"
 inline-edit.sh __DOMAIN__  $DOMAIN maiad.conf

for i in config.php maia.conf maiad.conf
do
 echo "editing DBHOST"
 inline-edit.sh __DBHOST__  $dbhost $i
 echo "editing DBUSER"
 inline-edit.sh __DBUSER__  $dbuser $i
 echo "editing DBNAME"
 inline-edit.sh __DBNAME__  $dbname $i
 echo "editing PASSWORD/${passwd}"
 inline-edit.sh '__PASSWORD__'  $passwd $i
done

mkdir -p /usr/local/etc/maia-mailguard/
cp -a maia.conf /usr/local/etc/maia-mailguard/maia.conf
cp -a maiad.conf /usr/local/etc/maia-mailguard/maiad.conf
cp -a freebsd/etc/maiad.rc /usr/local/etc/rc.d/maiad

# point to the maia mailguard directory
ln -s /usr/local/www/maia-mailguard /usr/local/www/apache24/data/

#
# set up apache & php
#
cp -a freebsd/etc/php.conf /usr/local/etc/apache24/Includes/

perl -pi -e 'print "LoadModule proxy_module libexec/apache24/mod_proxy.so\n" if  $. == 66' /usr/local/etc/apache24/httpd.conf

perl -pi -e 'print "LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so\n" if  $. == 67' /usr/local/etc/apache24/httpd.conf

perl -pi -e s/'DirectoryIndex index.html'/'DirectoryIndex index.php index.html'/g /usr/local/etc/apache24/httpd.conf

cp -a /usr/local/etc/php.ini-production /usr/local/etc/php.ini

echo
echo "reloading http server"
apachectl restart

