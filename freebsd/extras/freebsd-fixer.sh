#!/bin/sh
#
# FreeBSD fixer script
#

echo
echo "This script is meant to fix outliers in FreeBSD"
echo "that will allow Maia-Mailguard to work properly"
echo

# Install packages
echo "Installing needed packages"
pkg update
if ( ! which git > /dev/null ); then
	pkg install -y git-tiny
fi

# PEAR fixes
echo "Downgrading pear-Log"
pkg delete -y -f "php*-pear-Log"
pear channel-update pear.php.net
pear install Log-1.13.3

# Patch mimeDecode for PHP8+
echo "Patching mimeDecode"
MIME_TMP=`mktemp -d /tmp/mime-XXXX`
git clone https://github.com/jdimeglio/mimeDecode-fix-PHP8.git ${MIME_TMP}
cp /usr/local/share/pear/Mail/mimeDecode.php /usr/local/share/pear/Mail/mimeDecode.php.orig
cp ${MIME_TMP}/mimeDecode.php /usr/local/share/pear/Mail/
rm -rf ${MIME_TMP}

# HTMLPurifier install
echo "Installing HTMLPurifier (side-loading)"
HTMLPF=`mktemp -d /tmp/htmlpf-XXXX`
fetch https://github.com/einheit/maia_mailguard_1.05/raw/refs/heads/master/files/htmlpurifier-4.18.0.tar.gz -o ${HTMLPF}/
tar -C /var -xzf ${HTMLPF}/htmlpurifier-4.18.0.tar.gz
if [ -e /var/htmlpurifier ]; then
	rm -rf /var/htmlpurifier
fi
mv /var/htmlpurifier-4.18.0 /var/htmlpurifier
chown -R root:wheel /var/htmlpurifier
rm -rf ${HTMLPF}
