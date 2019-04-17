
# Cluster Computer

**Tightly connected computes integrated into a single system**

- Each node runs its own instance of an operating system (OS)
- Nodes have **no local storage** for application data 
- Nodes are connected by a **fast network interconnect**
- Nodes share a **common data storage** over the network 

Predominant architecture of "Supercomputers" ➤ [TOP500](http://top500.org/)

- Primarily designed for **high performance** and **scalability**
- More and more **emphasis on parallel software** for efficient utilization 
- Application **scheduling** controlled by a **resource management system**

Interconnect **bandwidth and latency** essential to enable this architecture

- **Fault tolerance** of hardware and software increasingly important
- TCO heavily influenced by **power, cooling and maintenance cost**

## Terminology

Compute **Node**

> Single machine used to execute user applications.

Compute **Cluster**

> Compute nodes integrated into a single logic unit by a workload management
(aka resource management) system. This system accepts work requests as "jobs"
from users, and puts these jobs into a pending area "queue".

Compute **Job** 

> A job is an action the user wishes to be performed on the cluster resources. 
Could be an executable file "application", a set of commands, or a script.

Cluster **Queue**

> As soon as resources become available a "matching" job from the queue is 
selected and send to the node(s).

## SLURM

SLURM: **S**imple **L**inux **U**tility for **R**esource **M**anagement

- **Widely used**, runs on about 60% of supercomputers listed in TOP500
- **Open Source** GPLv2, &gt;100 contributors, very active community
- **Highly scalable**, thousands of nodes with millions of CPU cores

Three key functions:

- Provides a **users interface** to execute and monitor applications
- Monitors resource state and provides **isolation and access control**
- **Allocates resources** to jobs from a queue according to shares and resource
  availability

SLURM **Cluster Controller**

> Central entity interfacing the cluster to users and operators, runs the job 
scheduler (workload manager) and handles all communication within the cluster.

SLURM **Accounting Database**

> Records all activity on the cluster, in particular resource consumption.

# References

Computer Cluster, Wikipedia  
https://en.wikipedia.org/wiki/Computer_cluster

SLURM Quick Start User Guide  
https://slurm.schedmd.com/quickstart.html
