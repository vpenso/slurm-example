Following a list of the most relevant configuration files:

File             | Comment
-----------------|-------------------------
slurm.conf       | Configures the resource manager and the job scheduler, define nodes, partitions and policies.
slurmdbd.conf    | Configures the accounting database back-end daemon slurmdbd, which is required for fair-share support.
cgroup.conf      | Configure resource isolation and containment with Linux Cgroups
topology.conf    | Use for network topology aware scheduling by defining the switch hierarchy.
gres.conf        | Configure the attributes of generic resources like GPUs
nhc.conf         | Configures the node _Node Health Check_ system.

_The configuration requires to be the same across the cluster(s)!_

Having mismatching configurations on nodes of the same cluster will lead to 
inconsistent behavior. Typically the configuration is distributed by mounting 
a shared file-system with NFS.

Operating the service daemons `slurmctld` and `slurmd`

```bash
# run daemons in foreground for debugging
slurmctld -Dvvvvv
slurmd -Dvvvv
# show the Systemd service unit
systemctl cat slurmctld.service 
systemctl cat slurmd.service 
# start & enable slurmctld using systemd
systemctl enable --now slurmctld
systemctl enable --now slurmd
```

After altering configuration files use `scontrol` to **reconfigure** the running
service daemons:

```bash
>>> scontrol show config
[…]
>>> scontrol reconfigure
```

### Logs

Typically you want to follow `slurmctld` and `slurmd` log-files:

```bash
# print the path to the logfiles of slurmctld and slurmd
scontrol show config | grep ^Slurm.*dLogFile.*log$
# follow multiple log files...
multitail /var/log/slurm-llnl/*.log
```

