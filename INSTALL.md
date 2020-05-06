## SLURM Installation

This example uses a virtual machines instance setup with vm-tools:

https://github.com/vpenso/vm-tools

The shell script ↴ [source_me.sh][0] adds the tool-chain in this repository to 
your shell environment.

## Debian

Install SLURM with a minimal configuration on a single node.

File                                 | Description
-------------------------------------|----------------------------------
[.../slurm.conf-debian_localhost][1] | Configuration for slurm{ctl}d on locahost 

```bash
# start a Debian VM instance
vm s debian lxdev01
# install Slurm Debian packages
vm ex lxdev01 -r 'apt install -y munge slurm-wlm slurmctld slurmd'
# copy the slurm.conf
vm sy lxdev01 -r \
        $SLURM_EXAMPLE/etc/slurm/slurm.conf-debian_localhost \
        :/etc/slurm-llnl/slurm.conf
# start the daemons, and check state
vm ex lxdev01 -r '
        systemctl restart slurmctld slurmd
        systemctl status slurmctld slurmd
        sinfo
'
```

## CentOS 7

### Source Build

Prepare a VM with all build dependencies:

```bash
# start a new VM instance
vm s ${image:-centos7} ${node:-lxdev01}
# install compilers, build dependencies, etc.
vm ex $node -r -- yum -y install epel-release
vm ex $node -r -- yum install -y @development \
        bzip2-devel freeipmi-devel glib2-devel gtk2-devel \
        hdf5-devel hwloc-devel libcurl-devel libfastjson-devel \
        libssh2-devel lua-devel lz4-devel man2html \
        mariadb-devel ncurses-devel python3 \
        numactl-devel openmpi openssl-devel pam-devel \
        perl-DBI perl-ExtUtils-MakeMaker perl-Switch \
        readline-devel rdma-core-devel rpm-build \
        rrdtool-devel wget zlib-devel
```

Build MUNGE, and SLURM from source:

```bash
# download MUNGE [msc]
url=https://github.com/dun/munge/releases/download
version=0.5.14
vm ex $node wget $url/munge-${version}/munge-${version}.tar.xz
# build MUNGE
vm ex $node -- rpmbuild -tb --without verify --clean munge-${version}.tar.xz
# install Munge, including development package
vm ex $node -s -- rpm -ivh ~/rpmbuild/RPMS/x86_64/munge\*.rpm
# ...otherwise Slurm will build without MUNGE support
# donwload SLURM [ssc]
url=https://download.schedmd.com/slurm
version=20.02.2
vm ex $node wget $url/slurm-${version}.tar.bz2
# build SLURM
vm ex $node -- rpmbuild -tb --clean slurm-$version.tar.bz2
```

Copy all packages from the VM into a temporary directory on the host:

```bash
vm sy $node ':rpmbuild/RPMS/*/{munge,slurm}*.rpm' $SLURM_EXAMPLE/var/packages/
```

## References

[sag] SLURM Quick Start Administrator Guide  
<https://slurm.schedmd.com/quickstart_admin.html>

[msc] MUNGE Source Code on GitHub  
<https://github.com/dun/munge>  
<https://github.com/dun/munge/wiki/Installation-Guide>

[ssc] SLURM Source Code on GitHub  
<https://www.schedmd.com/downloads.php>

[0]: source_me.sh
[1]: etc/slurm/slurm.conf-debian_localhost
[2]: docs/slurm_daemons.md
