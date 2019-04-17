## SLURM Installation

This example uses a virtual machines instance setup with vm-tools:

https://github.com/vpenso/vm-tools

The shell script ↴ [source_me.sh][0] adds the tool-chain in this repository to 
your shell environment.

### Single Node

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

### Multi Node Cluster

Find a comprehensive example on building a SLURM cluster with OpenHPC and
SaltStack at with a set of virtual machine instances:

https://github.com/vpenso/saltstack-slurm-example


## References

SLURM Quick Start Administrator Guide  
https://slurm.schedmd.com/quickstart_admin.html


[0]: source_me.sh
[1]: etc/slurm/slurm.conf-debian_localhost
[2]: docs/slurm_daemons.md
