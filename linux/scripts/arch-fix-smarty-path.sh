ADDENDUM='	$smarty_path = "/usr/share/php/Smarty";' 
LINE=176
FILE='/srv/http/maia/config.php'

sed -i "${LINE}c\\
${ADDENDUM}" "${FILE}"
