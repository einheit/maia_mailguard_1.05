#!/bin/sh
#
# OpenBSD (7.8) installer
#

DBG=0

echo
echo "This installer in progress was unable to produce"
echo "a working install of Maia Mailguard on OpenBSD"
echo
echo "We don't feel this platform is suited to this role"
echo
echo "However, volunteers are welcome to try..."
echo

exit

echo
echo "This install script is for OpenBSD 7.8 and a mysql DB"
echo "if using postgresql or other DB, you'll need to manually"
echo "edit the maia/maiad config files & the php config file"
echo

OS=`uname | tr [A-Z] [a-z]`

# set path for the install
PATH=`pwd`/${OS}/scripts:$PATH
export PATH

# get the info, write params to a file
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

# basic pre-reqs
pkg_add -IU git
pkg_add -IU wget
pkg_add -IU perl

# find out what we need to change
process-changes.sh

# perl modules
pkg_add -IU p5-Archive-Zip
pkg_add -IU p5-LWP-Protocol-https
pkg_add -IU p5-Term-ReadLine-Perl-1.0303p1
pkg_add -IU p5-CPAN-Perl-Releases-5.20250721
pkg_add -IU p5-BerkeleyDB
pkg_add -IU p5-Convert-TNEF
pkg_add -IU p5-Convert-UUlib-1.80v1
pkg_add -IU p5-Crypt-OpenSSL-RSA-0.33p0
pkg_add -IU p5-DBI
pkg_add -IU p5-DBD-mysql
pkg_add -IU p5-DBD-pg
pkg_add -IU p5-Data-Dumper-Concise
pkg_add -IU p5-Data-UUID
pkg_add -IU p5-DateTime
pkg_add -IU p5-Digest-SHA1
pkg_add -IU p5-GeoIP2
pkg_add -IU p5-IO-Multiplex
pkg_add -IU p5-IO-Socket-INET6
pkg_add -IU p5-IO-Socket-SSL
pkg_add -IU p5-IP-Country
pkg_add -IU p5-Locale-gettext
pkg_add -IU p5-MIME-tools-5.515
pkg_add -IU p5-MIME-Tools
pkg_add -IU p5-Mail-DKIM
pkg_add -IU p5-Mail-SPF
pkg_add -IU p5-NetAddr-IP
pkg_add -IU p5-Net-SSLeay
pkg_add -IU p5-Net-Server
pkg_add -IU p5-Net-CIDR-Lite
pkg_add -IU p5-Net-DNS
pkg_add -IU p5-forks
pkg_add -IU p5-Unix-Syslog
pkg_add -IU p5-Text-CSV
pkg_add -IU p5-Mail-SpamAssassin
pkg_add -IU razor-agents

# use cpan for missing modules
cpan install Template::Toolkit

# maiad setup
useradd -m -d /var/maiad vscan

mkdir -p /var/log/maia
chown -R vscan:vscan /var/log/maia

mkdir -p /var/maiad/tmp
mkdir -p /var/maiad/db
mkdir -p /usr/local/share/maia-mailguard/scripts
mkdir -p /usr/local/etc/maia-mailguard/templates
cp maia.conf maiad.conf /usr/local/etc/maia-mailguard

