<?php
    /*
     * get_config_value(): Returns the value corresponding to a single
     *                     key from the system configuration table.  This
     *                     is a convenient way to read one configuration
     *                     setting, but if multiple configuration settings
     *                     are required, it becomes more efficient to
     *                     use a manual query, rather than calling this
     *                     function repeatedly.
     */
function get_config_value($key)
{
    global $dbh;

    $sth = $dbh->prepare("SELECT " . $key . " FROM maia_config WHERE id = 0");

    $sth->execute();
    
    while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
        $value = $row[$key];
    }

    return $value;
}


function get_database_type($dbh)
{
try {
    $driverName = $dbh->getAttribute(PDO::ATTR_DRIVER_NAME);
    }  catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    }
    return $driverName;
}

    /*
     * generate_random_password(): Generates an 8-character alphanumeric
     *                             password, and returns both the password
     *                             and its corresponding MD5 hash.
     */
function generate_random_password()
{
    $password_length = 8;

    for ($i = "A"; $i < "Z"; $i++) {
        $chars[] = $i;
    }
    for ($i = "a"; $i < "z"; $i++) {
        $chars[] = $i;
    }
    for ($i = "0"; $i < "9"; $i++) {
        $chars[] = $i;
    }

    $password = "";
    for ($i = 0; $i < $password_length; $i++) {
        $password .= $chars[mt_rand(0, count($chars)-1)];
    }
    $digest = md5($password);

    return array($password, $digest);
}


function get_chart_colors()
{
    global $dbh;

    $sth = $dbh->prepare(
        "SELECT chart_suspected_ham_colour AS sh, chart_ham_colour AS h, chart_wl_colour as wl, " .
                      "chart_bl_colour as bl, chart_suspected_spam_colour as ss, chart_spam_colour as s, " .
                      "chart_fp_colour as fp, chart_fn_colour as fn, chart_virus_colour as v " .
              "FROM maia_config WHERE id=0"
    );

    $sth->execute();
    
    if ($row = $sth->fetch()) {
        $value = $row;
    }

    $value["bf"] = "#C9BBFF";
    $value["bh"] = "#FFCC79";
    $value["os"] = "#FF8080";

    return $value;
}

// This function has been roughly and clumsily converted to PDO - jjs 20250919
function Pager_Wrapper_DB(&$db, $query, $pager_options = array(), $disabled = false, $fetchMode = null,     $dbparams = null)
{
    if (!array_key_exists('totalItems', $pager_options)) {

        $res =& $db->execute($query, $dbparams);

        $totalItems = (int)$res->rowcount();

        $pager_options['totalItems'] = $totalItems;
    }

    $pager_options['delta'] = 3;
    include_once 'Pager/Pager.php';
    $pager =& Pager::factory($pager_options);

    $page = array();
    $page['totalItems'] = $pager_options['totalItems'];
    $page['links'] = $pager->links;
    $page['page_numbers'] = array(
        'current' => $pager->getCurrentPageID(),
        'total'   => $pager->numPages()
    );
    list($page['from'], $page['to']) = $pager->getOffsetByPageId();

    // TODO - implement this correctly in the query
    // PDO does not have a setLimit() method.
    /*
    if (!$disabled) {
           $db->setLimit($pager_options['perPage'], $page['from']-1);
    }
    */

    try {
      $sth = $db->prepare($query);
        } catch (PDOException $e) {
           die("Action failed: " . $e->getMessage());
    }

    $sth->execute($dbparams);

    $page['data'] = array();

    while($row = $sth->fetch()) {
        $page['data'][] = $row;
    }
    if ($disabled) {
        $page['links'] = '';
        $page['page_numbers'] = array(
            'current' => 1,
            'total'   => 1
        );
    }

    return $page;
}


function sql_check($res, $function, $text="")
{
    global $logger;
    // if (PEAR::isError($res)) {
    if ((new PEAR)->isError($res)) {
        $logger->err("$function  " . $res->getMessage() . " " . $text);
    }
}

function response_text($cache_type)
{
    global $lang;
    switch($cache_type) {
    case "ham":
        return array($lang['button_confirm_ham'], $lang['button_report_spam'], $lang['button_ns_delete']);
    case "spam":
        return array($lang['button_rescue'], $lang['button_confirm_spam'], $lang['button_ns_delete']);
    case "virus":
        return array($lang['button_rescue'], $lang['button_report'], $lang['button_delete']);
    case "header":
        return array($lang['button_rescue'], $lang['button_report_spam'], $lang['button_ns_delete']);
    case "attachment":
        return array($lang['button_rescue'], $lang['button_report_spam'], $lang['button_delete']);
    }
}

function get_default_theme()
{
    global $dbh;
    $sth = $dbh->prepare("SELECT theme_id FROM maia_users WHERE user_name=?");
    $sth->execute(array('@.'));

    if ($row=$sth->fetch()) {
        $default_theme_id = $row['theme_id'];
    } else {
        // ack! no default?
        $default_theme_id = false;
    }

    if ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
      $default_theme_id = $row['theme_id'];
      } else {
        // ack! no default?
        $default_theme_id = false;
      }

    return $default_theme_id;
}
