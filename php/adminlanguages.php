<?php
    /*
     * $Id: adminlanguages.php 1439 2009-11-17 23:31:04Z dmorton $
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
    require_once ("./locale/$display_language/adminlanguages.php");

    require_once ("smarty.php");
    
    // Only the superadministrator should be here.
    if (!is_superadmin($uid)) {
       header("Location: index.php" . $sid);
       exit();
    }

    // Cancel any impersonations currently in effect
    // by resetting EUID = UID and forcing a reload
    // of this page.
    if ($uid != $euid) {
       $euid = $uid;
       $_SESSION["euid"] = $uid;
       header("Location: adminlanguages.php" . $sid);
       exit();
    }

    $sth = $dbh->prepare("SELECT language_name, abbreviation, id " .
              "FROM maia_languages " .
              "WHERE installed = 'Y' " .
              "ORDER BY language_name ASC");
    $res = $sth->execute();
    // if (PEAR::isError($sth)) { 
    if ((new PEAR)->isError($sth)) { 
        die($sth->getMessage()); 
    } 
    $smarty->assign('rowcount', $res->numrows());
    $languages = array();
    while ($row = $res->fetchrow()) {
        $languages[] = array(
            'language_name' => $row["language_name"],
            'language_abbrev' => strtolower($row["abbreviation"]),
            'language_id' => $row["id"]
        );
    }
    $smarty->assign('languages', $languages);
    $sth->free();

    $lang_dir = "locale";
    $d = dir($lang_dir);
    $dirlist = array();
    $phlist = array();
    $atleastone = false;
    while (($f = $d->read()) !== false) {
    	$atleastone = true;
    	if (is_dir($lang_dir . "/" . $f) && $f != "." && $f != ".." && $f != ".svn") {
            if(file_exists($lang_dir . "/" . $f . "/name")) {
                $name = file_get_contents($lang_dir . "/" . $f . "/name");
            } else {
                $name = "N/A";
            }
            $dirlist[$f] = array(
                'language_abbrev' => $f,
                'language_name' => $name
            );
            $phlist[] = '?';
        }
    }
    $d->close();

    if ($atleastone) {

        $sth = $dbh->prepare("SELECT language_name, abbreviation, id " .
                  "FROM maia_languages " .
                  "WHERE installed = 'N' AND abbreviation IN (" . implode(',', $phlist) . ") " .
                  "ORDER BY language_name ASC");
        $res = $sth->execute(array_keys($dirlist));
        if (PEAR::isError($sth)) { 
            die($sth->getMessage()); 
        } 
        while ($row = $res->fetchrow()) {
            $dirlist[$row["abbreviation"]] = array(
                'language_name' => $row["language_name"],
                'language_abbrev' => strtolower($row["abbreviation"]),
            );
        }
        $sth->free();
        // Don't offer languages that aren't physically installed yet
        $sth = $dbh->prepare("SELECT language_name, abbreviation, id " .
                  "FROM maia_languages " .
                  "WHERE installed = 'Y' AND abbreviation IN (" . implode(',', $phlist) . ") " .
                  "ORDER BY language_name ASC");
        $res = $sth->execute(array_keys($dirlist));
        // if (PEAR::isError($sth)) { 
        if ((new PEAR)->isError($sth)) { 
            die($sth->getMessage()); 
        } 

        //$languages2 = array();
        while ($row = $res->fetchrow()) {
            unset($dirlist[$row['abbreviation']]);
        }
        $sth->free();
        ksort($dirlist);
        $smarty->assign('dirlist', $dirlist);
    }
    $smarty->assign('atleastone', sizeof($dirlist));

    $smarty->display('adminlanguages.tpl');
?>
