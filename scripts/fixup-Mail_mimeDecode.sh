#!/usr/bin/env bash
# fix up PEAR::Mail_mimeDecode after it's been installed

git clone https://github.com/jdimeglio/mimeDecode-fix-PHP8.git

cd mimeDecode-fix-PHP8

cp /usr/share/php/Mail/mimeDecode.php /usr/share/php/Mail/mimeDecode.php-orig

cp mimeDecode.php /usr/share/php/Mail


