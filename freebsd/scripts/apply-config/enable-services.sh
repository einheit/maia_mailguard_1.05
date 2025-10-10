#!/bin/sh
#
# enable the maia related service in /etc/rc.conf
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

