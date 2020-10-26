# Installation

This example uses a virtual machines instance setup with vm-tools:

https://github.com/vpenso/vm-tools

The shell script ↴ [`source_me.sh`][0] adds the tool-chain in this repository to 
your shell environment.

## CentOS

### OpenHPC

Install MUNGE, and SLURM from the OpenHPC [opc] repository.

**CentOS 7**

```bash
node=${node:-lxrm01}
vm s ${image:-centos7} ${node:-lxrm01}
# required to install run-time dependencies
vm ex $node -r -- yum -y install epel-release
# install the OpenHPC Yum repository configuration
vm ex $node -r -- \
        rpm -i https://github.com/openhpc/ohpc/releases/download/v1.3.GA/ohpc-release-1.3-1.el7.x86_64.rpm
# install MUNGE, and SLURM
vm ex $node -r -- yum install -y \
        slurm-slurmctld-ohpc slurm-slurmd-ohpc slurm-example-configs-ohpc
```

**CentOS 8**

```bash
node=${node:-lxrm01}
vm s ${image:-centos8} $node
# required to install run-time dependencies
vm ex $node -r -- yum -y install epel-release
vm ex $node -r -- rpm -i \
        http://repos.openhpc.community/OpenHPC/2/CentOS_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm
# install MUNGE, and SLURM
vm ex $node -r -- yum install -y \
        slurm-slurmctld-ohpc slurm-slurmd-ohpc slurm-example-configs-ohpc
```

### Configuration

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
