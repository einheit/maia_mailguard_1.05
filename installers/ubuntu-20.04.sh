#!/usr/bin/env bash
#
# ubuntu 20.04 installer
#

echo 
echo "this is for ubuntu 20.04 LTS (Focal Fossa) using mysql"
echo "if using postgresql or other DB, you'll need to manually"
echo "edit configs in /etc/maia/ and ~www/maia/config.php"
echo 
echo "Be sure the system is up to date before running this script!"
echo 
echo "This script installs and configures the postfix MTA"
echo "If you wish to use something other than postfix,"
echo "you will need to install and set up that MTA after"
echo "the completion of this script, or install manually"
echo 
echo -n "<ENTER> to continue or CTRL-C to stop..."
read
echo 

# set path for the install - 
PATH=`pwd`/scripts:$PATH
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
read

# install stage 1 packages

# suppress dialog boxes for package installs
export DEBIAN_FRONTEND=noninteractive

# sanity check -
apt update

# set locale for apt 
apt install -y locales
cp contrib/locale.gen /etc
/usr/sbin/locale-gen

# make sure perl is installed 
apt-get -y install perl

# write changes to config files
process-changes.sh

echo "now installing packages.."
apt-get install -y make gcc patch
apt-get install -y curl wget telnet
#
apt-get install -y file
apt-get install -y libarchive-zip-perl
apt-get install -y libberkeleydb-perl
apt-get install -y libconvert-tnef-perl
apt-get install -y libconvert-uulib-perl
apt-get install -y libcrypt-openssl-rsa-perl
apt-get install -y libdata-uuid-perl
apt-get install -y libdbd-mysql-perl libdbd-pg-perl
apt-get install -y libdbi-perl
apt-get install -y libdigest-sha-perl
apt-get install -y libencode-detect-perl
apt-get install -y libforks-perl
apt-get install -y libmail-dkim-perl
apt-get install -y libnet-cidr-lite-perl
apt-get install -y libnet-ldap-perl
apt-get install -y libnet-server-perl
apt-get install -y libtemplate-perl
apt-get install -y libtext-csv-perl
apt-get install -y libunix-syslog-perl
apt-get install -y libgeoip2-perl
apt-get install -y pyzor
apt-get install -y razor
apt-get install -y spamassassin

#
# cpanm for modules not in the repos
#
apt-get install -y cpanminus

cpanm Digest::SHA1
cpanm IP::Country::Fast
cpanm LWP
cpanm Net::LDAP::LDIF

#
# add maia user and chown all its files/dirs
#
mkdir -p /var/lib/maia
useradd -d /var/lib/maia maia
chmod 755 /var/lib/maia

# create and chown dirs
mkdir -p /var/log/maia
chown -R maia.maia /var/log/maia

mkdir -p /etc/maia
cp maia.conf maiad.conf /etc/maia/

mkdir -p  /var/lib/maia/tmp
mkdir -p  /var/lib/maia/db
mkdir -p  /var/lib/maia/scripts
mkdir -p  /var/lib/maia/templates

