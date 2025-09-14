#!/usr/bin/env bash
# 

mydbpass=""
needsmarthost=0
localdb=0

# find out whether to install local db server
echo "Do you want to install a local db server?"
echo "if there is already a maia database server, the answer is no"
echo -n  "install a local maia db server? (y/N)"
read junk

[ "${junk}X" == "X" ] && junk="n"
if [ $junk == 'y' ] || [ $junk == 'Y' ]; then
  localdb=1
  dbserver=localhost
fi

dbname=maia
if [ $localdb -eq 0 ]; then
  echo -n "Enter the resolvable name or IP of the maia DB server:  "
  read dbserver
  echo
  echo -n "Enter the maia database name (default: maia): "
  read dbname
  [ "${dbname}X" == "X" ] && dbname="maia"
fi

echo
echo "### note that the maia db user is maia ###"
dbuser=maia

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
echo -n "enter relayhost if required, otherwise just press enter:"
read smarthost
[ "${smarthost}X" == "X" ] || needsmarthost=1
echo

#
# review settings - 
#

echo "OK, reviewing settings..."
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

if [ $needsmarthost == 1 ]; then
  echo "SMTP smarthost: $smarthost"
else
  echo "no SMTP smarthost set"
fi

echo
echo "settings correct? hit <ENTER> to continue, CTRL-C to abort"

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
echo "If there are any incorrect parameters, open a new terminal"
echo "and edit installer.tmpl to correct any errors"
echo
echo "Then return to this terminal and press <ENTER>"
echo
read

