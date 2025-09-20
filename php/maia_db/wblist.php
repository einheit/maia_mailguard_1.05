<?php

    /*
     * get_wb_status(): Returns 'W' if a given e-mail address appears in a given user's
     *                  whitelist, 'B' if it appears in the user's blacklist, or '' otherwise.
     */
function get_wb_status($user_id, $addr_id)
{
    global $dbh;

    $wb = '';
    $sth = $dbh->prepare(
        "SELECT wb " .
             "FROM wblist " .
             "WHERE rid = ? " .
             "AND sid = ?"
    );
    $res = $sth->execute(array($user_id, $addr_id));
    if ($row = $sth->fetch()) {
        $wb = $row["wb"];
    }

    return $wb;
}


    /*
     * set_wb_status(): Changes the status ('W' or 'B') of an entry in a given user's
     *                  whitelist/blacklist.
     */
function set_wb_status($user_id, $addr_id, $wb)
{
    global $dbh;
    global $logger;

    try {
      $sth = $dbh->prepare("UPDATE wblist SET wb = ? WHERE rid = ? AND sid = ?");
      $sth->execute(array($wb, $user_id, $addr_id));

    } catch (PDOException $e) {
        return 'text_wblist_error';
    }
}


    /*
    * add_wb_entry(): Adds a new entry to a user's whitelist/blacklist.
    */
function add_wb_entry($user_id, $addr_id, $wb)
{
    global $dbh;

    $sth = $dbh->prepare("INSERT INTO wblist (rid, sid, wb) VALUES (?, ?, ?)");
    $sth->execute(array($user_id, $addr_id, $wb));

}


    /*
    * delete_wb_entry(): Removes an entry from a user's whitelist/blacklist.
    */
function delete_wb_entry($user_id, $addr_id)
{
    global $dbh;

    $sth = $dbh->prepare("DELETE FROM wblist WHERE rid = ? AND sid = ?");
    $sth->execute(array($user_id, $addr_id));

    // If there are no other references to this address,
    // remove it from the mailaddr table as well.
    $sth2 = $dbh->prepare("SELECT wb FROM wblist WHERE sid = ?");
    $res = $sth2->execute(array($addr_id));
    
    if (!$sth2->fetch()) {
	try {
          $sth3 = $dbh->prepare("DELETE FROM mailaddr WHERE id = ?");
          $sth3->execute(array($addr_id));

	} catch (PDOException $e) {
            $logger->err("Problem updating wblist: " . $sth3->getMessage());
            return $lang['text_wblist_error'];
        }
    }
    return 'text_wb_deleted';
}


    /*
    * delete_user_wb_entries(): Removes all entries from a user's whitelist/blacklist.
    */
function delete_user_wb_entries($user_id)
{
    global $dbh;

    $sth = $dbh->prepare(
        "SELECT sid " .
             "FROM wblist " .
             "WHERE rid = ?"
    );
    $res = $sth->execute(array($user_id));
    
    while ($row = $sth->fetch()) {
        delete_wb_entry($user_id, $row["sid"]);
    }
}


    /*
    * add_address(): Adds a new e-mail address to the mailaddr table.
    *                Note: Assumes that address is either in "user@domain" form
    *                      or "@domain" form.  i.e. call fix_address() first.
    */
function add_address($email)
{
    global $dbh;

    $addr_id = 0;
    $priority = get_email_address_priority($email);
    $sth = $dbh->prepare("INSERT INTO mailaddr (priority, email) VALUES (?, ?)");

    $sth->execute(array($priority, $email));

    $sth = $dbh->prepare("SELECT id FROM mailaddr WHERE email = ?");

    $res = $sth->execute(array($email));

    if ($row = $sth->fetch()) {
        $addr_id = $row["id"];
    }

    return $addr_id;
}


    /*
     * get_address_id(): Looks up the ID number of an e-mail address in
     *                   the mailaddr table.
     */
function get_address_id($addr)
{
    global $dbh;
        
    $sth = $dbh->prepare("SELECT id FROM mailaddr WHERE email = ?");
        
    $addr_id = 0;
    $res = $sth->execute(array($addr));

    if ($row = $sth->fetch()) {
        $addr_id = $row["id"];
    }
        
    return $addr_id;
}


    /*
     * add_address_to_wb_list(): Adds an e-mail address to a user's
     *                           whitelist/blacklist, if necessary.
     *     returns message code, use to match with locale strings.
     */
function add_address_to_wb_list($user_id, $addr, $wb)
{
    global $dbh;
    $matches = array();
    // look for an email address of the form <user@domain>
    if (preg_match('/<(\S+\@\S+\.\S+)>/', $addr, $matches) > 0 ) {
        $addr = $matches[1];
    }

    // if that fails, look for user@domain
    elseif (preg_match("/(\S+\@\S+\.\S+)/", $addr, $matches) > 0 ) {
        $addr = $matches[1];
    }

    $addr = fix_address($addr);
    $addr_id = get_address_id($addr);
    if (substr($addr, 0, 1) == '@') {
        $addr = "*" . $addr;
    }
    if ($addr_id == 0) {
        $addr_id = add_address($addr);
        add_wb_entry($user_id, $addr_id, $wb);
        return 'text_wb_address_added';
    } else {
        $wb_stat = get_wb_status($user_id, $addr_id);
        if ($wb_stat == '') {
            add_wb_entry($user_id, $addr_id, $wb);
            return 'text_wb_address_added';
        } else {
            if ($wb_stat != $wb) {
                set_wb_status($user_id, $addr_id, $wb);
            }
            return 'text_wb_address_changed';
        }
    }
}
