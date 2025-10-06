#!/bin/sh
#
# FreeBSD 14 installer
#

DBG=0

echo 
echo "This install script is for FreeBSD 14 and a mysql DB"
echo "if using postgresql or other DB, you'll need to manually"
echo "edit the maia/maiad config files & the php config file"
echo 

# set path for the install - 
PATH=`pwd`/freebsd/scripts:$PATH
export PATH

# get the info, write parames to a file
get-info.sh

echo "If there are no errors, this script will run to completion."
echo
echo "Note that the install could take a good while, dependng on"
echo "available computing power and network bandwidth."
echo
echo "Feel free to take a break!"
echo
echo "proceed? "
read junk

# install stage 1 packages
pkg update
pkg install -y git
pkg install -y postfix

# find out what we need to change
if [ $DBG != "0" ]; then
  echo "processing changes..."
  read -p "continue? " junk
fi

process-changes.sh

if [ $DBG != "0" ]l; then
  echo "checkpoint 1"
  read junk
fi

pkg install -y p5-Template-Toolkit
pkg install -y p5-Archive-Zip
pkg install -y p5-BerkeleyDB
pkg install -y p5-Convert-TNEF
pkg install -y p5-Convert-UUlib
pkg install -y p5-Crypt-OpenSSL-RSA
pkg install -y p5-DBI
pkg install -y p5-DBD-mysql
pkg install -y p5-DBD-pg
pkg install -y p5-Data-Dumper-Concise
pkg install -y p5-Data-UUID
pkg install -y p5-DateTime
pkg install -y p5-Digest-SHA1
pkg install -y p5-GeoIP2
pkg install -y p5-IO-Multiplex
pkg install -y p5-IO-Socket-INET6
pkg install -y p5-IO-Socket-SSL
pkg install -y p5-IP-Country
pkg install -y p5-LWP-Protocol-https
pkg install -y p5-Locale-gettext
pkg install -y p5-MIME-Base64
pkg install -y p5-MIME-Tools
pkg install -y p5-Mail-DKIM
pkg install -y p5-Mail-SPF
pkg install -y p5-NetAddr-IP
pkg install -y p5-Net-SSLeay
pkg install -y p5-Net-Server
pkg install -y p5-NetAddr-IP
pkg install -y p5-Net-CIDR-Lite
pkg install -y p5-Net-DNS
pkg install -y p5-forks
pkg install -y p5-Unix-Syslog
pkg install -y p5-Text-CSV
pkg install -y
pkg install -y
pkg install -y
#
pkg install -y spamassassin
pkg install -y razor-agents

# create vscan account 
pw user add vscan -c "Scanning Virus Account" -d /var/maiad -m -s /bin/sh

if [ $DBG != 0 ]; then
  echo "checkpoint 2"
  read junk
fi

mkdir -p /var/log/maia
chown -R vscan:vscan /var/log/maia

mkdir -p  /var/maiad/tmp
mkdir -p  /var/maiad/db
mkdir -p  /usr/local/share/maia-mailguard/scripts
mkdir -p  /usr/local/etc/maia-mailguard/templates

