![maia configtest page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_configtest.png "maia configtest page")

![maia login page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_login.png "maia login page")

![maia welcome page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_welcome.png "maia welcome page")

![maia help page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_help.png "maia help page")

![maia stats page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_stats.png "maia stats page")

![maia wblist page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_wblist.png "maia wblist page")

![maia settings page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_settings.png "maia settings page")

![maia languages page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_languages.png "maia languages page")

NOTE - as of Sept 12th, 2025, this is a work in progress. We've just begun the tedious process of replacing the obsolete PEAR::MDB2 libraries with the php native PDO. 

This repo was forked from the the technion/maia_mailguard repo

The branch retains the goals of maia_mailguard_1.04a but adds compatibility with php 8.

Compatibility with php 7 and below is unknown at this point, but for that use case, maia_mailguard 1.04a is perfectly usable. 

Maia is flexible and scalable. It can be deployed in a number of configurations, from deploying everything in a single container, VM or physical machine, to groups of of MTAs, groups of maiad/spamassasin servers, remote clamav servers, remote database servers, or dedicated web server instances for the management interface.

To get started, run "./install" and the script will try to detect the OS and offer the best option for installing on your system. 

The install scripts are perhaps something of a kludge, but they save time and they work fairly well. The installer could fail to detect a supported OS, which, in and of itself is not a show stopper, as the install scripts are merely a convenience. It's safe to say that some or all maia components should be able to run on any Unix-like OS.

Contributed scripts for additional distros/platforms are welcome.


-- 

The README from the original technion fork is below:

The original license has been replaced with a GPL license with the blessing of the project's original creator. See license.txt for further information.

This fork brings the project in line with current deployments and technology, such as newer versions of PHP.

Some features are known to be untested and probably broken, such as authentication mechanisms other than "internal".

There are some new requirements on PHP modules, these are easiest identified by running the standard configtest.php.

I would greatly appreciate an updated installation guide for this fork, if anyone wanted to contribute.

# maia_mailguard_1.05
