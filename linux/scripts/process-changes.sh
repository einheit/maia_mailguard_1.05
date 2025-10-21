#!/bin/bash -xv

OS=`uname | tr [A-Z] [a-z]`

/bin/rm -f maia.conf maiad.conf config.php

cp ${OS}/cfg_tpl/maia.conf.tmpl maia.conf 
cp ${OS}/cfg_tpl/maiad.conf.tmpl maiad.conf 
cp ${OS}/cfg_tpl/config.php.tmpl config.php

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

