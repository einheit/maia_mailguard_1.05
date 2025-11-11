#!/bin/sh
#
# collect info and update maia related config files 
#

export PATH=.:$PATH

# define inline-edit function for use below
inline-edit() {
  old_str=$1
  new_str=$2
  filename=$3
  echo "perl -p -e 's#"$old_str"#"$new_str"#g' $filename"
  perl -pi -e "s#$old_str#$new_str#g" $filename
}

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
MAIACFGDIR=/usr/local/etc/maia-mailguard
PHPCFGDIR=/usr/local/www/maia-mailguard

cp ${MAIACFGDIR}/maia.conf.dist ${MAIACFGDIR}/maia.conf
cp ${MAIACFGDIR}/maiad.conf.dist ${MAIACFGDIR}/maiad.conf
cp ${PHPCFGDIR}/config.php.dist ${PHPCFGDIR}config.php

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

MAIACFGDIR=/usr/local/etc/maia-mailguard/
PHPCFGDIR=/usr/local/www/maia-mailguard/
 echo "modifying maia base_url"
 inline-edit example.com ${websrv}/maia ${MAIACFGDIR}/maia.conf
 echo "editing HOST"
 inline-edit '__HOST__' $HOST ${MAIACFGDIR}/maiad.conf
 echo "editing DOMAIN"
 inline-edit '__DOMAIN__'  $DOMAIN ${MAIACFGDIR}/maiad.conf

for i in ${PHPCFGDIR}/config.php ${MAIACFGDIR}/maia.conf ${MAIACFGDIR}/maiad.conf
do
 echo "editing DBHOST"
 inline-edit '__DBHOST__'  $dbhost $i
 echo "editing DBUSER"
 inline-edit '__DBUSER__'  $dbuser $i
 echo "editing DBNAME"
 inline-edit '__DBNAME__'  $dbname $i
 echo "editing PASSWORD"
 inline-edit '__PASSWORD__'  $passwd $i
done

#
# enable the maia related services in /etc/rc.conf
#

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

# point to the maia mailguard directory
ln -s /usr/local/www/maia-mailguard /usr/local/www/apache24/data/

#
# set up apache & php for maia
#
# cp -a php.conf /usr/local/etc/apache24/Includes/

# create php.conf for apache
echo "<FilesMatch "\.php$">
   SetHandler "proxy:fcgi://127.0.0.1:9000"
</FilesMatch>
" > /usr/local/etc/apache24/Includes/php.conf

has_php_cfg=`grep "maia_config" /usr/local/etc/apache24/httpd.conf | wc -l`
if [ $has_php_cfg == '0' ]; then
  perl -pi -e 'print "# maia_config requires the following two lines:\n" if  $. == 66' /usr/local/etc/apache24/httpd.conf
  perl -pi -e 'print "LoadModule proxy_module libexec/apache24/mod_proxy.so\n" if  $. == 67' /usr/local/etc/apache24/httpd.conf
  perl -pi -e 'print "LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so\n" if  $. == 68' /usr/local/etc/apache24/httpd.conf
  perl -pi -e 'print "#\n" if  $. == 69' /usr/local/etc/apache24/httpd.conf
  perl -pi -e s/'DirectoryIndex index.html'/'DirectoryIndex index.php index.html'/g /usr/local/etc/apache24/httpd.conf
fi

# use suitable php.ini 
cp -a /usr/local/etc/php.ini-production /usr/local/etc/php.ini

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

hostname=`grep FQDN installer.tmpl | awk -F\= '{ print $2 }'`
domain=`grep DOMAIN installer.tmpl | awk -F\= '{ print $2 }'`
postconf -e myhostname=${hostname}
postconf -e mydomain=${domain}

# do we need to add a relayhost?
relayhost=`grep RELAY installer.tmpl | awk -F\= '{ print $2 }'`
addrelay=`echo $relayhost | wc -l`
[ $addrelay ] && postconf -e relayhost=$relayhost

postconf -e inet_interfaces=all
postconf -e content_filter=maia:[127.0.0.1]:10024


echo "starting/restarting services"
for i in apache24 php_fpm postfix maiad clamav_clamd clamav_freshclam mysql
do
    present=`grep $i /etc/rc.conf | grep yes`
    count=`echo $present| wc -l`
    if [ $count -eq 1 ]; then
        service $i restart
    fi
done
