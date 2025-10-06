#!/usr/bin/env bash
# fix up PEAR::Mail_mimeDecode after it's been installed

DSTDIR="/usr/share/php/Mail/"

if [ $# -gt 0 ]; then
  DSTDIR=$1
fi

git clone https://github.com/jdimeglio/mimeDecode-fix-PHP8.git

cd mimeDecode-fix-PHP8

cp -a ${DSTDIR}/mimeDecode.php ${DSTDIR}/mimeDecode.php-orig

cp mimeDecode.php ${DSTDIR}


