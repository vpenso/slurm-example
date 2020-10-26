# Source Build

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
