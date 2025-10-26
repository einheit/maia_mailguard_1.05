#!/bin/sh
# supply missing mcrypt extension

DSTDIR="/usr/share/php/"

if [ $# -gt 0 ]; then
  DSTDIR=$1
fi

wget https://github.com/phpseclib/phpseclib/archive/refs/tags/3.0.47.tar.gz
tar xf 3.0.47.tar.gz
(cd phpseclib-3.0.47; cp -ar phpseclib ${DSTDIR})
(cd ${DSTDIR}; ln -s phpseclib phpseclib3)

wget https://github.com/phpseclib/mcrypt_compat/archive/refs/tags/2.0.6.tar.gz
tar xf 2.0.6.tar.gz
cd mcrypt_compat-2.0.6
mkdir -p ${DSTDIR}/phpseclib/mcrypt_compat
cp -ar lib/mcrypt.php ${DSTDIR}/phpseclib/mcrypt_compat

