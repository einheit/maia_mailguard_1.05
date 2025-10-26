#!/usr/bin/env bash
#
# debian 13 installer
#

echo 
echo "This install script is for Debian 13 Trixie using mysql"
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

OS=`uname | tr [A-Z] [a-z]`

# set path for the install - 
PATH=`pwd`/${OS}/scripts:$PATH
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

# basic sanity check -
apt update

# set locale for apt 
apt install -y locales
cp ${OS}/extras/locale.gen /etc
/usr/sbin/locale-gen

# make sure git is installed for fixes
apt install -y git

# make sure perl is installed 
apt -y install perl

# make sure we have postfix
apt remove --purge exim4  exim4-base  exim4-config exim4-daemon-light
apt install -y postfix

# find out what we need to change
process-changes.sh

#
echo "now installing packages.."
apt install -y make gcc patch
apt install -y curl wget telnet
#
apt install -y file
apt install -y libarchive-zip-perl
apt install -y libberkeleydb-perl
apt install -y libconvert-tnef-perl
apt install -y libconvert-uulib-perl
apt install -y libcrypt-openssl-rsa-perl
apt install -y libdata-uuid-perl
apt install -y libdbd-mysql-perl libdbd-pg-perl
apt install -y libdbi-perl
apt install -y libdigest-sha-perl
apt install -y libencode-detect-perl
apt install -y libforks-perl
apt install -y libmail-dkim-perl
apt install -y libnet-cidr-lite-perl
apt install -y libnet-ldap-perl
apt install -y libnet-server-perl
apt install -y libtemplate-perl
apt install -y libtext-csv-perl
apt install -y libunix-syslog-perl
apt install -y perl-Net-DNS-Nameserver
apt install -y razor
apt install -y libmail-spf-perl
apt install -y spamassassin
#
#
# non-interactive cpan installs
#

apt install -y cpanminus

cpanm Digest::SHA1
cpanm IP::Country::Fast
cpanm LWP
cpanm Net::LDAP::LDIF
cpanm Crypt::Blowfish
#cpanm Razor2::Client::Agent


#
# add maia user and chown all its files/dirs
#
useradd -d /var/lib/maia maia
mkdir -p /var/lib/maia
chmod 755 /var/lib/maia
chown -R maia:maia /var/lib/maia

# create and chown dirs
mkdir -p /var/log/maia
chown -R maia:maia /var/log/maia

mkdir -p  /var/lib/maia/tmp
mkdir -p  /var/lib/maia/db
mkdir -p  /var/lib/maia/scripts
mkdir -p  /var/lib/maia/templates
cp ${OS}/maiad /var/lib/maia/
cp -r ${OS}/maia_scripts/* /var/lib/maia/scripts/
cp -r maia_templates/* /var/lib/maia/templates/

chown -R maia:maia /var/lib/maia
chown root:root /var/lib/maia/maiad
chown -R maia:clamav /var/lib/maia/tmp
chmod 2775 /var/lib/maia/tmp

mkdir -p /etc/maia
cp maia.conf maiad.conf /etc/maia/

# maiad helpers
apt install -y arc arj cabextract
apt install -y lzop pax lhasa rpm2cpio
apt install -y unrar || apt install -y unrar-free || echo "unrar not found"

# a handy tool for a quick check
cp -a ${OS}/extras/check-maia-ports.sh /usr/local/bin/

# configtest.pl should work now unless installing a local DB server

apt install -y clamav 
apt install -y clamav-daemon
apt install -y clamav-freshclam

#
# web interface
#

apt install -y apache2 apache2-utils 
mkdir -p /var/www/html/maia
cp -r php/* /var/www/html/maia

# enable services
cp ${OS}/extras/maiad.service /etc/systemd/system
systemctl enable maiad

DBINST=`grep DB_INSTALL installer.tmpl | wc -l`
DB_INST=`expr $DBINST`

# install mysql server if called for -
if [ $DB_INST -eq 1 ]; then
  echo "creating maia database..."
  # suppress dialog boxes during mysql install -
  apt install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" mariadb-server
  systemctl start mysql
  mysqladmin create maia
  maia-grants.sh
  status=$?
  if [ $status -ne 0 ]; then
    echo "*** problem granting maia privileges - db needs attention ***"
    read
  fi
  mysql maia < files/maia-mysql-linux.sql
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

# set up and start clamd
systemctl start clamav-daemon
systemctl start clamav-freshclam

# start maiad 
systemctl start maiad

# load the spamassassin rulesets -
#
cp files/*.cf /etc/mail/spamassassin/
# /var/lib/maia/scripts/load-sa-rules.pl
# maiad does not use spamd, it replaces spamd
systemctl disable --now spamd

echo
echo "installing php modules"
echo
apt install -y libapache2-mod-php
apt install -y php-mysql
apt install -y php-mbstring
apt install -y php-bcmath
apt install -y php-gd
apt install -y php-xml
apt install -y php-pear

apt install -y smarty3
ln -s /usr/share/php/smarty3/ /usr/share/php/Smarty

echo
echo "installing pear modules"
echo

pear channel-update pear.php.net

pear install Mail_mimeDecode
pear install Pager
pear install Net_Socket
pear install Net_SMTP
pear install Auth_SASL
pear install Log-1.13.3
#pear install Image_Color
#pear install Image_Canvas-0.3.5
#pear install Image_Graph-0.8.0
pear install Net_POP3
pear install Net_IMAP
pear install Numbers_Roman
pear install Numbers_Words-0.18.2
pear list

# install html purifier separately -
tar -C /var -xvf files/htmlpurifier-4.18.0.tar.gz
ln -s /var/htmlpurifier-4.18.0 /var/htmlpurifier
chown -R root:root /var/htmlpurifier*

echo
echo "preparing php directory"

# temp bug workaround
for i in /var/www/html/maia/themes/*
do
 mkdir -p ${i}/compiled
done

chmod 775 /var/www/html/maia/themes/*/compiled
chown maia:www-data /var/www/html/maia/themes/*/compiled
cp config.php /var/www/html/maia/
mkdir /var/www/cache
chown www-data:maia /var/www/cache
chmod 775 /var/www/cache

echo
echo "reloading http server"
apachectl restart

# fix up Mail_mimeDecode
echo "fixing up Mail_mimedecode"
fixup-Mail_mimeDecode.sh
supply-mcrypt.sh

echo "stage 2 complete"

# call postfix setup script
systemctl enable postfix
systemctl start postfix
postfix-setup.sh
systemctl restart postfix

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
echo    "first time, i.e. no existing database, create the initial maia user"
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

