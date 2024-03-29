<?php
    /*
     * $Id: admindomains.php 1542 2011-06-15 16:48:29Z rjl $
     *
     * MAIA MAILGUARD LICENSE v.1.0
     *
     * Copyright 2004 by Robert LeBlanc <rjl@renaissoft.com>
     *                   David Morton   <mortonda@dgrmm.net>
     * All rights reserved.
     *
     * PREAMBLE
     *
     * This License is designed for users of Maia Mailguard
     * ("the Software") who wish to support the Maia Mailguard project by
     * leaving "Maia Mailguard" branding information in the HTML output
     * of the pages generated by the Software, and providing links back
     * to the Maia Mailguard home page.  Users who wish to remove this
     * branding information should contact the copyright owner to obtain
     * a Rebranding License.
     *
     * DEFINITION OF TERMS
     *
     * The "Software" refers to Maia Mailguard, including all of the
     * associated PHP, Perl, and SQL scripts, documentation files, graphic
     * icons and logo images.
     *
     * GRANT OF LICENSE
     *
     * Redistribution and use in source and binary forms, with or without
     * modification, are permitted provided that the following conditions
     * are met:
     *
     * 1. Redistributions of source code must retain the above copyright
     *    notice, this list of conditions and the following disclaimer.
     *
     * 2. Redistributions in binary form must reproduce the above copyright
     *    notice, this list of conditions and the following disclaimer in the
     *    documentation and/or other materials provided with the distribution.
     *
     * 3. The end-user documentation included with the redistribution, if
     *    any, must include the following acknowledgment:
     *
     *    "This product includes software developed by Robert LeBlanc
     *    <rjl@renaissoft.com>."
     *
     *    Alternately, this acknowledgment may appear in the software itself,
     *    if and wherever such third-party acknowledgments normally appear.
     *
     * 4. At least one of the following branding conventions must be used:
     *
     *    a. The Maia Mailguard logo appears in the page-top banner of
     *       all HTML output pages in an unmodified form, and links
     *       directly to the Maia Mailguard home page; or
     *
     *    b. The "Powered by Maia Mailguard" graphic appears in the HTML
     *       output of all gateway pages that lead to this software,
     *       linking directly to the Maia Mailguard home page; or
     *
     *    c. A separate Rebranding License is obtained from the copyright
     *       owner, exempting the Licensee from 4(a) and 4(b), subject to
     *       the additional conditions laid out in that license document.
     *
     * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS
     * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
     * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
     * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
     * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
     * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
     * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
     * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
     * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
     * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
     * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
     *
     */

    require_once ("core.php");
    require_once ("maia_db.php");
    require_once ("authcheck.php");
    require_once ("display.php");
    $display_language = get_display_language($euid);
    require_once ("./locale/$display_language/db.php");
    require_once ("./locale/$display_language/display.php");
    require_once ("./locale/$display_language/xadminusers.php"); // pick up headers for cache listings
    require_once ("./locale/$display_language/admindomains.php");

    require_once ("smarty.php");
    // Only administrators should be here.
    if (!is_an_administrator($uid)) {
       header("Location: index.php" . $sid);
       exit();
    }

    // Cancel any impersonations currently in effect
    // by resetting EUID = UID and forcing a reload
    // of this page.
    if ($uid != $euid) {
       $euid = $uid;
       $_SESSION["euid"] = $uid;
       header("Location: admindomains.php" . $sid);
       exit();
    }

    // Is this administrator the superadmin, or just a
    // domain admin?
    $super = is_superadmin($uid);
    if ($super) {
        $domaincols = 7;
    } else {
        $domaincols = 6;
    }
    $smarty->assign('cols', $domaincols);

    if ($super) {
        $select = <<<ENDSELECT
        SELECT maia_domains.domain, maia_domains.id as domain_id, maia_users.id as maia_user_id,
               count(maia_mail_recipients.mail_id) as items,
               maia_mail_recipients.type
        FROM maia_domains LEFT JOIN maia_users ON maia_domains.domain = maia_users.user_name
             LEFT JOIN maia_mail_recipients ON maia_users.id = maia_mail_recipients.recipient_id
        GROUP BY maia_domains.domain, maia_mail_recipients.type, maia_domains.id, maia_users.id
        ORDER BY domain ASC
ENDSELECT;
        $sth = $dbh->prepare($select);
        $res = $sth->execute();
        // if (PEAR::isError($sth)) { 
        if ((new PEAR)->isError($sth)) {             
            die($sth->getMessage()); 
        }
    } else {
        $select = <<<ENDSELECT
        SELECT maia_domains.domain, maia_domains.id as domain_id, maia_users.id as maia_user_id,
                count(maia_mail_recipients.mail_id) as items,
                maia_mail_recipients.type
        FROM maia_domain_admins LEFT JOIN maia_domains ON maia_domains.id = maia_domain_admins.domain_id
            LEFT JOIN maia_users ON maia_domains.domain = maia_users.user_name
            LEFT JOIN maia_mail_recipients ON maia_users.id = maia_mail_recipients.recipient_id
        WHERE maia_domain_admins.admin_id = ?
        GROUP BY maia_domains.domain, maia_mail_recipients.type, maia_domains.id, maia_users.id
        ORDER BY domain ASC
ENDSELECT;
        $sth = $dbh->prepare($select);
        $res = $sth->execute(array($uid));
        // if (PEAR::isError($sth)) { 
        if ((new PEAR)->isError($sth)) { 
            die($sth->getMessage()); 
        }
    }

    $atleastone = false;
    $domains = array();
    if ($res->numrows() > 0) {
        while ($row = $res->fetchrow()) {
            $name = strtolower($row["domain"]);
            if (!isset($domains[$name])) {
              $domains[$name] = array (
                  'maia_user_id' => $row["maia_user_id"],
                  'domain_id' => $row["domain_id"],
                  'ham' => 0,
                  'spam' => 0,
                  'virus' => 0,
                  'file' => 0,
                  'header' => 0
                  );
            }
            if ($row['type'] == "H") {
                $domains[$name]['ham'] = $row['items'];
            } elseif ($row['type'] == "S" || $row['type'] == "P") {
              $domains[$name]['spam'] += $row['items'];
            } elseif ($row['type'] == "F") {
                $domains[$name]['file'] = $row['items'];
            } elseif ($row['type'] == "V") {
                $domains[$name]['virus'] = $row['items'];
            } elseif ($row['type'] == "B") {
                $domains[$name]['header'] = $row['items'];
            }
            if ($name != "@.") {
                $atleastone = true;
            }
        }
    }
    $smarty->assign("domains", $domains);
    $smarty->assign("atleastone", $atleastone);

    
    $sth->free();
    
    $smarty->display('admindomains.tpl');
    
?>
