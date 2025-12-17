#!/usr/bin/env bash
#
# arch installer
#

echo 
echo "This install script is for arch Linux and mysql DB"
echo "if using postgresql or other DB, you need to manually"
echo "edit configs in /etc/maia/ and ~www/maia/config.php"
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

# upodate
pacman -Syu --noconfirm

# set locale for apt 
pacman -S --noconfirm glibc-locales
cp ${OS}/extras/locale.gen /etc
locale-gen

# basic requirements 
pacman -S --noconfirm git perl postfix make gcc patch curl wget file vi less

# find out what we need to change
process-changes.sh

#
echo "now installing packages.."

pacman -S --noconfirm perl-archive-zip \
perl-berkeleydb \
perl-convert-tnef \
perl-convert-uulib \
perl-crypt-openssl-rsa \
perl-data-uuid \
perl-dbi \
perl-dbd-mariadb \
perl-dbd-mysql \
perl-dbd-pg \
perl-digest-sha1 \
perl-mail-dkim \
perl-net-cidr-lite \
perl-net-server \
perl-text-csv \
perl-unix-syslog \
perl-net-dns \
perl-template-toolkit \
spamassassin \
cpanminus

# are these  equivalent to Debian's libnet-ldap-perl?
# perl-ldap
# perl-net-ldap-server

#
# non-interactive cpan installs
#

cpanm LWP
cpanm forks
cpanm IP::Country::Fast
cpanm Net::LDAP::LDIF
cpanm Crypt::Blowfish
cpanm Crypt/CBC.pm 
cpanm Razor2::Client::Agent
cpanm Encode::Detect


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
pacman -S  --noconfirm arj unarj cabextract lzop pax lhasa rpmextract unrar

# a handy tool for a quick check
cp -a ${OS}/extras/check-maia-ports.sh /usr/local/bin/

# configtest.pl should work now unless installing a local DB server

pacman -S --noconfirm clamav
freshclam

#
# web interface
#

pacman -S --noconfirm apache
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
  pacman -S --noconfirm mariadb-lts mariadb-lts-libs mariadb-lts-clients && \
  sleep 1 && \
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql && \
  sleep 1 && \
  systemctl start mysql && \
  sleep 1 && \
  mariadb-admin create maia && \
  sleep 1 && \
  maia-grants.sh
  status=$?
  if [ $status -ne 0 ]; then
    echo "*** problem granting maia privileges - you will need to set up the DB ***"
    read
  fi
  mysql maia < files/maia-mysql-linux.sql
  status=$?
  if [ $status -ne 0 ]; then
    echo "*** problem importing maia schema - you will need to set up the DB ***"
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
systemctl disable --now spamassassin

echo
echo "installing php modules"
echo

# add extras 
pacman -S --noconfirm base-devel
pacman -S --noconfirm php php-fpm php-gd
pacman -S --noconfirm  php-pgsql
pacman -S --noconfirm  php-mysql

arch-pear-install.sh

echo "stop here and open a session as a non-root user"
echo "and run the following commands, if yay is not already installed:"
echo " git clone https://aur.archlinux.org/yay.git"
echo " cd yay"
echo " makepkg -si"
echo
echo " then return to the original session and hit <ENTER> to continue"
read junk

yay smarty3 
ln -s /usr/share/php/smarty3 /usr/share/php/Smarty
pacman -S libmcrypt
pecl install mcrypt
pacman -S libiconv

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
pear install Net_POP3
pear install Net_IMAP
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
chown http:http /var/www/html/maia/themes/*/compiled
cp config.php /var/www/html/maia/
mkdir /var/www/cache
chown http:http /var/www/cache
chmod 775 /var/www/cache

ln -s /var/www/html/maia /srv/http
patch -p1 /etc/httpd/conf/httpd.conf < files/httpd.conf-arch.patch
cp -a files/php.conf-fpm /etc/httpd/conf/conf.d/php.conf
patch -p1 /etc/php/php.ini < files/php.ini.patch

echo
echo "reloading http server"
killall httpd
systemctl enable --now httpd
systemctl enable --now php-fpm

# fix up Mail_mimeDecode
echo "fixing up Mail_mimedecode"
fixup-Mail_mimeDecode.sh /usr/lib/php/pear/Mail

# set smarty path in config.php
arch-fix-smarty-path.sh

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
echo    "log into the url below (note the super=register arg)"
echo    " http://${host}/maia/login.php?super=register"
echo
echo	"There have been reports of the admin having to log in with"
echo 	"super=register more than once before the admin option appears"
echo	"in their welcome page"
echo
echo	"You can achieve the same thing by setting the user_level to S in" 
echo	"the maia_users table for the admin user"
echo
echo    "You will also need to set up cron jobs to maintain your system"
echo    "See docs/cronjob.txt for more info"
echo

