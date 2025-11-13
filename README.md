Update 11/11/2025 -

Since fixing the missing crypt support, we have not seen any errors when releasing a message
marked as spam, or reporting a message marked as ham, from the digest email.

With that, we're going to do a 1.0 release

Maia Mailguard 1.0.5 has been confirmed working on the following platforms:

* Alma Linux 9,10
* Centos 10
* Debian 11,12,13
* Fedora 42
* FreeBSD 14.3 and 15.0-STABLE
* RHEL 9,10
* Rocky Linux 9,10
* Ubuntu 24.04


![maia login page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_login.png "maia login page")

![maia welcome page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_welcome.png "maia welcome page")

![maia help page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_help.png "maia help page")

![maia stats page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_stats.png "maia stats page")

![maia wblist page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_wblist.png "maia wblist page")

![maia settings page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_settings.png "maia settings page")

![maia languages page](https://github.com/einheit/maia-screenshots/blob/master/maia_105_languages.png "maia languages page")

---

This repo was forked from the the technion/maia_mailguard repo

The branch retains the goals of maia_mailguard_1.04a but adds compatibility with php 8.

Compatibility with php 7 was tested and confirmed working with Debian 11.

Maia is flexible and scalable. It can be deployed in a number of configurations - everything in a single container, VM or physical machine, or dividing it up into MTAs, maiad/spamassasin servers, clamav servers, database servers, and web servers.

To get started, run "./install" and the script will try to detect the OS and offer the best option for installing on your system. 

The install scripts are simple-minded sequences of shell commands which save time and effort, and they work fairly well. The installer could fail to detect a supported OS, which, in and of itself is not a show stopper, as the install scripts are merely a convenience. It's safe to say that some or all maia components should be able to run on any Unix-like OS.

Contributed scripts for additional distros/platforms are welcome.


-- 

The README from the original technion fork is below:

The original license has been replaced with a GPL license with the blessing of the project's original creator. See license.txt for further information.

This fork brings the project in line with current deployments and technology, such as newer versions of PHP.

Some features are known to be untested and probably broken, such as authentication mechanisms other than "internal".

There are some new requirements on PHP modules, these are easiest identified by running the standard configtest.php.

I would greatly appreciate an updated installation guide for this fork, if anyone wanted to contribute.

# maia_mailguard_1.05
