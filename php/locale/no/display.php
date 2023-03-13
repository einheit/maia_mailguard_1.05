<?php
    /*
     * $Id: display.php,v 1.1.2.1 2004/09/07 19:29:05 jleaver Exp $
     *
     * MAIA MAILGUARD LICENSE v.1.0
     *
     * Copyright 2004 by Robert LeBlanc <rjl@renaissoft.com>
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

    // Menu items
    $lang['menu_stats'] =  "Statistikk";
    $lang['menu_settings'] =  "Innstillinger";
    $lang['menu_whiteblacklist'] =  "W/B Liste";
    $lang['menu_quarantine'] =  "Karantene";
    $lang['menu_report'] =  "Rapporter Spam";
    $lang['menu_admin'] =  "Admin";
    $lang['menu_help'] =  "Hjelp";
    $lang['menu_logout'] =  "Logg ut";

    // Text messages
    $lang['text_version'] =  "Versjon";
    $lang['text_all_users'] =  "alle brukere";
    $lang['text_day'] =  "dag";
    $lang['text_efficiency'] =  "Effektivitet";
    $lang['text_sensitivity'] =  "Sensitivitet";
    $lang['text_specificity'] =  "Spesifikitivitet";
    $lang['text_ppv'] =  "PPV";
    $lang['text_npv'] =  "NPV";
    $lang['text_false_positive'] =  "Falske Positive";
    $lang['text_false_negative'] =  "Falske Negative";

    // Links
    $lang['link_systemwide'] =  "System-statistikk";
    $lang['link_personal'] =  "Din Statistikk";
    $lang['link_viruses'] =  "Virus-statistikk";
    $lang['link_rules'] =  "SpamAssassin Regel-statistikk";

    // Table headers
    $lang['header_score'] =  "Score";
    $lang['header_count'] =  "Antall";
    $lang['header_size'] =  "Størrelse";
    $lang['header_min'] =  "Min";
    $lang['header_max'] =  "Maks";
    $lang['header_average'] =  "Gj. snitt";
    $lang['header_bandwidth'] =  "Båndbredde";
    $lang['header_percent'] =  "Prosent";
    $lang['header_cost'] =  "Kost";
    $lang['header_items'] =  "Meldinger";
    $lang['header_type'] =  "Mailtype";
    $lang['header_user'] =  "Statistikk for Bruker: %s";
    $lang['header_systemwide'] =  "Statistikk for Alle Brukere";
    $lang['header_spam_score'] =  "Score";
    $lang['header_rule_triggered'] =  "Utløst Regel";
    $lang['header_explanation'] =  "Forklaring";

    $lang['array_header'] =  array("ham"            => "Bekreftet Seriøs Epost",
                                      "suspected_ham"  => "Antatt Seriøs Epost",
                                      "suspected_spam" => "Antatt Useriøs Epost",
                                      "spam"           => "Bekreftet Useriøs Epost",
                                      "virus"          => "Viruses/Malware",
                                      "fp"             => "Falske Positive",
                                      "fn"             => "Falske Negative",
                                      "wl"             => "Hvitelista meldinger",
                                      "bl"             => "Svartelista meldinger",
                                      "bad_header"     => "Ugyldig Mail-header",
                                      "banned_file"    => "Bannede Vedlegg",
                                      "oversized"       => "For store meldinger");

    $lang['array_count'] =  array("ham"            => "Seriøse epost mottatt",
                                      "suspected_ham"  => "Antatt seriøs epost mottatt",
                                      "suspected_spam" => "Antatt useriøs epost i Karantene",
                                      "spam"           => "Bekreftet useriøs epost mottatt",
                                      "virus"          => "Virus mottatt",
                                      "fp"             => "Seriøse epostmeldinger feiltolket som spam",
                                      "fn"             => "Useriøse epostmeldinger feilttolket som ham",
                                      "wl"             => "Meldinger mottatt fra hvitelista sendere",
                                      "bl"             => "Meldinger mottatt fra svartelista sendere",
                                      "bad_header"     => "Meldinger med ugyldige mail-headere",
                                      "banned_file"    => "Meldinger med bannede fil-vedlegg",
                                      "oversized"      => "Meldinger for store for filteret");

    $lang['array_arrivals'] =  array("ham"            => "Ham ankomster",
                                      "suspected_ham"  => "Antatte ham-ankomster",
                                      "suspected_spam" => "Antatte spam-ankomster",
                                      "spam"           => "Bekfreftede spam-ankomster",
                                      "virus"          => "Virus-ankomster",
                                      "fp"             => "Falsk positiv error",
                                      "fn"             => "Falsk negativ error",
                                      "wl"             => "Hvitelista ankomster",
                                      "bl"             => "Svartelista ankomster",
                                      "bad_header"     => "Ugyldig-header ankomster",
                                      "banned_file"    => "Banned file arrivals",
                                      "oversized"      => "Oversized item arrivals");

    $lang['array_highest_score'] =  array("ham"            => "Høyeste seriøs epost score",
                                      "suspected_ham"  => "Høyeste antatte seriøs epost score",
                                      "suspected_spam" => "Høyeste antatte useriøs epost score",
                                      "spam"           => "Høyeste useriøs epost score",
                                      "virus"          => "",
                                      "fp"             => "Høyeste falsk-positive score",
                                      "fn"             => "Høyeste falsk-negative score",
                                      "wl"             => "",
                                      "bl"             => "",
                                      "bad_header"     => "",
                                      "banned_file"    => "",
                                      "oversized"      => "");

    $lang['array_lowest_score'] =  array("ham"            => "Laveste seriøs epost score",
                                      "suspected_ham"  => "Laveste antatte seriøs epost score",
                                      "suspected_spam" => "Laveste antatte useriøs epost score",
                                      "spam"           => "Laveste useriøs epost score",
                                      "virus"          => "",
                                      "fp"             => "Laveste falsk-positive score",
                                      "fn"             => "Laveste falsk-negative score",
                                      "wl"             => "",
                                      "bl"             => "",
                                      "bad_header"     => "",
                                      "banned_file"    => "",
                                      "oversized"      => "");

    $lang['array_average_score'] =  array("ham"            => "Gjennomsnittelig ham score",
                                      "suspected_ham"  => "Gjennomsnittelig antatt ham score",
                                      "suspected_spam" => "Gjennomsnittelig antatt spam score",
                                      "spam"           => "Gjennomsnittelig spam score",
                                      "virus"          => "",
                                      "fp"             => "Gjennomsnittelig falsk-positive score",
                                      "fn"             => "Gjennomsnittelig falsk-negative score",
                                      "wl"             => "",
                                      "bl"             => "",
                                      "bad_header"     => "",
                                      "banned_file"    => "",
                                      "oversized"      => "");

    $lang['array_largest_size'] =  array("ham"            => "Største ham størrelse",
                                      "suspected_ham"  => "Største antatt ham størrelse",
                                      "suspected_spam" => "Largest suspected spam size",
                                      "spam"           => "Largest spam size",
                                      "virus"          => "Largest virus size",
                                      "fp"             => "Largest false positive size",
                                      "fn"             => "Largest false negative size",
                                      "wl"             => "Largest whitelisted item size",
                                      "bl"             => "Largest blacklisted item size",
                                      "bad_header"     => "Largest bad header item size",
                                      "banned_file"    => "Largest banned file item size",
                                      "oversized"      => "Largest oversized item size");

    $lang['array_smallest_size'] =  array("ham"            => "Smallest ham size",
                                      "suspected_ham"  => "Smallest suspected ham size",
                                      "suspected_spam" => "Smallest suspected spam size",
                                      "spam"           => "Smallest spam size",
                                      "virus"          => "Smallest virus size",
                                      "fp"             => "Smallest false positive size",
                                      "fn"             => "Smallest false negative size",
                                      "wl"             => "Smallest whitelisted item size",
                                      "bl"             => "Smallest blacklisted item size",
                                      "bad_header"     => "Smallest bad header item size",
                                      "banned_file"    => "Smallest banned file item size",
                                      "oversized"      => "Smallest oversized item size");

    $lang['array_average_size'] =  array("ham"            => "Average ham size",
                                      "suspected_ham"  => "Average suspected ham size",
                                      "suspected_spam" => "Average suspected spam size",
                                      "spam"           => "Average spam size",
                                      "virus"          => "Average virus size",
                                      "fp"             => "Average false positive size",
                                      "fn"             => "Average false negative size",
                                      "wl"             => "Average whitelisted item size",
                                      "bl"             => "Average blacklisted item size",
                                      "bad_header"     => "Average bad header item size",
                                      "banned_file"    => "Average banned file item size",
                                      "oversized"      => "Average oversized item size");

    $lang['array_bandwidth'] =  array("ham"            => "Ham bandwidth",
                                      "suspected_ham"  => "Suspected ham bandwidth",
                                      "suspected_spam" => "Suspected spam bandwidth",
                                      "spam"           => "Spam bandwidth",
                                      "virus"          => "Virus bandwidth",
                                      "fp"             => "False positive bandwidth",
                                      "fn"             => "False negative bandwidth",
                                      "wl"             => "Whitelisted item bandwidth",
                                      "bl"             => "Blacklisted item bandwidth",
                                      "bad_header"     => "Bad header item bandwidth",
                                      "banned_file"    => "Banned file item bandwidth",
                                      "oversized"      => "Oversized item bandwidth");

    $lang['array_cost'] =  array("ham"            => "Ham bandwidth cost",
                                      "suspected_ham"  => "Suspected ham bandwidth cost",
                                      "suspected_spam" => "Suspected spam bandwidth cost",
                                      "spam"           => "Spam bandwidth cost",
                                      "virus"          => "Virus bandwidth cost",
                                      "fp"             => "False positive bandwidth cost",
                                      "fn"             => "False negative bandwidth cost",
                                      "wl"             => "Whitelisted item bandwidth cost",
                                      "bl"             => "Blacklisted item bandwidth cost",
                                      "bad_header"     => "Bad header item bandwidth cost",
                                      "banned_file"    => "Banned file item bandwidth cost",
                                      "oversized"      => "Oversized item bandwidth cost");

    $lang['array_percentage'] =  array("ham"            => "As a percentage of total mail received",
                                      "suspected_ham"  => "As a percentage of total mail received",
                                      "suspected_spam" => "As a percentage of total mail received",
                                      "spam"           => "As a percentage of total mail received",
                                      "virus"          => "As a percentage of total mail received",
                                      "fp"             => "As a percentage of total mail received",
                                      "fn"             => "As a percentage of total mail received",
                                      "wl"             => "As a percentage of total mail received",
                                      "bl"             => "As a percentage of total mail received",
                                      "bad_header"     => "As a percentage of total mail received",
                                      "banned_file"    => "As a percentage of total mail received",
                                      "oversized"      => "As a percentage of total mail received");
?>