cp -r ${OS}/maia_scripts/* /usr/local/share/maia-mailguard/scripts/
cp -r maia_templates/* /usr/local/etc/maia-mailguard/templates
cp ${OS}/sbin/maiad /usr/local/sbin

chown -R root:wheel /usr/local/share/maia-mailguard/
chown -R root:wheel /usr/local/etc/maia-mailguard/
chown root:wheel /usr/local/sbin/maiad

chmod 2775 /var/maiad/tmp
chown -R vscan:vscan /var/maiad

# maiad helpers
pkg_add -IU lha
pkg_add -IU lhasa
pkg_add -IU lzop
pkg_add -IU unrar
pkg_add -IU zoo
pkg_add -IU cabextract
pkg_add -IU ripole
pkg_add -IU rpm2cpio

# clamav 
pkg_add -IU clamav
pkg_add -IU clamav-unofficial-sigs
echo "updating clam AV database..."
freshclam
sigtool -V

# install mysql server if called for -
DBINST=`grep DB_INSTALL installer.tmpl | wc -l`
DB_INST=`expr $DBINST`

### work needed ###
# install mysql server if called for -
if [ $DB_INST -eq 1 ]; then
  pkg_add -IU mariadb-client
  echo "creating maia database..."
  pkg_add -IU mariadb-server
  echo 'mysql_enable="YES"' >> /etc/rc.conf.local
  rcctl start mariadb-server
  mysqladmin create maia
  maia-grants.sh
  status=$?
  if [ $status -ne 0 ]; then
    echo "*** problem granting maia privileges - db needs attention ***"
    read
  fi
  mysql maia < files/maia-mysql-freebsd.sql
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
# apache web server
pkg_add -IU apache-httpd

# php modules
pkg_add -IU php-8.3.27
pkg_add -IU php-apache-8.3.27
pkg_add -IU php-bz2-8.3.27
pkg_add -IU php-cgi-8.3.27
pkg_add -IU php-curl-8.3.27
pkg_add -IU php-dba-8.3.27
pkg_add -IU php-dbg-8.3.27
pkg_add -IU php-gd-8.3.27
pkg_add -IU php-gmp-8.3.27
pkg_add -IU php-imap-8.3.27
pkg_add -IU php-intl-8.3.27
pkg_add -IU php-ldap-8.3.27
pkg_add -IU php-mysqli-8.3.27
pkg_add -IU php-pdo_dblib-8.3.27
pkg_add -IU php-pdo_mysql-8.3.27
pkg_add -IU php-pdo_pgsql-8.3.27
pkg_add -IU php-pgsql-8.3.27
pkg_add -IU php-pspell-8.3.27
pkg_add -IU php-shmop-8.3.27
pkg_add -IU php-snmp-8.3.27
pkg_add -IU php-soap-8.3.27
pkg_add -IU php-xsl-8.3.27

# pear 
pkg_add -IU pear
pkg_add -IU pear-utils

# pear fixes -
pear channel-update pear.php.net
pear install Mail_mimeDecode
pear install Pager
pear install Net_Socket
pear install Net_SMTP
pear install Auth_SASL
pear install Log-1.13.3
pear install Net_POP3
pear install Net_IMAP
pear install Numbers_Roman
pear install Numbers_Words-0.18.2

mkdir -p /var/www/htdocs/maia/
cp -r php/* /var/www/htdocs/maia/

# install smarty from tar file
tar -C /tmp -xzf files/smarty-3.1.34.tar.gz
mv /tmp/smarty-3.1.34/libs /usr/local/share/php-8.3/Smarty    

fixup-Mail_mimeDecode.sh /var/www/pear/lib/
supply-mcrypt.sh /var/www/pear/lib/ 

# htmlpurifier -
tar -C /var -xzf files/htmlpurifier-4.18.0.tar.gz
ln -s /var/htmlpurifier-4.18.0 /var/htmlpurifier
chown -R root:wheel /var/htmlpurifier*

echo
echo "preparing php directory"

# temp bug workaround
for i in /var/www/htdoc/maia/themes/*
do
 mkdir -p ${i}/compiled
done

chmod 775 /var/www/htdoc/maia/themes/*/compiled
chown -R www:www /var/www/htdoc/maia/themes/*/compiled
cp config.php /var/www/htdocs/maia

mkdir -p /var/www/cache
chmod 775 /var/www/cache
chown www:www /var/www/cache
ln -s /var/www/cache /usr/local/www/maia/cache

# stop here
read

#
# configure apache for maia
#

# set up php-fpm handler
#cp ${OS}/etc/php.conf /usr/local/etc/apache24/Includes

has_php_cfg=`grep "maia_config" /etc/apache2/httpd2.conf | wc -l`
if [ $has_php_cfg == '0' ]; then
  perl -pi -e 'print "# maia_config requires the following two lines:\n" if  $. == 66' /etc/apache2/httpd2.conf
  perl -pi -e 'print "LoadModule proxy_module libexec/apache24/mod_proxy.so\n" if  $. == 67' /etc/apache2/httpd2.conf
  perl -pi -e 'print "LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so\n" if  $. == 68' /etc/apache2/httpd2.conf
  perl -pi -e 'print "#\n" if  $. == 69' /etc/apache2/httpd2.conf
  perl -pi -e s/'DirectoryIndex index.html'/'DirectoryIndex index.php index.html'/g /etc/apache2/httpd2.conf
fi

#cp -a /usr/local/etc/php.ini-production /usr/local/etc/php.ini

echo "Enabling automatic startup of maia services..."

ITEMS="apache24_enable
php_fpm_enable
maiad_enable
clamav_clamd_enable
clamav_freshclam_enable
mysql_enable
postfix_enable"

for item in $ITEMS
do
    rcctl enable $item
done

# call postfix setup script
postfix-setup.sh

# make sure postfix is set up for maia
has_pf_cfg=`grep "maia_config" /etc/postfix/master.cf | wc -l`
if [ $has_pf_cfg == '0' ]; then
    cp -a /etc/postfix/master.cf /etc/postfix/master.cf-save-$$
    echo "#
# begin_maia_config
#
maia    unix    -       -       n       -       2       lmtp
    -o lmtp_data_done_timeout=1200
    -o lmtp_send_xforward_command=yes
#
127.0.0.1:10025 inet n -        n       -       -       smtpd
    -o content_filter=
    -o smtpd_delay_reject=no
    -o smtpd_client_restrictions=permit_mynetworks,reject
    -o smtpd_helo_restrictions=
    -o smtpd_sender_restrictions=
    -o smtpd_recipient_restrictions=permit_mynetworks,reject
    -o smtpd_data_restrictions=reject_unauth_pipelining
    -o smtpd_end_of_data_restrictions=
    -o smtpd_restriction_classes=
    -o mynetworks=127.0.0.0/8
    -o smtpd_error_sleep_time=0
    -o smtpd_soft_error_limit=1001
    -o smtpd_hard_error_limit=1000
    -o smtpd_client_connection_count_limit=0
    -o smtpd_client_connection_rate_limit=0
    -o receive_override_options=no_header_body_checks,no_unknown_recipient_checks,no_milters,no_address_mappings
    -o local_header_rewrite_clients=
    -o smtpd_milters=
    -o local_recipient_maps=
    -o relay_recipient_maps=
#
# end_maia_config
#
" >> /etc/postfix/master.cf
fi

echo "starting/restarting services"
echo "but wait..."
read
for i in apache24 php_fpm postfix maiad clamav_clamd clamav_freshclam mysql
do
    service $i restart
done

echo "stage 2 complete"


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
echo    "started, and then check the maia mailguard configuration at"
echo    " http://$host/maia-mailguard/admin/configtest.php"
echo
echo    "if everything passes, and you have just created a new maia"
echo    "mailguard database, create the initial maia user"
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

