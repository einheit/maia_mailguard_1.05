echo
echo "setting up postfix for maia spam/virus filtering"
echo

cp /usr/local/etc/postfix/main.cf /usr/local/etc/postfix/main.cf-save-$$
cp /usr/local/etc/postfix/master.cf /usr/local/etc/postfix/master.cf-save-$$

has_pf_cfg=`grep "maia_config" /usr/local/etc/postfix/master.cf | wc -l`
if [ $has_pf_cfg == '0' ]; then
    cp -a /usr/local/etc/postfix/master.cf /usr/local/etc/postfix/master.cf-save-$$
    cat master.cf-append >> /usr/local/etc/postfix/master.cf
fi

postconf -e inet_interfaces=all
postconf -e content_filter=maia:[127.0.0.1]:10024

# need to add headers to the emails from maia
# due to failure of pear mail to add message-id
postconf -e always_add_missing_headers=yes


hostname=`grep FQDN installer.tmpl | awk -F\= '{ print $2 }'`
domain=`grep DOMAIN installer.tmpl | awk -F\= '{ print $2 }'`
postconf -e myhostname=${hostname}
postconf -e mydomain=${domain}

# do we need to add a relayhost?
relayhost=`grep RELAY installer.tmpl | awk -F\= '{ print $2 }'`
addrelay=`echo $relayhost | wc -l`
[ $addrelay ] && postconf -e relayhost=$relayhost

# the calling script needs to restart postfix after this returns
