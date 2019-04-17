List jobs in the scheduler queue with `squeue`:

```bash
# job from your user ID
squeue -u $USER
# set the default user ID for the squeue command
export SQUEUE_USERS=$USER
```

Jobs listed in order of **estimated start time**:

```bash
>>> squeue --start
```

_Why the job has not started yet?_ 

Reason      | Description 
------------|-------------
Resources   | Required resources are in use
Priority    | Resources being reserved for higher priority job
Dependency  | Job dependencies not yet satisfied
Reservation | Waiting for advanced reservation 


### States

State     | A. | Description 
----------|----|-------------
pending   | PD | Job is awaiting resource allocation
running   | R  | Job currently has an allocation
timeout   | TO | Job terminated upon reaching its time limit
canceled  | CA | Job canceled by the user or  system administrator
failed    | F  | Job terminated with non-zero exit code
completed | CD | Job has terminated all processes on all nodes

Option `--states` limits the list to jobs in a certain state.

```bash
squeue \
    --states running \
    --format '%20S %11M %9P %8u %6g %10T %11l' \
    | sort -k 1 \
    | uniq -f 2 -c \
    | tac
```

