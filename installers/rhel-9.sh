#!/usr/bin/env bash
#
# rhel 9 installer
#

echo 
echo "This script is written for rhel 9 using a mysql DB" 
echo "If using postgresql or other DB, you'll need to manually"
echo "edit configs in /etc/maia/ and ~www/maia/config.php"
echo 
echo "Be sure the system is up to date before running this script!"
echo 
echo "This script installs and configures the postfix MTA"
echo "If you wish to use something other than postfix,"
echo "you will need to install and set up that MTA after"
echo "the completion of this script, or install manually"
echo
echo "Note that selinux will be set to permissive mode."
echo
echo "For full functionality, an appropriate selinux policy"
echo "needs to be installed for maia in selinux enforcing mode"
echo 
echo -n "<ENTER> to continue or CTRL-C to stop..."
read junk
echo 

OS=`uname | tr [A-Z] [a-z]`

# set path for the install - 
PATH=`pwd`/${OS}/scripts:$PATH
export PATH

# set selinux to warn mode
setenforce 0

echo "installing basic dependencies..."

subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms && dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

# basic dependencies - 
yum install -y curl wget make gcc sudo net-tools less which rsync git

# get the info, write params to file
get-info.sh

echo "If there are no errors, this script will run to completion."
echo
echo "Note that the install could take a good while, dependng on"
echo "available computing power and network bandwidth."
echo
echo -n "Feel free to take a break - <ENTER> to proceed  "
echo
echo "proceed? "
read

# looks like we need to make sure perl and postfix are installed first
yum install -y perl
yum install -y postfix
systemctl enable postfix
systemctl restart postfix

# apply changes to config files
process-changes.sh

# set up conditions for maia to operate
yum install -y firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-service smtp
firewall-cmd --permanent --add-service smtps
firewall-cmd --permanent --add-service http
firewall-cmd --reload

# continue with install
yum install -y telnet
yum install -y file
yum install -y tar
yum install -y perl-DBI 
yum install -y spamassassin
yum install -y perl-Archive-Zip
yum install -y perl-BerkeleyDB
yum install -y perl-Convert-UUlib
yum install -y perl-DBD-MySQL perl-DBD-Pg
yum install -y perl-Net-Server
yum install -y perl-Net-DNS-Nameserver
yum install -y perl-Text-CSV
yum install -y perl-Net-CIDR-Lite
yum install -y perl-LDAP
yum install -y perl-Unix-Syslog
yum install -y perl-Razor-Agent
#yum install -y perl-Template-Toolkit
yum install -y perl-CPAN 
yum install -y perl-Geo-IP
#yum install -y perl-forks
#yum install -y perl-Data-UUID
#yum install -y perl-Convert-TNEF
#yum install -y perl-Digest-SHA1

# needed for cpanm
yum install -y perl-LWP-Protocol-https

#
# non-interactive cpan installs
#
yum install -y perl-App-cpanminus

cpanm forks
cpanm Geo-IP
cpanm IP::Country::Fast
cpanm Convert::TNEF
cpanm Convert::UUlib
cpanm Data::UUID
cpanm IO::Stringy
cpanm MIME::Parser
cpanm Template

# clamav 
yum install -y clamav 
yum install -y clamd 
yum install -y clamav-update 
yum install -y clamav-data 
yum install -y clamav-server

cp -a /etc/clamd.d/scan.conf /etc/clamd.d/scan.conf-`date +%F`
cp contrib/scan.conf-rhel-9 /etc/clamd.d/scan.conf

yum install -y httpd httpd-tools
systemctl enable httpd

#
# add maia user and chown/chmod its files/dirs
#
useradd -d /var/lib/maia maia
mkdir -p /var/lib/maia
chmod 755 /var/lib/maia

# create and chown dirs
mkdir -p /var/log/maia
chown -R maia:maia /var/log/maia

mkdir -p /var/log/clamav
chmod 775 /var/lib/clamav/

