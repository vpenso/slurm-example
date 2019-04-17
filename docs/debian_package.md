
List available versions for each Debian release:

```bash
>>> date && rmadison slurm-wlm
Fri 12 Apr 2019 10:16:20 AM CEST
slurm-wlm  | 14.03.9-5+deb8u2 | oldstable  | amd64, armel, armhf, i386
slurm-wlm  | 16.05.9-1+deb9u2 | stable     | amd64, arm64, armel, armhf, i386, mips, mips64el, mipsel, ppc64el, s390x
slurm-wlm  | 18.08.5.2-1      | testing    | amd64, arm64, armel, armhf, i386, mips, mips64el, mipsel, ppc64el, s390x
slurm-wlm  | 18.08.6.2-1      | unstable   | amd64, arm64, armel, armhf, i386, mips, mips64el, mipsel, ppc64el, s390x
```

## Packages

Debian [slurm-llnl][deb] source package:

[deb]: https://packages.debian.org/source/slurm-llnl

```bash
# download the source package (as a non root user)
>>> apt-get source slurm-llnl
# it will be extracted in the current working directory
>>> ls slurm*
slurm-llnl_18.08.5.2-1.debian.tar.xz  slurm-llnl_18.08.5.2-1.dsc  slurm-llnl_18.08.5.2.orig.tar.gz

slurm-llnl-18.08.5.2:
aclocal.m4  auxdir       configure.ac     COPYING     doc      LICENSE.OpenSSL  META        RELEASE_NOTES  src
AUTHORS     config.h.in  contribs         debian      etc      Makefile.am      NEWS        slurm          testsuite
autogen.sh  configure    CONTRIBUTING.md  DISCLAIMER  INSTALL  Makefile.in      README.rst  slurm.spec
```

Debian package build configuration:

```
>>> ls slurm-llnl*/debian
# list the binary packages build from this source package
>>> grep ^Package slurm-llnl*/debian/control
Package: slurm-wlm
Package: slurm-client
Package: slurmd
Package: slurmctld
Package: libslurmdb33
Package: libslurm33
Package: libpmi0
Package: libpmi2-0
Package: libslurm-dev
Package: libslurmdb-dev
Package: libpmi0-dev
Package: libpmi2-0-dev
Package: slurm-wlm-doc
Package: slurm-wlm-basic-plugins
Package: slurm-wlm-basic-plugins-dev
Package: sview
Package: slurmdbd
Package: libslurm-perl
Package: libslurmdb-perl
Package: slurm-wlm-torque
Package: libpam-slurm
Package: slurm-wlm-emulator
Package: slurm-client-emulator
```

Proximity of SLURM upstream releases to the release of a Debian package to testing:

```bash
>>> zcat /usr/share/doc/slurm-wlm/changelog.Debian.gz \
        | grep -e ^slurm -e ' -- ' | paste - - \
        | cut -d' ' -f1,2,11-13 | head -n 15
slurm-llnl (18.08.5.2-1) 17 Feb 2019
slurm-llnl (18.08.3-1) 24 Oct 2018
slurm-llnl (18.08.2-1) 23 Oct 2018
slurm-llnl (18.08.1-1) 08 Oct 2018
slurm-llnl (17.11.9-1) 10 Aug 2018
slurm-llnl (17.11.8-1) 27 Jul 2018
slurm-llnl (17.11.7-1) 06 Jun 2018
slurm-llnl (17.11.6-1) 22 May 2018
slurm-llnl (17.11.5-1) 17 Mar 2018
slurm-llnl (17.11.2-1) 14 Jan 2018
slurm-llnl (17.02.9-1) 05 Nov 2017
slurm-llnl (17.02.7-1) 07 Oct 2017
slurm-llnl (17.02.5-1) 03 Jul 2017
slurm-llnl (17.02.1.2-1) 08 Mar 2017
slurm-llnl (16.05.9-1) 03 Feb 2017
# download the Slrum source code from Github
>>> git clone https://github.com/SchedMD/slurm.git /usr/src/slurm \
        && cd /usr/src/slurm/
# list the repository tags with date
>>> git log --tags --simplify-by-decoration --pretty="format:%ci %d" \
        | grep tag | head -n15
2019-04-11 22:19:19 -0600  (tag: slurm-18-08-7-1)
2019-03-07 15:58:34 -0700  (tag: slurm-19-05-0-0pre3)
2019-03-07 15:47:40 -0700  (tag: slurm-18-08-6-2)
2019-03-07 14:12:38 -0700  (tag: slurm-19-05-0-0pre2)
2019-03-07 14:08:52 -0700  (tag: slurm-18-08-6-1)
2019-01-31 11:07:22 -0700  (tag: slurm-18-08-5-2)
2019-01-31 11:02:01 -0700  (tag: slurm-17-11-13-2)
2019-01-30 11:58:11 -0700  (tag: slurm-18-08-5-1)
2019-01-30 11:51:56 -0700  (tag: slurm-17-11-13-1)
2018-12-11 15:44:36 -0700  (tag: slurm-18-08-4-1)
2018-10-24 14:20:29 -0600  (tag: slurm-18-08-3-1)
2018-10-24 14:16:10 -0600  (tag: slurm-17-11-12-1)
2018-10-18 15:14:46 -0600  (tag: slurm-19-05-0-0pre1)
2018-10-18 15:12:13 -0600  (tag: slurm-18-08-2-1)
2018-10-18 15:02:48 -0600  (tag: slurm-17-11-11-1)
```

## Installation

```bash
# install requiered binary package
apt install -y slurm-wlm
# list the installed packages
dpkg -l | grep slurm
# list files included with all packages
dpkg -l | grep slurm | cut -d' ' -f3 | xargs dpkg -L | sort | uniq | less
```

### Configuration

Paths to configuration file specific do Debian:

```bash
# default configuration file 
/etc/slurm-llnl/slurm.conf
# options passed to daemons on start
/etc/default/slurmctld
/etc/default/slurmd
```

Debian use following file paths for run-time information:

```bash
>>> egrep 'File|Dir|Location' /etc/slurm-llnl/slurm.conf | grep -v ^#
SlurmctldPidFile=/run/slurmctld.pid
SlurmctldLogFile=/var/log/slurm-llnl/slurmctld.log
StateSaveLocation=/var/lib/slurm-llnl/slurmctld
SlurmdPidFile=/run/slurmd.pid
SlurmdSpoolDir=/var/lib/slurm-llnl/slurmd
SlurmdLogFile=/var/log/slurm-llnl/slurmd.log
```
