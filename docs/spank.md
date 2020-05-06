# SPANK

> SPANK provides a very generic interface for stackable plug-ins which may be
> used to dynamically modify the job launch code in Slurm. SPANK plugins may be
> built without access to Slurm source code. They need only be compiled against
> Slurm's `spank.h` header file, added to the SPANK config file
> `plugstack.conf`, and they will be loaded at runtime during the next job
> launch. [01]

Run a simple demo SPANK plugin to demonstrate various callback function:

```bash
# install build dependencies
sudo yum install -y @development git
# get the demo source code from GitHub
git clone https://github.com/yqin/slurm-plugins && cd slurm-plugins
# build the SPANK plugin
gcc -shared -fPIC -o spank_demo.so spank_demo.c
# install, configure the SPANK plugin
sudo mkdir /etc/slurm/spank
sudo cp spank_demo.so /etc/slurm/spank/
echo "required /etc/slurm/spank/spank_demo.so" | \
        sudo tee /etc/slurm/plugstack.conf
# see it in action
srun hostname
```

# References

[01] SPANK - Slurm Plug-in Architecture for Node and job (K)control  
<https://slurm.schedmd.com/spank.html>

SPANK Header File  
<https://github.com/SchedMD/slurm/blob/master/slurm/spank.h>

SLURM LUA Job Submit Plugin API  
<https://slurm.schedmd.com/job_submit_plugins.html>  
<https://github.com/stanford-rc/slurm-spank-lua>  
<https://funinit.wordpress.com/2018/06/07/how-to-use-job_submit_lua-with-slurm/>

SLURM Python Job Submit plugin  
<https://github.com/ACRC/slurm-job-submit-python>

SPANK plugins used on LBNL HPCS clusters  
<https://github.com/yqin/slurm-plugins>

X11 SLURM spank plugin enables to export X11 display  
<https://github.com/hautreux/slurm-spank-x11>

SLURM SPANK plugins used at LLNL  
<https://github.com/chaos/slurm-spank-plugins>

Singularity SPANK plugin  
<https://github.com/sylabs/singularity/tree/master/docs/2.x-slurm>  
<https://slurm.schedmd.com/SLUG17/SLUG_Bull_Singularity.pdf>

Pyxis SPANK plugin  
<https://github.com/NVIDIA/pyxis>
