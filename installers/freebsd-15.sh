#!/bin/sh
#
# FreeBSD 15 installer
#

echo "This install script is a work in progress. As of now, it installs"
echo "the perl components and maiad such that configtest.pl will pass,"
echo "as well as the mysql database."
echo
echo "There is still more work to be done for a complete maia install," 
echo "but consider this a preview of things to come."

DBG=0

echo 
echo "This install script is for FreeBSD 15 and a mysql DB"
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

# create vscan account if it doesn't already exist
id vscan
[ $? == 0 ] && pw user add vscan -c "Scanning Virus Account" -d /var/maiad -m -s /bin/sh

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

cp -r freebsd/sbin/configtest.pl /usr/local/share/maia-mailguard/scripts/
cp -r freebsd/maia_templates/* /usr/local/etc/maia-mailguard/templates

cp freebsd/sbin/maiad /usr/local/sbin
chown root:wheel /usr/local/sbin/maiad

chmod 2775 /var/maiad/tmp
chown -R vscan:vscan /var/maiad

mkdir -p /usr/local/etc/maia-mailguard/
cp maia.conf /usr/local/etc/maia-mailguard/maia.conf 
cp maiad.conf /usr/local/etc/maia-mailguard/maiad.conf
cp freebsd/etc/maiad.rc /usr/local/etc/rc.d/maiad

# maiad helpers
pkg install -y arc
pkg install -y arj
pkg install -y nomarch
pkg install -y rar
pkg install -y unarj
pkg install -y unrar
pkg install -y unzoo
pkg install -y zoo

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


### To be continued...
