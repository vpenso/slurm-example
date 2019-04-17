# SLURM

Read [docs/intro.md](docs/intro.md) for the absolute basics on cluster computing.

Read [INSTALL.md](INSTALL.md) to install & configure a simple SLURM cluster.

User Interface to the SLURM Cluster Controller & Accounting Database

Command  | Description
---------|---------------------------
sinfo    | Provides information on cluster partitions and nodes.
squeue   | Shows an overview of jobs and their states.
scontrol | View Slurm configuration and state, also for un-/suspending jobs.
srun     | Run an executable as a single job (and job step). Blocks until the job is scheduled.
salloc   | Submits an interactive job. Blocks until the job is scheduled, and the prompt appears.
sbatch   | Submits a job script for batch scheduling. Returns immediately with job ID.
scancel  | Cancels (or signals) a running or pending job.
sacct    | Display data for all jobs and job steps in the accounting database 

Documentation: 

* Command options `--usage` (brief)
* `--help` (list all options)
* Or the command man-page 

All most all commands support:

* Option formats: `--partition=debug` (verbose), `-p debug` (single letter)
* **Verbose logging** `-v`, increase verbosity `-vvvv`

## Jobs Allocation

Consists of following parts:

1. Request for **Resources** like CPUs, memory, or GPUs. 
2. Job steps described by **Tasks** which launch applications.
3. **Limits** during application execution like run-time 

Physical hardware referred as **consumable resources** allocated to a jobs.

Jobs are **identified by a unique number** call `JOBID`.

Following examples use the script [var/exec/sleep](var/exec/sleep) as example.

`salloc` (interactive, blocking):

* Waits (blocks) the shell until requested resources are allocated
* Standard output directed to the interactive shell

```bash
# start an interactive shell on the default resource allocation
devops@lxdev01:~$ salloc /bin/bash
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

`sbatch` (non-interactive, non-blocking), aka batch processing:

* SLURM does the job management for the user.
* User can disconnect from the terminal session used to submit the job.
* A (job) **script** is copied to the compute node upon allocation and
  executes under monitoring of SLURM.
* Standard output streams redirected to files.
* Progress of jobs can be queried from SLURM with the `squeue` command

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