mkdir -p  /var/lib/maia/tmp
mkdir -p  /var/lib/maia/db
mkdir -p  /var/lib/maia/scripts
mkdir -p  /var/lib/maia/templates
cp ${OS}/maiad /var/lib/maia/
cp -r ${OS}/maia_scripts/* /var/lib/maia/scripts/
cp -r maia_templates/* /var/lib/maia/templates/
chown -R maia:maia /var/lib/maia/db
chown -R maia:virusgroup /var/lib/maia/tmp
chmod 2775 /var/lib/maia/tmp

mkdir -p /etc/maia
cp maia.conf maiad.conf /etc/maia/
cp ${OS}/contrib/maiad.service /etc/systemd/system/

# maiad helpers
#yum install -y arc
yum install -y arj cabextract cpio lzop pax-utils unrar unzoo

# a handy tool for a quick check
cp -a ${OS}/contrib/check-maia-ports.sh /usr/local/bin/

# configtest.pl should work now unless installing a local DB server

#
# web interface
#
mkdir -p /var/www/html/maia
cp -r php/* /var/www/html/maia

# enable services
systemctl enable maiad.service
systemctl enable clamd@scan.service
systemctl enable freshclam.service

# install mysql client to begin with - 
yum install -y mariadb 

DBINST=`grep DB_INSTALL installer.tmpl | wc -l`
DB_INST=`expr $DBINST`

# install mysql server if called for - 
if [ $DB_INST -eq 1 ]; then
  echo "creating maia database..."
  yum install -y mariadb-server
  systemctl enable mariadb.service
  systemctl start mariadb.service
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
# start maiad 
systemctl start maiad.service
# run freshclam
echo "running freshclam..."
freshclam
# start clamd
systemctl start clamd@scan.service

# load the spamassassin rulesets -
#
cp files/*.cf /etc/mail/spamassassin/
# /var/lib/maia/scripts/load-sa-rules.pl

echo
echo "installing php modules"
echo
yum install -y php
yum install -y php-pdo
yum install -y php-gd
yum install -y php-process
yum install -y php-xml
yum install -y php-mbstring
yum install -y php-mysqlnd
yum install -y php-bcmath
yum install -y php-devel
yum install -y php-pear
yum install -y php-Smarty

echo
echo "installing pear modules"
echo

pear channel-update pear.php.net

pear install Auth_SASL
pear install Log-1.13.3
pear install Mail_Mime
pear install Mail_mimeDecode
pear install Net_Socket
pear install Net_SMTP
pear install Pager
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

### checkpoint 3

echo
echo "preparing php directory"

# temp bug workaround
for i in /var/www/html/maia/themes/*
do
 mkdir -p ${i}/compiled
done

chmod 775 /var/www/html/maia/themes/*/compiled
chown apache:maia /var/www/html/maia/themes/*/compiled
cp config.php /var/www/html/maia/
mkdir /var/www/cache
chown apache:maia /var/www/cache
chmod 775 /var/www/cache

echo
echo "reloading http server"
systemctl restart httpd

# fix up Mail_mimeDecode
echo "fixing up Mail_mimedecode"
${OS}/scripts/fixup-Mail_mimeDecode.sh /usr/share/pear/Mail

echo "stage 2 complete"

# call postfix setup script
postfix-setup.sh
systemctl restart postfix

host=`grep HOST installer.tmpl | awk -F\= '{ print $2 }'`

echo
echo	"any other site specific MTA configuration can be applied now - "
echo

echo 
echo 	"at this point, a good sanity check would be to run"
echo	" /var/lib/maia/scripts/configtest.pl" 
echo 
echo	"You may now need to edit firewall to allow http access"
echo	"and set selinux to permissive to allow maia to operate"
echo	"Until appropriate selinux policies can be developed"
echo
echo	"If configtest.pl passes, check the web configuration at"
echo	" http://$host/maia/admin/configtest.php"
echo
echo	"if everything passes, and you are creating a database for the"
echo	"first time, (no existing database) create the initial maia user" 
echo	"by visiting http://$host/maia/internal-init.php"
echo
echo	"maia will send your login credentials to the email addess you"
echo	"supplied in the internal-init form. Use those credentials to"
echo	"log into the url below (note the "super=register" arg)"
echo	" http://${host}/maia/login.php?super=register"
echo
echo	"You will also need to set up cron jobs to maintain your system"
echo	"See docs/cronjob.txt for more info"
echo
echo	"Note that if selinux is enabled, you may need to remediate a"
echo	"number of selinux violations preventing maia components from running."
echo	"The script "fix-selinux-errors.pl" can be run repeatedly until"
echo	"all violations have been remediated."
echo
