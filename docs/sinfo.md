## sinfo

View information about Slurm nodes and partitions.

```bash
sinfo -s                 # partition state summary
sinfo -N                 # node-oriented format
sinfo -Nl                # node-oriented format, more detailed information
```

Options `-o <format>` customizes the output.

Overview available **resources** and **capacities**:

```bash
# resources available to partitions
sinfo -o "%9P  %6g %11L %10l %5D %20C"
# resource and features
sinfo -o "%4c %7z %8m %25f %N"
# run-time constrains and partition sizes
sinfo -o "%9P  %6g %10l %5w %5D %13C %N"
# resource and run-time configurations
sinfo -o "%5D %10l %7z %4c %8m %10f %P"
```

List nodes in a defective state:

```bash
# defect nodes in partition
sinfo -R -p $partition
# defect nodes by numbers
sinfo -o '%10T %5D %E' -S 'E' -t drain,draining,drained,down
# defect nodes by reaseon
sinfo -o '%10T %7u %12n %E' -S 'E' -t drain,draining,drained,down
```
