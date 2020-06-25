# SPANK

> SPANK provides a very generic interface for stackable plug-ins which may be
> used to dynamically modify the job launch code in Slurm. SPANK plugins may be
> built without access to Slurm source code. They need only be compiled against
> Slurm's `spank.h` header file, added to the SPANK config file
> `plugstack.conf`, and they will be loaded at runtime during the next job
> launch. [01]


```bash
# support the co-existence of mutliple SPANK plugins
sudo mkdir /etc/slurm/plugstack.conf.d
echo 'include /etc/slurm/plugstack.conf.d/*.conf' |\
        sudo tee /etc/slurm/plugstack.conf
```

Run a [simple demo][demo] [02] SPANK plugin to demonstrate various callback
function:

[demo]: https://github.com/yqin/slurm-plugins/blob/master/spank_demo.c

```bash
# install build dependencies
sudo yum install -y @development git slurm-devel-ohpc
# get the demo source code from GitHub
git clone https://github.com/yqin/slurm-plugins && cd slurm-plugins
# build the SPANK plugin
gcc -shared -fPIC -o spank_demo.so spank_demo.c
# install, configure the SPANK plugin
sudo mkdir /etc/slurm/spank
sudo cp spank_demo.so /etc/slurm/spank/
echo "required /etc/slurm/spank/spank_demo.so" | \
        sudo tee /etc/slurm/plugstack.conf.d/spank_demo.conf
# see it in action
srun hostname
```

# References

[01] SPANK - Slurm Plug-in Architecture for Node and job (K)control  
<https://slurm.schedmd.com/spank.html>

[02] SPANK plugins used on LBNL HPCS clusters  
<https://github.com/yqin/slurm-plugins>

SPANK Header File  
<https://github.com/SchedMD/slurm/blob/master/slurm/spank.h>

Lua SPANK plugin enables support of Lua job submit plugins  
<https://slurm.schedmd.com/job_submit_plugins.html>  
<https://github.com/stanford-rc/slurm-spank-lua>  
<https://funinit.wordpress.com/2018/06/07/how-to-use-job_submit_lua-with-slurm/>

Python SPANK plugin enables support of Python job submit plugins  
<https://github.com/ACRC/slurm-job-submit-python>

X11 SPANK plugin enables to export X11 display  
<https://github.com/hautreux/slurm-spank-x11>

SLURM SPANK plugins used at LLNL  
<https://github.com/chaos/slurm-spank-plugins>

Singularity SPANK plugin  
<https://github.com/sylabs/singularity/tree/master/docs/2.x-slurm>  
<https://slurm.schedmd.com/SLUG17/SLUG_Bull_Singularity.pdf>

Pyxis SPANK plugin  
<https://github.com/NVIDIA/pyxis>
