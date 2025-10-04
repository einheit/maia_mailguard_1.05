#!/bin/sh
# fix up PEAR::Mail_mimeDecode after it's been installed

git clone https://github.com/jdimeglio/mimeDecode-fix-PHP8.git

cd mimeDecode-fix-PHP8

cp -a /usr/local/share/pear/Mail/mimeDecode.php /usr/local/share/pear/Mail/mimeDecode.php-orig

cp mimeDecode.php /usr/local/share/pear/Mail/