cp files/maiad /var/lib/maia/
cp -r maia_scripts/* /var/lib/maia/scripts/
cp -r maia_templates/* /var/lib/maia/templates/

chown -R maia.maia /var/lib/maia
chown root.root /var/lib/maia/maiad
chown -R maia.clamav /var/lib/maia/tmp
chmod 2775 /var/lib/maia/tmp


# maia helpers
apt install -y arc
apt install -y arj
apt install -y cabextract
apt install -y lzop
apt install -y pax
apt install -y unrar || apt install -y unrar-free || echo "unrar not found"

# a handy tool for a quick check
cp -a contrib/check-maia-ports.sh /usr/local/bin/

# configtest.pl should work now, unless installing a local db server

apt-get install -y postfix

apt-get install -y clamav 
apt-get install -y clamav-daemon
apt-get install -y clamav-freshclam
cp /etc/clamav/clamd.conf /etc/clamav/clamd.conf_ubuntu_orig-$$
cp contrib/clamd-ubuntu-maia-tcp.conf /etc/clamav/clamd.conf

#
# web interface
#

apt-get install -y apache2 apache2-utils 
mkdir -p /var/www/html/maia
cp -r php/* /var/www/html/maia
echo "done with file copy, starting package install"

# enable services
cp contrib/maiad.service /etc/systemd/system
systemctl enable maiad

DBINST=`grep DB_INSTALL installer.tmpl | wc -l`
DB_INST=`expr $DBINST`

# install mysql server if called for -
if [ $DB_INST -eq 1 ]; then
  echo "creating maia database..."
  # suppress dialog boxes during mysql install -
  apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" mariadb-server
  systemctl start mariadb
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

# handle apparmor profiles for clamd and freshclam
ln -s /etc/apparmor.d/usr.sbin.clamd /etc/apparmor.d/disable/
apparmor_parser -R /etc/apparmor.d/disable/usr.sbin.clamd

ln -s /etc/apparmor.d/usr.bin.freshclam /etc/apparmor.d/disable/
apparmor_parser -R /etc/apparmor.d/disable/usr.bin.freshclam


# populate the db before starting clamd
freshclam

# make sure the db is there before trying to start clamd
go=`sigtool -V|awk -F\/ '{ print $2 }'|wc -w`
while [ $go == "0" ]
do
	echo "waiting for clam signature db update"
	sleep 10
	go=`sigtool -V|awk -F\/ '{ print $2 }'|wc -w`
done
echo "database populated"

# start freshclam and clamd
/etc/init.d/clamav-freshclam start
/etc/init.d/clamav-daemon start

# start maiad 
/etc/init.d/maiad start

#
# load the spamassassin rulesets -
#
cp files/*.cf /etc/mail/spamassassin/
# /var/lib/maia/scripts/load-sa-rules.pl

echo
echo "installing php modules"
echo
apt-get -y install libapache2-mod-php
apt-get -y install php-mysql
apt-get -y install php-mbstring
apt-get -y install php-bcmath
apt-get -y install php-gd
apt-get -y install php-xml
apt-get -y install php-pear

apt-get install -y smarty3
ln -s /usr/share/php/smarty3 /usr/share/php/Smarty

echo
echo "installing pear modules"
echo

pear channel-update pear.php.net

pear install MDB2-2.5.0b5
pear install MDB2_Driver_mysqli-1.5.0b4
pear install Mail_mimeDecode
pear install Pager
pear install Net_Socket
pear install Net_SMTP
pear install Auth_SASL
pear install Log
pear install Image_Color
pear install Image_Canvas-0.3.5
pear install Image_Graph-0.8.0
pear install Numbers_Roman
pear install Numbers_Words-0.18.2
pear list

# install html purifier separately -
tar -C /var -xvf files/htmlpurifier-4.12.0.tar.gz
ln -s /var/htmlpurifier-4.12.0 /var/htmlpurifier

echo
echo "preparing php directory"

# temp bug workaround
for i in /var/www/html/maia/themes/*
do
 mkdir -p ${i}/compiled
done

chmod 775 /var/www/html/maia/themes/*/compiled
chown maia.www-data /var/www/html/maia/themes/*/compiled
cp config.php /var/www/html/maia/
mkdir /var/www/cache
chown www-data.maia /var/www/cache
chmod 775 /var/www/cache

echo
echo "reloading http server"

apachectl restart

echo "stage 2 complete"

# call postfix setup script
postfix-setup.sh
/etc/init.d/postfix restart

host=`grep HOST installer.tmpl | awk -F\= '{ print $2 }'`

echo
echo	"any other site specific MTA configuration can be applied now - "
echo
echo
echo    "at this point, a good sanity check would be to run"
echo    " /var/lib/maia/scripts/configtest.pl"
echo
echo    "You may now need to edit firewall to allow http access"
echo
echo    "If configtest.pl passes, check the web configuration at"
echo    " http://$host/maia/admin/configtest.php"
echo
echo    "if everything passes, and you are creating a database for the"
echo    "first time, (no existing database) create the initial maia user"
echo    "by visiting http://$host/maia/internal-init.php"
echo
echo    "maia will send your login credentials to the email addess you"
echo    "supplied in the internal-init form. Use those credentials to"
echo    "log into the url below (note the "super=register" arg)"
echo    " http://${host}/maia/login.php?super=register"
echo
echo    "You will also need to set up cron jobs to maintain your system"
echo    "See docs/cronjob.txt for more info"
echo

