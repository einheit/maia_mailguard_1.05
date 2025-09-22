#!/usr/bin/env bash
#
# debian 13 installer
#

echo 
echo "This installer is for Debian 13 Trixie web portall"
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

# basic sanity check -
apt update

# set locale for apt 
apt install -y locales
cp contrib/locale.gen /etc
/usr/sbin/locale-gen

# make sure perl is installed 
apt-get -y install perl

# make sure we have postfix
apt remove --purge exim4  exim4-base  exim4-config exim4-daemon-light
apt-get install -y postfix

# find out what we need to change
process-changes.sh

#
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
apt-get install -y perl-Net-DNS-Nameserver
apt-get install -y razor
apt-get install -y libmail-spf-perl
apt-get install -y spamassassin
#
#
# non-interactive cpan installs
#

apt-get install -y cpanminus

cpanm Digest::SHA1
cpanm IP::Country::Fast
cpanm LWP
cpanm Net::LDAP::LDIF
#cpanm Razor2::Client::Agent


#
# web interface
#

apt-get install -y apache2 apache2-utils 
mkdir -p /var/www/html/maia
cp -r php/* /var/www/html/maia

echo
echo "installing php modules"
echo
apt-get install -y libapache2-mod-php
apt-get install -y php-mysql
apt-get install -y php-mbstring
apt-get install -y php-bcmath
apt-get install -y php-gd
apt-get install -y php-xml
apt-get install -y php-pear

apt-get install -y smarty3
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
pear install Image_Color
pear install Image_Canvas-0.3.5
pear install Image_Graph-0.8.0
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
chown maia.www-data /var/www/html/maia/themes/*/compiled
cp config.php /var/www/html/maia/
mkdir /var/www/cache
chown -R www-data.www-data /var/www/cache
chmod 775 /var/www/cache

echo
echo "reloading http server"
apachectl restart

host=`grep HOST installer.tmpl | awk -F\= '{ print $2 }'`

echo    "Now would be a good time to verify the web dependencies at"
echo    " http://$host/maia/admin/configtest.php"
echo

