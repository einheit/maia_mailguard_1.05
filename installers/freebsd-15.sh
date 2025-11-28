#!/bin/sh
#
# FreeBSD 15 installer
#

DBG=0

echo
echo "This install script is for FreeBSD 15 and a mysql DB"
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

# install stage 1 packages
pkg update
pkg install -y git
pkg install -y postfix
pkg install -y wget

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

pkg install -y p5-Template-Toolkit p5-Archive-Zip \
  p5-BerkeleyDB p5-Convert-TNEF p5-Convert-UUlib \
  p5-Crypt-OpenSSL-RSA p5-DBI p5-DBD-mysql p5-DBD-Pg \
  p5-Data-Dumper-Concise p5-Data-UUID p5-DateTime \
  p5-Digest-SHA1 p5-GeoIP2 p5-IO-Multiplex \
  p5-IO-Socket-INET6 p5-IO-Socket-SSL p5-IP-Country \
  p5-LWP-Protocol-https p5-Locale-gettext \
  p5-MIME-Base64 p5-MIME-Tools p5-Mail-DKIM p5-Mail-SPF \
  p5-NetAddr-IP p5-Net-SSLeay p5-Net-Server p5-NetAddr-IP \
  p5-Net-CIDR-Lite p5-Net-DNS p5-forks p5-Unix-Syslog \
  p5-Text-CSV spamassassin razor-agents p5-App-cpanminus

  # needed for maiadbtool
  cpanm Net/LDAP/LDIF.pm


# create vscan account 
pw user add vscan -c "Scanning Virus Account" -d /var/maiad -m -s /bin/sh

if [ $DBG != 0 ]; then
  echo "checkpoint 2"
  read junk
fi

mkdir -p /var/log/maia
chown -R vscan:vscan /var/log/maia

mkdir -p /var/maiad/tmp
mkdir -p /var/maiad/db
mkdir -p /usr/local/share/maia-mailguard/scripts
mkdir -p /usr/local/etc/maia-mailguard/templates

cp -r ${OS}/maia_scripts/* /usr/local/share/maia-mailguard/scripts/
cp -r maia_templates/* /usr/local/etc/maia-mailguard/templates
ln -s /usr/local/etc/maia-mailguard/templates  /usr/local/share/maia-mailguard/
cp ${OS}/sbin/maiad /usr/local/sbin

chown -R root:wheel /usr/local/share/maia-mailguard/
chown -R root:wheel /usr/local/etc/maia-mailguard/
chown root:wheel /usr/local/sbin/maiad

chmod 2775 /var/maiad/tmp
chown -R vscan:vscan /var/maiad

mkdir -p /usr/local/etc/maia-mailguard/
cp maia.conf /usr/local/etc/maia-mailguard/maia.conf 
cp maiad.conf /usr/local/etc/maia-mailguard/maiad.conf
cp ${OS}/etc/maiad.rc /usr/local/etc/rc.d/maiad

# maiad helpers
pkg install -y arc arj lha lzop nomarch rar unrar \
 unarj zoo unzoo cabextract ripole rpm2cpio

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
  sleep 30
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
pkg install -y apache24

mkdir -p /usr/local/www/maia-mailguard
cp -r php/* /usr/local/www/maia-mailguard

pkg install -y php83 php83-bcmath php83-ctype php83-gd php83-iconv \
  php83-imap php83-mbstring php83-mysqli php83-pdo php83-pdo_mysql \
  php83-pdo_pgsql php83-pdo_sqlite php83-pear php83-pear-Auth_SASL \
  php83-pear-Mail php83-pear-Mail_Mime php83-pear-Mail_mimeDecode \
  php83-pear-Math_BigInteger php83-pear-Net_IMAP php83-pear-Net_POP3 \
  php83-pear-Net_SMTP php83-pear-Net_Socket php83-pear-Numbers_Roman \
  php83-pear-Numbers_Words php83-pear-Pager php83-pecl-mcrypt \
  php83-pgsql php83-posix php83-session php83-simplexml php83-sockets \
  php83-sqlite3 php83-tokenizer php83-xml php83-zlib smarty3-php83

# link Smarty
ln -s /usr/local/share/smarty3-php83/ /usr/local/share/php/Smarty

# pear fixes -
pear channel-update pear.php.net
pear install Log-1.13.3

fixup-Mail_mimeDecode.sh
supply-mcrypt.sh /usr/local/share/pear

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
chown www:www /var/www/cache
ln -s /var/www/cache /usr/local/www/maia-mailguard/cache

#
# configure apache for maia
#

# point to the maia mailguard directory
ln -s /usr/local/www/maia-mailguard /usr/local/www/apache24/data/

# set up php-fpm handler
cp ${OS}/etc/php.conf /usr/local/etc/apache24/Includes

has_php_cfg=`grep "maia_config" /usr/local/etc/apache24/httpd.conf | wc -l`
if [ $has_php_cfg == '0' ]; then
  perl -pi -e 'print "# maia_config requires the following two lines:\n" if  $. == 66' /usr/local/etc/apache24/httpd.conf
  perl -pi -e 'print "LoadModule proxy_module libexec/apache24/mod_proxy.so\n" if  $. == 67' /usr/local/etc/apache24/httpd.conf
  perl -pi -e 'print "LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so\n" if  $. == 68' /usr/local/etc/apache24/httpd.conf
  perl -pi -e 'print "#\n" if  $. == 69' /usr/local/etc/apache24/httpd.conf
  perl -pi -e s/'DirectoryIndex index.html'/'DirectoryIndex index.php index.html'/g /usr/local/etc/apache24/httpd.conf
fi

cp -a /usr/local/etc/php.ini-production /usr/local/etc/php.ini


# enable the maia related services in /etc/rc.conf
#

echo "Enabling automatic startup of maia services..."

TGT=/etc/rc.conf
cp -a $TGT ${TGT}-save-$$

ITEMS="apache24_enable
php_fpm_enable
maiad_enable
clamav_clamd_enable
clamav_freshclam_enable
mysql_enable
postfix_enable"

for item in $ITEMS
do
    grep $item $TGT || echo "$item=yes" >> $TGT
done

# call postfix setup script
postfix-setup.sh

# make sure postfix is set up for maia
has_pf_cfg=`grep "maia_config" /usr/local/etc/postfix/master.cf | wc -l`
if [ $has_pf_cfg == '0' ]; then
    cp -a /usr/local/etc/postfix/master.cf /usr/local/etc/postfix/master.cf-save-$$
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
" >> /usr/local/etc/postfix/master.cf
fi

echo "starting/restarting services"
for i in apache24 php_fpm postfix maiad clamav_clamd clamav_freshclam mysql
do
    present=`grep $i /etc/rc.conf | grep yes`
    count=`echo $present| wc -l`
    if [ $count -eq 1 ]; then
        service $i restart
    fi
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

