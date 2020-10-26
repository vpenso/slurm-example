# Installation

This example uses a virtual machines instance setup with vm-tools:

https://github.com/vpenso/vm-tools

The shell script ↴ [`source_me.sh`][0] adds the tool-chain in this repository to 
your shell environment.

## Single Node

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

## Cluster

Example `slurm.conf` used in the following example:

Node(s)         | Daemon
----------------|-------------
**lxrm01**      | `slurmctld`
**lxb00[1-4]**  | `slurmd`

```
ClusterName=tester
SlurmUser=slurm
SlurmctldHost=lxrm01
SlurmctldPidFile=/var/run/slurmctld.pid
SlurmctldDebug=3
SlurmctldLogFile=/var/log/slurmctld.log
StateSaveLocation=/var/spool/slurm/ctld
ReturnToService=1
SlurmdPidFile=/var/run/slurmd.pid
SlurmdSpoolDir=/var/spool/slurm/d
SlurmdDebug=3
SlurmdLogFile=/var/log/slurmd.log
AuthType=auth/munge
MpiDefault=none
ProctrackType=proctrack/pgid
SwitchType=switch/none
TaskPlugin=task/affinity
FastSchedule=2 # version prior to 20.04
SchedulerType=sched/builtin
SelectType=select/cons_res
SelectTypeParameters=CR_CPU
JobAcctGatherType=jobacct_gather/none
JobCompType=jobcomp/none
AccountingStorageType=accounting_storage/none
NodeName=lxb00[1-4] Sockets=1 CoresPerSocket=8 ThreadsPerCore=2 State=UNKNOWN
PartitionName=debug Nodes=lxb00[1-4] Default=YES MaxTime=INFINITE State=UP
```

Install the cluster controller on `lxrm01`:

```bash
node=${node:-lxrm01}
vm s ${image:-centos7.8} ${node:-lxrm01}
# required to install run-time dependencies
vm ex $node -r -- yum -y install epel-release
# install the OpenHPC Yum repository configuration
vm ex $node -r -- \
        rpm -i https://github.com/openhpc/ohpc/releases/download/v1.3.GA/ohpc-release-1.3-1.el7.x86_64.rpm
# install MUNGE, and SLURM
vm ex $node -r -- yum install -y \
        nfs-utils \
        slurm-slurmctld-ohpc \
        slurm-slurmd-ohpc \
        slurm-example-configs-ohpc \
        singularity
# upload configuration
vm sy $node -r slurm.conf :/etc/slurm/slurm.conf
# dummy key
vm ex $node -r 'echo 123456789101112131415161718192021222324 > /etc/munge/munge.key'
# adjust the scheduler config
vm lo $node -r -- vi /etc/slurm/slurm.conf
vm ex $node -r -- systemctl restart munge slurmctld slurmd
# disable the firewall
vm ex $node -r -- systemctl disable --now firewalld
# disable SELinux
vm ex $node -r -- setenforce Permissive
# NFS server configuration
exports="/etc/slurm lx*(ro,sync,no_subtree_check)\n/srv lx*(rw,sync,no_subtree_check)"
vm ex $node -r -- "echo -e \"$exports\" > /etc/exports"
# start the NFS server
vm ex $node -r -- '
      systemctl restart nfs-server && \
      exportfs
'
```

Install the execution nodes `lxb00[1-4]`:

```bash
NODES=lxb00[1-2]
vn s ${image:-centos7.8}
vn ex -r -- rpm -i https://github.com/openhpc/ohpc/releases/download/v1.3.GA/ohpc-release-1.3-1.el7.x86_64.rpm
vn ex -r -- yum install -y slurm-slurmd-ohpc singularity nfs-utils
vn ex -r -- mkdir /etc/slurm
vn ex -r -- mount -v -t nfs lxrm01.devops.test:/etc/slurm /etc/slurm
vn ex -r -- mount -v -t nfs lxrm01.devops.test:/srv /srv
# dummy key
vn ex -r 'echo 123456789101112131415161718192021222324 > /etc/munge/munge.key'
vn ex -r -- systemctl restart munge slurmd
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
