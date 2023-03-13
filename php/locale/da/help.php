<?php
    /*
     * $Id$
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

    // Page subtitle
    $lang['banner_subtitle'] =  "Hjælp";

    // Section headings
    $lang['heading_introduction'] =  "Introduktion";
    $lang['heading_statistics'] =  "Statististikker";
    $lang['heading_settings'] =  "Mail Filtrerings Indstillinger";
    $lang['heading_welcome'] = "Velkomst Siden";
    $lang['heading_wblist'] =  "Godkendte og Blokerede afsendere";
    $lang['heading_quarantine'] =  "Falske Positiver";
    $lang['heading_report'] =  "Falske Negativer";
    $lang['heading_admin'] =  "Administrator Console";
    $lang['heading_for_further_assistance'] =  "For Yderligere Hjælp";
    $lang['heading_credits'] =  "Credits";
    $lang['heading_per_address_settings'] =  "Per-Adresse Indstillinger";
    $lang['heading_mail_viewer'] =  "Mail Viewer";

    // Introduction
    $lang['help_introduction_1'] =  "Mailserveren du benytter er et sofistikeret system, designet til " .
                                "ikke kun at levere og route din email, men kan scanne det for spam, vira og andet " .
                                "uønsket mail. For at få det meste ud af dette system, bør du læse dette dokument.";

    $lang['help_introduction_2'] =  "Maia Mailguard er din indgang til at styre hvordan mailserveren " .
                                "skal behandle din mail. Som du nok er klar over nu logger du på " .
                                "med det samme brugernavn og kodeord, som du bruger til at checke mail med. " .
                                "Du forbliver \"logget på\" indtil der er gået <b><i>%d minutter</i></b> mellem " .
                                "du har skiftet side (hver gang du skifter side, bliver dette nedtælllings ur nulstillet). " .
                                "Hvis det får lov til at udløbe, bliver du automatisk logget af systemet. " .
                                "Derefter kan du logge på igen. Hvis du ønsker at logge af kan du " .
                                "bruge [%s] linket på værktøjslinien eller blot lukke dette browser vindue.";
    // Welcome page
    $lang['help_welcome_1'] ="Dette er den første side du ser når du logger ind. Den indeholder et oversigts billede " .
                             "over alt hvad Maia har gjort ved dine emails. Du kan også nemt vælge beskyttelses niveau for din email adresse. " .
                             "<p>Disse niveauer er blevet udvangt af din system administrator, til brug på dette system. " .
                             "Det bør dog være sikkert af vælge \"Høj\" " .
                             "og klik på \"Skift niveau\" så snart dette er gjort, begynder Maia at scanne dine emails. " .
                             "Se indstillings siden herunder for mere information til hvordan du kan se den eksakte scoring af emails.<p> ".
                             "En lister over alle de kategorier af emails Maia scanner for er vist, sammen med hvor mange ".
                             "der er formodet at være i denne kategori. Det er her du kan hjælpe i krigen mod spam. ".
                             "Mere information om disse kategorier kan findes herunder.";
                             

    // Statistics
    $lang['help_stats_1'] =  "Din statistik side, viser statistikker over det mail Maia har behandlet " .
                         "for dig, opdelt i kategorier, efter mailtype. Ved at klikke på " .
                         "%s linket kan du se de samme statistikker, bare for alle brugere på systemet. " .
                         "De forskellige kagetorier er:";

    $lang['help_stats_2'] =  "<b>%s</b> er mail, som <i>formodenlig</i> legitim mail (også kaldet " .
                         "\"ikke-spam\").  For at se disse mails og bekræfte (eller afvise) " .
                         "denne diagnose, gå til din \"ikke-spam mappe\" ved at klikke her %s.";

    $lang['help_stats_3'] =  "<b>%s</b> er mail som du allerede har \"bekræftet\" som værende legitimt.";

    $lang['help_stats_4'] =  "<b>%s</b> forekommer når Maia fejlagtigt tror at en legitim mail er spam, " .
                         "og blokere det. Dette er en fejl. Heldigvis lader Maia dig kunne \"redde\" de emails " .
                         "det måtte ske for. For at redde den slags emails klik her %s, så mailen " .
                         "kan reddes og afsenderen kan godkendes.";

    $lang['help_stats_5'] =  "<b>%s</b> er mail som Maia tror <i>formodenlig</i> er spam. For at se disse " .
                         "mails og bekræfte (eller afvise) denne diagnose, gå til dit %s område.";

    $lang['help_stats_6'] =  "<b>%s</b> er mails du allerede har \"bekræftet\" som værende spam.";

    $lang['help_stats_7'] =  "<b>%s</b> forekommer når Maia fejlagtigt tror at en spam mail er en legitim " .
                         "mail og lader denne slippe igennem til din postkasse. Disse er mere end " .
                         "irriterende fejl. Det er forventet af spamfileret kan lave denne slags fejl. " .
                         "Men når det sker, kan du bruge %s linket og finde " .
                         "de spammails, og markere dem som spam og lade Maia lærer af sine fejltagelser.";

    $lang['help_stats_8'] =  "<b>%s</b> er mails modtaget fra afsendere på din Godkendte liste. " .
                         "Emails fra disse afsendere bliver <b>IKKE</b> spam-checkket, og de bliver <i>altid</i> leveret til din postkasse.";

    $lang['help_stats_9'] =  "<b>%s</b> er mails modtaget fra afsendere på din Blokerede liste. " .
                         "Emails fra disse afsendere bliver <b>ALDRIG</b> leveret til din postkasse, men slettet med det samme.";

    $lang['help_stats_10'] =  "<b>%s</b> er mails der er identificeret med \"skadelig software\", vira, " .
                          "orme, trojanske heste, spyware, osv. Maia sætter disse i karantæne for dig, " .
                          "for en sikkerhedsskyld, hvis du nu skulle bruge en af disse mails til et eller andet, og kan gensende dem til din postkasse.";

    $lang['help_stats_11'] =  "<b>%s</b> er \"formodet skadelig software\". Maia forsøger at være proaktiv ved at blokere " .
                          "filvedhæng af specifikke typer, typisk eksekverbare filer, som " .
                          "er kendt for at kan indeholde vira og andre former for skadelig software. Selvom " .
                          "der ikke bliver fundet skadelig software i scanningen af disse filer, bliver de alligevel sat i karantæne " .
                          "for en sikkerhedsskyld. Du kan \"redde\" dem fra dit %s område, hvis du ønsker.";

    $lang['help_stats_12'] =  "<b>%s</b> er  emails med \"ødelagte\" mail headere. Det er mails der ikke " .
                          "overholder Internet standarder vedrørende elektronisk mails. Dette sker som regel " .
                          "når spammere bruger ikke-standard programmer designet specielt til at sende spam mail. " .
                          "Disse dårligt skrevet programmer, generere \"ødelagte\" email headere " .
                          "og mens de fleste mail servere tillader dette, sætter Maia disse i karantæne så du " .
                          "kan godkende dem, hvis de alligevel skulle vise sig at være legitime emails. Dette kan du gøre " .
                          "fra dig %s område hvis du ønsker.";

    $lang['help_stats_13'] =  "<b>%s</b> er emails der er størrere end <b>%ld bytes</b>. Disse bliver " .
                          "<b>%s</b> af Maia uden af blive scannet eller leveret til din postkasse.";

    // Settings
    $lang['help_settings_1'] =  "Maia lader dig styre forskellige mail filtrerings indstillinger for hver " .
                            "email adresse du tilføjer til denne konto.";

    $lang['help_settings_2'] =  "Din <b>%s</b> er den første email adresse tilføjet til dit Maia login. " .
                            "De mails Maia sender til dig, bliver sendt til den adresse, bortset fra emails " .
                            "reddet fra karantæne området (som bliver leveret til den oprindelige leverings adresse). " .
                            "Hvis du har mere end en email adresse linket til denne konto, du kan bruge <b>%s</b> knappen " .
                            "ved siden af hver email adresse, for at gøre en ikke-primær adresse, primær for din konto.";

    $lang['help_settings_3'] =  "For at tilføje en ny email adresse til din konto, indtast brugernavn og adgangskode " .
                            "til den konto og tryk på <b>%s</b>. Hvis dine oplysninger " .
                            "bliver godkendt, bliver email adressen tilføjet til din konto med det samme.";

    $lang['help_settings_4'] =  "<b>%s</b> Hvis aktiveret, vil Maia sende en reminder email til dig når du har " .
                            "<b><i>%d eller flere emails</i></b> i dit karantæne område, som der skal gøres noget ved, " .
                            "eller filer <b><i>der fylder mere end %ld bytes</i></b>. Hvis du ikke gør " .
                            "noget ved emails/filerne i dit karantæne område, vil de blive slettet efter <b><i>%d dage.</i></b>";

    $lang['help_settings_5'] =  "<b>%s</b> bestemmer hvor vidt dine %s sider skal indeholde grafiske statistikker " .
                            "ud over de normale tabeller. Det kan være nemmere at forstå statistikkerne hvis der også er grafer med, men kan gøre siderne noget tungere.";

    $lang['help_settings_6'] =  "<b>%s</b> fortæller Maia at <i>alle</i> emails modtaget på email adresser " .
                            "linket til denne konto er bekræftet spam, da du ikke bruger denne konto til legitim email. " .
                            "Denne slags adresser bliver kun brugt som spam-lokkemad til automatiserede emailadresse høstere, brugt af spammere. " .
                            "Brug denne indstilling med forsigtighed, og <b>KUN</b> hvis du ved hvad dette betyder. " .
                            "Hvis dette aktiveres vil du ikke modtage <b>NOGEN</b> emails sendt til " .
                            "adresserne linket til denne konto, alt modtaget post, vil blive markeret og rapporteret som værende spam mail og derefter slettet.";

    $lang['help_settings_7'] =  "<b>%s</b> lader dig vælge hvilket sprog Maia skal bruge.";

    $lang['help_settings_8'] =  "<b>%s</b> lader dig vælge hvilket karaktersæt Maia skal bruge.";

    $lang['help_settings_9'] =  "<b>%s</b> lader serveren inspicere alle emails du modtager, og scanner dem for " .
                            "vira, orme, trojanske heste og skadelig software. " .
                            "Hvis du deaktivere denne, vil dine emails ikke blive scannet for vira. " .
                            "De fleste brugere vil ønske at aktivere denne. ";

    $lang['help_settings_10'] =  "<b>%s</b> lader dig vælge om virus inficerede filer skal " .
                             "sættes i karantæne, eller om de skal markeres med et specielt mærke, og " .
                             "leveres til dig alligevel. Hvis du sætter denne til " .
                             "<b>%s</b>, bliver virus inficerede emails placeret i dit karantæne område. " .
                             "Her kan du så redde vigtige informationer fra emailen, (selvom den er virus inficeret). " .
                             "Men i de fleste tilfælde vil man som regel blot slette virus inficerede emails. Vælg " .
                             "denne <b>%s</b> istedet for, så bliver de leveret til dig men med en speciel header " .
                             "i emailen mht til dens virus inficering.";

    $lang['help_settings_11'] =  "<b>%s</b> giver mailserveren mulighed for at prøve at bestemme om denne " .
                             "email er legitim eller spam. Flere forskellige spam-detection " .
                             "mekanikker bliver benyttet, og den overordnede score bliver tildelt " .
                             "hver email, jo højere score, jo størrere chance for at det er spam. Ved at " .
                             "justere på de forskellige score niveauer, kan du bestemme på hvilket " .
                             "niveau en mail skal bestemmes som værende spam, og hvornår den ikke skal " .
                             "leveres til dig. Hvis du gerne vil drage nytte af antispam filtreringen, skal du aktivere dette. " .
                             "Med mindre du hellere vil modtage alle emails ufiltreret.";

    $lang['help_settings_12'] =  "<b>%s</b> lader dig bestemme hvad der sker med emails der er blevet identificeret " .
                             "som værende spam mail. Hvis du vælger <b>%s</b>, vil alle mails der overskrider " .
                             "karantæne max score blive placeret i dit karantæne område, " .
                             "hvor du kan gennemse dem når det passer dig, og redde fejlplacerede emails. " .
			     "Ved at vælge <b>%s</b> istedet for, bliver emailen leveret til dig, dog med en speciel header " .
                             "så du kan checke på denne, og derved sortere disse emails fra.";

    $lang['help_settings_13'] =  "<b>%s</b> vil markere \"Emne:\" linien i enhver mail " .
                             "identificeret som værende spam, med et specielt flag, så du nemmere kan filtrere dem fra i dit mail program.";

    $lang['help_settings_14'] =  "<b>%s >=</b> lader dig specificere minimum scoren en email skal score " .
                             "før den får 'X-Spam:' headeren indsat. Disse headere vil give " .
                             "information omkring scoringen af emailen, bla hvilke regler den har udløst. " .
                             "Det kan være nyttigt når du skal finde ud af hvorfor en specifik email " .
                             "bliver eller ikke bliver markeret som spam mail. Standard værdien " .
                             "er konfigureret af administratoren, og er okay. Hvis du gerne vil se disse headere " .
                             "i <i>alle</i> dine emails, så sæt denne til -999. Omvendt, hvis " .
                             "du slet ikke vil se disse headere sæt denne til en højere score. " .
                             "(Dog ikke højere end <b>%s >=</b> scoren, herunder).";

    $lang['help_settings_15'] =  "<b>%s >=</b> lader dig vælge det score niveau, en email bliver anset som værende spam " .
                             "og markeret med X-Spam headerene. Noter at " .
                             "dette ikke forhinde emailen i at blive leveret til din postkasse, det markere blot emailen " .
                             "således at dit mail program kan sortere dem fra (f.eks. ved at have dit mailprogram lede efter \"X-Spam: Yes\"). Denne værdi " .
                             "bør ikke være højere end <b>%s >=</b> scoren, herunder.";

    $lang['help_settings_16'] =  "<b>%s >=</b> specificere minimum scoren, der er krævet for der bliver gjort " .
                             "noget imod en spammail. Denne værdi skal mindst være ligeså høj som <b>%s >=</b> scoren. " .
                             "Enhver email med en score eller over dette niveau, vil ikke blive leveret til dig. " .
                             "Den bliver istedet for placeret i dit karantæne område, hvor du kan redde " .
                             "den, og godkende afsenderen måske. Hvis du er bange for at få filtreret legitime emails fra, " .
                             "forøg denne score værdi; hvis du stadig modtager for meget spam, sæt denne score til en lavere værdi.";

    $lang['help_settings_17'] =  "<b>%s</b> forsøger at beskytte dig imod farlige filer, som er vedhæftet indkommende emails. " .
                             "Vedhæftede filer, som er eksekverbare filer, er specielt farlige, " .
                             "pga fejl og sårbarheder i populøre email klienter, som f.eks " .
                             "Microsoft Outlook og Outlook Express, nogle af disse filtyper kan " .
                             "eksekvere dig selv når en mail er modtaget. Aktiver denne feature " .
                             "for at få maksimal sikkerhed; deaktiver denne hvis du har problemer med at modtage specifikke filtyper fra legitime afsendere.";

    $lang['help_settings_18'] =  "<b>%s</b> lader dig bestemme hvad der skal ske med mails der indeholder blokerede " .
                             "filvedhæng. Hvis du vælger <b>%s</b>, bliver emailen placeret i dit " .
                             "karantæne område, hvor du kan redde eller slette den senere. " .
                             "Ved at vælge <b>%s</b> istedet for bliver " .
                             "emailen leveret til dig, men med en speciel header, for at advare dig imod " .
                             "denne email, så dit mailprogram kan filtrere den fra hvis du ønsker.";

    $lang['help_settings_19'] =  "<b>%s</b> søger efter ukorrekte email headere. I bund og grund er dette emails der " .
                             "ikke overholder diverse Internet standarder for hvordan en email skal se ud.  Legitime email klienter" .
                             "generere lovlige og hele headere, men det software spammere benytter, laver som regel " .
                             "ikke lovlige headere, og denne feature kan fjerne noget spam som måske slipper igennem andre checks. " .
                             "Der er ikke mange gode grunde til at deaktivere denne feature, men hvis " .
                             "du vil være helt sikker på at du ikke mister legitim email, kan du " .
                             "deaktivere denne feature.";

    $lang['help_settings_20'] =  "<b>%s</b> bestemmer hvad der skal ske med emails med ukorrekte headere. " .
                             "Hvis du vælger <b>%s</b>, bliver disse emails placeret i dit karantæne " .
                             "område, hvor du kan redde eller slette dem. " .
                             "Hvis du vælger <b>%s</b> istedet for bliver disse emails " .
                             "leveret til dig, men med en speciel header så dit mailprogram kan " .
                             "sortere dem fra hvis du ønsker.";

    $lang['help_settings_21'] =  "Du kan ændre dit Maia brugernavn og adgangskode når det passer dig. For at gøre dette, " .
                             "skal du angive <i>begge</i> værdier, også selvom du kun ønsker at ændre en af dem. " .
                             "Hvis du kun ønsker at ændre din adgangskode, skal du stadig " .
                             "angive dit (nuværende) brugernavn i <b>%s</b> feltet. Angiv din " .
                             "nye adgangskode i <b>%s</b> feltet, og igen for at bekræfte det i " .
                             "<b>%s</b> feltet, og til sidst trykke på <b>%s</b> knappen for at gemme ændringerne.";

    $lang['help_settings_22'] =  "<b>%s</b> giver Maia besked på automatisk at tilføje afsenderens email adresse til " .
                             "din liste over godkendte afsendere, når du redder en email fra dig karantæne område. " .
                             "Dette er en nem måde at være sikker på at afsenderen aldrig bliver blokeret igen.";

    $lang['help_settings_23'] =  "<b>%s</b> bestemmer hvor mange emails der skal vises per side i dit " .
                             "karantæne område, og i din ikke-spam mappe. Hvis du har en langsom internet forbindelse " .
                             "bør du sætte denne relativt lavt (f.eks til 20) " .
                             "Hvis du har en hurtig forbindelse, kan det være bedre at sætte den til f.eks 100 eller 500. " .
                             "Derved kan du scanne flere emails på samme tid. Eftersom at du kun kan bekræfte emails på een side af gangen.";

    // Whitelist and Blacklist
    $lang['help_wblist_1'] =  "Din <b>Godkendte liste</b> lader dig specificere at emails fra bestemte afsendere " .
                          "(eller hele domæner) ikke skal spam checkes, og skal leveres uanset indholdet. " .
                          "På denne måde er du sikker på ikke at miste emails fra disse afsendere på noget tidspunkt.";

    $lang['help_wblist_2'] =  "Din <b>Blokeret liste</b> er det modsatte af din Godkendte liste. Den lader dig specificere " .
                          "bestemte afsendere (eller hele domæner) hvis emails blot skal slettes ved modtagelsen. " .
                          "Du vil <i>ALDRIG</i> modtage nogen emails fra disse afsendere under <i>nogen</i> omstændigheder. " .
                          "uanset emailens indhold.";

    $lang['help_wblist_3'] =  "Som standard er dine Godkendte og Blokerede lister begge tomme til at starte med. For at tilføje " .
                          "en adresse til en af listerne, gå til din %s side og indtast adressen (enten som " .
                          "\"bruger@domæne\" form, for en bestemt afsender eller \"@domæne\" eller \"domæne\" for " .
                          "et helt domæne, vælg hvilken liste (%s or %s) og klik på " .
                          "<b>%s</b> knappen. Når du reloader din %s side skulle du gerne se adressen i tabellen.";

    $lang['help_wblist_4'] =  "Når du har en adresse i enten din Godkendte eller Blokerede liste, kan du flytte den " .
                          "imellem de to lister, eller slette den helt, blot ved at flytte prikken ud for adressen og derefter " .
                          "ved at klikke på <b>%s</b> knappen, i bunden af tabellen. " .
                          "Dine ændringer vil være synlige så snart du reloader %s siden.";

    $lang['help_wblist_5'] =  "<b>TIP:</b> Lad være med at tilføj din egen adresse (<b><i>din@emailadresse</i></b>) " .
                          "eller hele dit domæne (<b><i>@domæne</i></b>) til din Godkendte liste.  Spammere " .
                          "benytter ofte falske afsender adresser, og sætter som regel modtager adressen som afsender. " .
                          "Hvis du Godkender din adresse (eller hele dit domæne) vil disse emails ikke " .
                          "blive spam checkket, og leveret til dig.";

    $lang['help_wblist_6'] =  "Det er som regel bedst at starte med en tom Godkendte liste og derefter " .
                          "tilføje adresse når du modtager en \"falskpositiv\" en legitim email " .
                          "som bliver markeret som spam. Når du redder sådan en mail, bliver " .
                          "du spurgt om afsender adressen eller afsender domænet skal på din Godkendte " .
                          "liste.";

    // False Positives
    $lang['help_quarantine_1'] =  "Dit karantæne område, er hvor fanget spam og virus filer bliver gemt, " .
                              "og venter på at du gennemser dem, sammen med blokerede filvedhæng eller mails med ukorrekte " .
                              "mail headere.";

    $lang['help_quarantine_2'] =  "<b>Formodet Spam</b> emails (hvis der er nogen) bliver vist først på siden. " .
                              "Listen med mulig spam bliver sorteret efter scoren hver email får, i faldende ordre " .
                              "således at de emails der er størtst chance for er legitime bliver vist i toppen, " .
                              "og emails i bunden højst sansynligt er spam. Listen indeholder formodet " .
                              "afsender adresse, og emne linien fra hver email. Det gør det let at fange legitime emails. " .
                              "Hvis du derimod ikke er sikker, kan du klikke på emne lniien og se indholdet af emailen, " .
                              "ved brug af <a href=\"%s\">Mail Vieweren</a>.";

    $lang['help_quarantine_9'] =  "Hver række i dit karantæne område, repræsentere een email. I højre " .
                              "kan du se at Maia allerede har gættet at disse emails er spam " .
                              "men hvis hun har lavet en fejl, kan du ændre status på bestemte emails ved vælge " .
                              "<b>[%s]</b> knappen. <b>[%s]</b> knappen lader dig slette emailen uden at bekræfte eller afvise at det er spam. " .
                              "I bunden af siden, kan du bekræfte status på alle emails på samme side, ved at klikke på <b>[%s]</b> knappen.";

    $lang['help_quarantine_3'] =  "<b>Vira/Skadelig software</b> emails (hvis der er nogen) bliver vist efter spam emails. " .
                              "Denne liste bliver sorteret efter dato, og indeholder navnene på de vira som er blevet fundet " .
                              "sammen med den formodet afsender adresse, og emnelinien på emailen. " .
                              "<a href=\"%s\">Mail Vieweren</a> er sikker at bruge hvis du bare vil se tekst indholdet i emailen. " .
                              "Der <i>er</i> " .
                              "en <b>[%s]</b> knap, hvis du virkelig, vorkelig vil have den virus-inficerede " .
                              "email sendt til din postkasse. Brug <b>[%s]</b> knappen med <b>STOR</b> forsigtighed eller slet ikke! " .
                              "Ideelt bør det eneste du bør gøre ved disse emails er at bruge <b>[%s]</b> knappen i bunden af siden.";

    $lang['help_quarantine_4'] =  "<b>Blokerede filvedhæng</b> (hvis der er nogen) bliver listet efter virus emails. " .
                              "Denne liste bliver sorteret efter dato, og inkludere navnene på filvedhængene, som blev " .
                              "fundet i emailen, sammen med den formodet afsender adresse og emne linien i emailen. " .
                              "Du kan bruge <a href=\"%s\">Mail Vieweren</a> ved at klikke på emne linen ved mailen " .
                              "hvis du vil se indholdet af mailen selv. " .
                              "Du kan også bruge <b>[%s]</b> knappen, for at få emailen gensendt til din postkasse, hvis du ønsker. <b>[%s]</b> knappen i bunden " .
                              "tømmer listen for dig, og redder de valgte emails.";

    $lang['help_quarantine_5'] =  "<b>Ukorrekte Mail Headere</b> (hvis der er nogen) bliver vist efter blokerede filvedhæng. " .
                              "Denne liste bliver sorteret efter dato, og indeholder formodet afsender " .
                              "adresse, og emailens emne linie. Du kan bruge " .
                              "<a href=\"%s\">Mail Vieweren</a> ved at klikke på emnelinien ved emailen " .
                              "du ønsker at checke. Du kan også bruge < b>[%s]</b> knappen for at få emailen gensendt til dig. " .
                              "<b>[%s]</b> knappen i bunden vil tømme listen for dig og redde " .
                              "alle de emails du har valgt.";

    $lang['help_quarantine_6'] =  "En lille bemærkning, når du \"bekræfter spam\", sletter du ikke blot emailen, du " .
                              "hjælper til med at blokere for denne email på verdensplan, og hjælper andre med at blokere for spam. " .
                              "Ligeledes hjælper andre dig igennem dette system. Bekræftet spam emails bliver studeret af Maia's " .
                              "lærings computer, og bliver derefter sendt vidre til andre spam-filtrering netværk " .
                              "på internettet. Ligeledes, når du bruger <b>[%s]</b> knappen til at redde " .
                              "en email fra din spam karantæne, hjælper du systemet med at lære hvordan en legitim email ser ud. " .
                              "Derved bliver chancen for at systemet opsnapper lignende emails i fremtiden mindre.";

    $lang['help_quarantine_7'] =  "Du bør cheche dit karantæne område periodisk, for at være sikker på at du ikke har misset " .
                              "vigtige emails, og selvfølgelig også for at rapportere spam, som er blevet opsamlet siden sidste besøg. " .
                              "<b><i>Emails der bliver liggende ubekræftet i %d dage bliver automatisk slettet, og kan ikke tilføjes til lærings computeren.</i></b>, " .
			      " så forsøg venligst at holde dit karantæne område opdateret.";

    $lang['help_quarantine_8'] =  "Hvis du ikke har tid til at bekræfte emails i dit karantæne område, eller " .
                              "at der måske er for mange til at du gider (f.eks at du lige er kommet hjem fra ferie " .
                              "og der venter flere tusinde emails der skal bekræftes m.m) " .
                              ", der kan du bruge <b>[%s]</b> knappen for at slette alle emails i dit karantæne område uden at gøre noget ved dem. " .
                              "Det hjælper selvfølgelig ikke andre Maia brugere, men det er <b>bedre</b> bare at slette dem " .
                              "end at bekræfte dem allesammen som værende spam.";

    // False Negatives
    $lang['help_fn_1'] =  "Mens Maia sætter \"dårlige\" eller \"mulige\" ting, såsom vira, spam, " .
                      "farlige filvedhætninger, og andre ukorrekte email headere, holder hun også en " .
                      "<i>ikke-spam mappe</i> som holder styr på de \"gde\" emails du modtager. " .
                      "Dette gøres af to grunde, for det første, det lader dig \"bekræfte\" legitime emails, " .
                      "så Maia kan lære hvordan legitime emails ser ud, og dernæst det lader dig " .
                      "markere emails som spam hvis de mod forventning skulle være sluppet igennem til din postkasse.";

    $lang['help_fn_2'] =  "Din ikke-spam mappe ligner resten af dit karantæne område, bortset fra guld farven på tabellerne, " .
                      "og at alle emails bliver sorteret i den modsatte orden, de højst scorende emails øverst, da " .
                      "de højst sansynligt er \"falske negativer\" (spam som slipper igennem filtret til din postkasse).";

    $lang['help_fn_3'] =  "Du kan bruge <a href=\"%s\">Mail Vieweren</a> til at se en given email, det fungere på samme måde for hele dit karantæne område. " .
                      "Her har du dog mulighed for at markere en mail, og derefter rapportere den som spam ved at klikke på <b>[%s]</b> " .
                      "linket.";

    $lang['help_fn_6'] =  "Hver række i ikke-spam mappen repræsentere en email. I højre side kan du se at Maia allerede " .
                      "har markeret disse som ikke-spam, men hvis hun har lavet en fejl, kan du ændre status for en mail " .
                      "ved at klikke på <b>[%s]</b> " .
                      "knappen. I bunden af siden, kan du derefter bekræfte status for alle emails på denne side, ved at klikke på <b>[%s]</b> knappen.";

    $lang['help_fn_4'] =  "<b><i>Emails i ikke-spam mappen bliver automatisk slettet efter %d dage</i></b>. Hvis ikke " .
                      "disse emails bliver bekræftet, kan de ikke bruges til at træne Maia's lærings computer.";

    $lang['help_fn_5'] =  "Hvis du ikke har tid, til at bekræfte de emails der er i din ikke-spam mappe, eller der " .
                      "blot er for mange, kan du bruge <b>[%s]</b> knappen for at slette alle emails i din ikke-spam mappe, uden at rapportere dem som spam eller ikke-spam. " .
                      "Det hjælper selvfølgelig ikke Maia med at lære spam fra ikke-spam, men det er bedre " .
                      "at slette dem end blot at \"bekræfte\" emails som uden at kontrollere dem først.";

    $lang['help_mail_viewer_1'] =  "<b>Mail Vieweren</b> lader dig kigge på en email i karantæne. " .
                               "Enten i dens \"rå\" form eller i dens HTML form. Mailen " .
                               "bliver først vist i HTMl format, men du kan klikke på " .
                               "<b>[%s]</b> linket  for at skifte til Rå format, og så på <b>[%s]</b> linket " .
                               "for at returnere til HTML form.";

    $lang['help_mail_viewer_2'] =  "I toppen kan du se en liste over de spam-test regler som blev udløst af denne email, da den blev scannet. " .
                               "Dette hjælper med at forstå hvorfor eller ikke denne blev markeret som spam. " .
                               "Reglerne bliver sorteret i en faldende ordre, efter score " .
                               "således at reglerne med de højeste scoringer er i toppen.";

    $lang['help_mail_viewer_3'] =  "The <b>Mail Vieweren</b> er sikker at bruge, for alle email typer " .
                               "selv mails der indeholder vira, da den kun viser teksten og HTML koden. " .
                               "Andre filvedhæng, bliver noteret men ikke vist. Selv billeder bliver blokeret af Maia " .
                               "da billeder kan indeholde spam eller skadelig software. " .
                               "Hvis et billede bliver blokeret, kan du se " .
                               "\"Image Blocked\" istedet for billedet. Alle links bliver bibeholdt i emailen, så du stadig kan besøge dem hvis du ønsker.";

    $lang['help_mail_viewer_4'] =  "<b>Mail Vieweren</b> giver dig også mulighed, for at rapportere en mail som spam, eller slette den. " .
                               "Du kan også redde den, og få den gensendt til din postkasse. " .
                               "Dette er det samme som at du behandler emails i dit karantæne område, bortset fra at det kun gælder den ene email du har åben lige nu.";

    // Administrator Console
    $lang['help_admin_1'] =  "Administrator Konsollen har sin egen %s.";
    $lang['help_text_adminhelp'] =  "Administrator Hjælpe side";

    // For Further Assistance
    $lang['help_assistance_1'] =  "Hvis alt andet fejler, og dine spørgsmål ikke er blevet besvaret her, kan din " .
                              "lokale mail administrator (%s) formentlig svare på dit spørgsmål.";

    // Credits
    $lang['help_credits_1'] =  "<b><i>%s</i></b> was written by %s, as a web-based mail filtering system " .
                           "based on the %s and %s.  Virus-scanning is performed using %s, %s, and %s.";

?>