cp -r freebsd/maia_scripts/* /usr/local/share/maia-mailguard/scripts/
cp -r freebsd/maia_templates/* /usr/local/etc/maia-mailguard/templates
cp freebsd/sbin/maiad /usr/local/sbin

chown -R root:wheel /usr/local/share/maia-mailguard/
chown -R root:wheel /usr/local/etc/maia-mailguard/
chown root:wheel /usr/local/sbin/maiad

chmod 2775 /var/maiad/tmp
chown -R vscan:vscan /var/maiad

mkdir -p /usr/local/etc/maia-mailguard/
cp maia.conf /usr/local/etc/maia-mailguard/maia.conf 
cp maiad.conf /usr/local/etc/maia-mailguard/maiad.conf
cp freebsd/etc/maiad.rc /usr/local/etc/rc.d/maiad

# maiad helpers
pkg install -y arc arj
pkg install -y lha lzop 
pkg install -y nomarch
pkg install -y rar unrar unarj
pkg install -y zoo unzoo
pkg install -y cabextract ripole rpm2cpio

# clamav anti virus 
pkg install -y clamav
echo "updating clam AV database..."
freshclam
sigtool -V

# install mysql server if called for -
DBINST=`grep DB_INSTALL installer.tmpl | wc -l`
DB_INST=`expr $DBINST`

### work needed ###
# install mysql server if called for -
if [ $DB_INST -eq 1 ]; then
  echo "creating maia database..."
  pkg install -y mysql80-server
  echo 'mysql_enable="YES"' >> /etc/rc.conf
  service mysql-server start
  mysqladmin create maia
  maia-grants.sh
  status=$?
  if [ $status -ne 0 ]; then
    echo "*** problem granting maia privileges - db needs attention ***"
    read
  fi
  mysql maia < files/maia-mysql.sql
  status=$?
  if [ $status -ne 0 ]; then
    echo "*** problem importing maia schema - db needs attention ***"
    read
  fi
fi

echo "stage 1 install complete"

#
# the database should be working at this point.
#

cp files/*.cf /usr/local/etc/mail/spamassassin/
/usr/local/share/maia-mailguard/scripts/load-sa-rules.pl

#
# install the web stuff
#
pkg install -y apache24

mkdir -p /usr/local/www/maia-mailguard
cp -r php/* /usr/local/www/maia-mailguard

pkg install -y php83
pkg install -y php83-bcmath
pkg install -y php83-ctype
pkg install -y php83-gd
pkg install -y php83-iconv
pkg install -y php83-imap
pkg install -y php83-mbstring
pkg install -y php83-mysqli
pkg install -y php83-pdo
pkg install -y php83-pdo_mysql
pkg install -y php83-pdo_pgsql
pkg install -y php83-pdo_sqlite
pkg install -y php83-pear
pkg install -y php83-pear-Auth_SASL
pkg install -y php83-pear-Mail
pkg install -y php83-pear-Mail_Mime
pkg install -y php83-pear-Mail_mimeDecode
pkg install -y php83-pear-Math_BigInteger
pkg install -y php83-pear-Net_IMAP
pkg install -y php83-pear-Net_POP3
pkg install -y php83-pear-Net_SMTP
pkg install -y php83-pear-Net_Socket
pkg install -y php83-pear-Numbers_Roman
pkg install -y php83-pear-Numbers_Words
pkg install -y php83-pear-Pager
pkg install -y php83-pecl-scrypt
pkg install -y php83-pgsql
pkg install -y php83-posix
pkg install -y php83-session
pkg install -y php83-simplexml
pkg install -y php83-sockets
pkg install -y php83-sqlite3
pkg install -y php83-tokenizer
pkg install -y php83-xml
pkg install -y php83-zlib

pkg install -y smarty3-php83
ln -s /usr/local/share/smarty3-php83/ /usr/local/share/php/Smarty

# pear fixes -
pear channel-update pear.php.net
pear install Log-1.13.3

freebsd/scripts/fixup-Mail_mimeDecode.sh

# htmlpurifier -
tar -C /var -xf files/htmlpurifier-4.18.0.tar.gz
ln -s /var/htmlpurifier-4.18.0 /var/htmlpurifier
chown -R root:wheel /var/htmlpurifier*

echo
echo "preparing php directory"

# temp bug workaround
for i in /usr/local/www/maia-mailguard/themes/*
do
 mkdir -p ${i}/compiled
done

chmod 775 /usr/local/www/maia-mailguard/themes/*/compiled
chown -R vscan:www /usr/local/www/maia-mailguard/themes/*/compiled
cp config.php /usr/local/www/maia-mailguard
mkdir -p /var/www/cache
chmod 775 /var/www/cache
chown www:vscan /var/www/cache

#
# configure apache for maia
#

# point to the maia mailguard directory
ln -s /usr/local/www/maia-mailguard /usr/local/www/apache24/data/

# set up php-fpm handler
cp freebsd/etc/php.conf /usr/local/etc/apache24/Includes

perl -pi -e 'print "LoadModule proxy_module libexec/apache24/mod_proxy.so\n" if  $. == 66' /usr/local/etc/apache24/httpd.conf

perl -pi -e 'print "LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so\n" if  $. == 67' /usr/local/etc/apache24/httpd.conf

# enable index.php
perl -pi -e s/'DirectoryIndex index.html'/'DirectoryIndex index.php index.html'/g /usr/local/etc/apache24/httpd.conf

cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini

echo
echo "reloading http server"
apachectl restart

echo "stage 2 complete"

# call postfix setup script
postfix-setup.sh

echo "Enabling automatic startup of maia services..."
echo "Confirm the settings are correct in /erc/rc.conf"
cp -a /etc/rc.conf /etc/rc.conf-save-$$
cat freebsd/etc/rc.conf-append >> /etc/rc.conf

host=`grep HOST installer.tmpl | awk -F\= '{ print $2 }'`

echo
echo    "any other site specific MTA configuration can be applied now - "
echo
echo
echo    "at this point, a good sanity check would be to run"
echo    " /usr/local/share/maia-mailguard/scripts/configtest.pl"
echo
echo    "You may need to edit firewall rules to allow http access"
echo
echo    "If configtest.pl passes, make sure the http service has been"
echo	"started, and then check the maia mailguard configuration at"
echo    " http://$host/maia-mailguard/admin/configtest.php"
echo
echo    "if everything passes, and you have just created a new maia"
echo	"mailguard database, create the initial maia user"
echo    "by visiting http://$host/maia-mailguard/internal-init.php"
echo
echo    "maia will send your login credentials to the email addess you"
echo    "supplied in the internal-init form. Use those credentials to"
echo    "log into the url below (note the "super=register" arg)"
echo    " http://${host}/maia-mailguard/login.php?super=register"
echo
echo    "You will also need to set up cron jobs to maintain your system"
echo    "See docs/cronjob.txt for more info"
echo

