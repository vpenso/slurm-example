# SLURM

Before you continue read [INSTALL.md](INSTALL.md) to deploy a simple SLURM
cluster in a virtual machine.

List of the basic SLURM commands for users:

Command  | Description
---------|---------------------------
sinfo    | Cluster, partitions, nodes, resources overview
salloc   | Allocate resources for an interactive session
sbatch   | Submit a job allocating resources when available
squeue   | Overview of jobs and their states.
scancel  | Cancels (or signals) a running or pending job.

Documentation: 

* Command options `--usage` (brief)
* `--help` (list all options)
* Or the command man-page, i.e. `man sbatch`
* All most all commands support
  -  Option formats: `--partition=debug` (verbose), `-p debug` (single letter)
  -  **Verbose logging** `-v`, increase verbosity `-vvvv`

## Jobs Allocation

Consists of following parts:

1. Request for **Resources** like CPUs, memory, or GPUs. 
2. Job steps described by **Tasks** which launch applications.
3. **Limits** during application execution like run-time 

Physical hardware referred as **consumable resources** allocated to a jobs.

Jobs are **identified by a unique number** call `JOBID`.

### Interactive

Following examples use the (job) script [var/exec/sleep](var/exec/sleep)

```bash
# copy the example to the VM instance
vm sy $node $SLURM_EXAMPLE/var/exec/sleep :
```

`salloc` (interactive, blocking):

* Waits (blocks) the terminal until the requested resources are allocated
* Once resources are available, user can interact and start an executable
* Standard output streams directed to users terminal

```bash
# start an interactive shell on the default resource allocation
vm ex $node salloc /bin/bash
salloc: Granted job allocation 20
# execute an application
devops@lxdev01:~$ ./sleep 10
[2019/04/17T11:48:53] SUBMIT lxdev01.devops.test:/home/devops bash-20
[2019/04/17T11:48:53] START devops@lxdev01.devops.test:/home/devops tester:debug
[2019/04/17T11:48:53] Sleep for 10 seconds
[2019/04/17T11:49:03] EXIT 0
# exiting the shell will releases the resource
devops@lxdev01:~$ exit
exit
salloc: Relinquishing job allocation 20
salloc: Job allocation 20 has been revoked.
# similar launch an application (non-interactive)
devops@lxdev01:~$ salloc ./sleep 10
salloc: Granted job allocation 23
[2019/04/17T11:58:46] SUBMIT lxdev01.devops.test:/home/devops sleep-23
[2019/04/17T11:58:46] START devops@lxdev01.devops.test:/home/devops tester:debug
[2019/04/17T11:58:46] Sleep for 10 seconds
[2019/04/17T11:58:56] EXIT 0
salloc: Relinquishing job allocation 23
salloc: Job allocation 23 has been revoked.
```

### Batch

`sbatch` (non-interactive, non-blocking), aka batch processing:

* SLURM does the job management for the user.
* Users can disconnect from the terminal used to submit the job.
* A (job) **script** is copied to the compute node upon allocation and
  executes under monitoring of SLURM.
* Standard output streams redirected to files.
* The state of a job is monitored with the `squeue` command (cf.
  [docs/squeue.md](docs/squeue.md))

```bash
devops@lxdev01:~$ sbatch ./sleep 10
Submitted batch job 24
devops@lxdev01:~$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                24     debug    sleep   devops  R       0:02      1 localhost
devops@lxdev01:~$ cat 24.log 
[2019/04/17T12:00:46] SUBMIT lxdev01.devops.test:/home/devops sleep-24
[2019/04/17T12:00:46] START devops@lxdev01.devops.test:/home/devops tester:debug
[2019/04/17T12:00:46] Sleep for 10 seconds
[2019/04/17T12:00:56] EXIT 0
```

`scancel` sends signals to job, by default terminate:

```bash
# submit three jobs (sleeping for 2 minutes)
devops@lxdev01:~$ seq 3 | xargs -Ix sbatch ./sleep 120
Submitted batch job 28
Submitted batch job 29
Submitted batch job 30
# check the state
devops@lxdev01:~$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                28     debug    sleep   devops  R       0:26      1 localhost
                29     debug    sleep   devops  R       0:26      1 localhost
                30     debug    sleep   devops  R       0:26      1 localhost
# kill a job
devops@lxdev01:~$ scancel 29
devops@lxdev01:~$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                28     debug    sleep   devops  R       0:48      1 localhost
                30     debug    sleep   devops  R       0:48      1 localhost
```







