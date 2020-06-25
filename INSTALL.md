# Installation

This example uses a virtual machines instance setup with vm-tools:

https://github.com/vpenso/vm-tools

The shell script ↴ [`source_me.sh`][0] adds the tool-chain in this repository to 
your shell environment.


## CentOS

### Source Build

Prepare a VM with all build **dependencies**:

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

**Build** MUNGE, and SLURM from source:

```bash
# download MUNGE [msc]
url=https://github.com/dun/munge/releases/download
version=${version:-0.5.14}
vm ex $node wget $url/munge-${version}/munge-${version}.tar.xz
# build MUNGE
vm ex $node -- rpmbuild -tb --without verify --clean munge-${version}.tar.xz
# install Munge, including development package
vm ex $node -s -- rpm -ivh ~/rpmbuild/RPMS/x86_64/munge\*.rpm
# ...otherwise Slurm will build without MUNGE support
# donwload SLURM [ssc]
url=https://download.schedmd.com/slurm
version=${version:-20.02.2}
vm ex $node wget $url/slurm-${version}.tar.bz2
# build SLURM
vm ex $node -- rpmbuild -tb --clean slurm-$version.tar.bz2
# copy all packages from the VM into a temporary directory on the host:
vm sy $node ':rpmbuild/RPMS/*/{munge,slurm}*.rpm' $SLURM_EXAMPLE/var/packages/
```

**Install** the packages build above in a VM instance:

```bash
vm s ${image:-centos7} ${node:-lxrm01}
# required to install run-time dependencies
vm ex $node -r -- yum -y install epel-release
# upload the MUNGE, and SLURM packages
vm sy $node $SLURM_EXAMPLE/var/packages/*.rpm :/tmp/
# ...install
vm ex $node -r -- yum localinstall -y '/tmp/{munge,slurm}*.rpm'
```

### OpenHPC

Install MUNGE, and SLURM from the OpenHPC [opc] repository.

**CentOS 7.7**

```bash
node=${node:-lxrm01}
vm s ${image:-centos7.7} ${node:-lxrm01}
# required to install run-time dependencies
vm ex $node -r -- yum -y install epel-release
# install the OpenHPC Yum repository configuration
vm ex $node -r -- \
        rpm -i https://github.com/openhpc/ohpc/releases/download/v1.3.GA/ohpc-release-1.3-1.el7.x86_64.rpm
# install MUNGE, and SLURM
vm ex $node -r -- yum install -y \
        slurm-slurmctld-ohpc slurm-slurmd-ohpc slurm-example-configs-ohpc
```

**CentOS 8.1**

```bash
node=${node:-lxrm01}
vm s ${image:-centos8.1} $node
# required to install run-time dependencies
vm ex $node -r -- yum -y install epel-release
vm ex $node -r -- rpm -i \
        http://repos.openhpc.community/OpenHPC/2/CentOS_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm
# install MUNGE, and SLURM
vm ex $node -r -- yum install -y \
        slurm-slurmctld-ohpc slurm-slurmd-ohpc slurm-example-configs-ohpc
```

## Configuration

Upload the example configuration from this repository to
`/etc/slurm/slurm.conf`:

```bash
# upload a SLURM configuration file
conf=$SLURM_EXAMPLE/etc/slurm/slurm.conf-centos_localhost
vm sy $node -r $conf :/etc/slurm/slurm.conf
```

**Depending on the version** of Slurm it may be necessary to adjust the
configuration by selecting one of these parameters:

```bash
FastSchedule=2                       # version prior to 20.04
# or
SlurmdParameters=config_overrides
```

Edit the `slurm.conf` with the following command:

```bash
# start the Vi editor
vm lo lxrm01 -r -- vi /etc/slurm/slurm.conf
```

Afterwards start `slurmctld` to load the configuration change

```bash
# restart the services
vm ex $node -r -- systemctl enable --now munge
vm ex $node -r systemctl restart slurmctld slurmd
```

## Debian

**Install** SLURM from the Debian package repository:

```bash
# start a Debian VM instance
vm s ${image:-debian10} ${node:-lxrm01}
# install Slurm Debian packages
vm ex $node -r -- apt install -y munge slurm-wlm slurmctld slurmd
```

**Configure** a minimal configuration for a single node:

```bash
# upload a SLURM configuration file
conf=$SLURM_EXAMPLE/etc/slurm/slurm.conf-debian_localhost
vm sy $node -r $conf :/etc/slurm/slurm.conf
# start the daemons, and check state
vm ex $node -r systemctl restart slurmctld slurmd
```


# References

[sag] SLURM Quick Start Administrator Guide  
<https://slurm.schedmd.com/quickstart_admin.html>

[msc] MUNGE Source Code on GitHub  
<https://github.com/dun/munge>  
<https://github.com/dun/munge/wiki/Installation-Guide>

[ssc] SLURM Source Code on GitHub  
<https://www.schedmd.com/downloads.php>

[opc] OpenHPC Source code on GitHub  
<https://github.com/openhpc/ohpc/>  
<https://github.com/openhpc/ohpc/releases>  
<http://build.openhpc.community/dist/>

[0]: source_me.sh
[1]: etc/slurm/slurm.conf-debian_localhost
[2]: docs/slurm_daemons.md
