# SPANK

> SPANK provides a very generic interface for stackable plug-ins which may be
> used to dynamically modify the job launch code in Slurm. SPANK plugins may be
> built without access to Slurm source code. They need only be compiled against
> Slurm's `spank.h` header file [spkhf] , added to the SPANK config file
> `plugstack.conf`, and they will be loaded at runtime during the next job
> launch. [spank]


```bash
# support the co-existence of mutliple SPANK plugins
sudo mkdir /etc/slurm/plugstack.conf.d
echo 'include /etc/slurm/plugstack.conf.d/*.conf' |\
        sudo tee /etc/slurm/plugstack.conf
```

Run the [`simple_demo.c`][demo] [splhc] SPANK plugin to demonstrate various
callback function:

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

## Lua Plugin

```bash
yum install -y lua-devel
# enable the Lua plugin in the SLURM configuration
echo 'JobSubmitPlugins=lua' >> /etc/slurm/slurm.conf
# simple Lua script example
cat > /etc/slurm/job_submit.lua <<EOF
function slurm_job_submit(job_desc, part_list, submit_uid)
        if job_desc.account == nil then
                slurm.log_user("You have to specify account. Usage of default accounts is forbidden.")
                return slurm.ESLURM_INVALID_ACCOUNT
        end
end
function slurm_job_modify(job_desc, job_rec, part_list, modify_uid)
    return slurm.SUCCESS
end
return slurm.SUCCESS
EOF
# load the new configuration
systemctl restart slurmctld
```

Run a command to verify that the plugin works:

```bash
>>> srun hostname
srun: error: You must specify an account!
srun: error: Unable to allocate resources: Unspecified error
```

Build the RPM package [splua]:

```bash
# install the build dependencies
sudo yum install -y @development wget lua-devel slurm-devel-ohpc
# NOTE: we can not check for dependencies since we use slurm-devel-ohpc
# download the source code
version=0.39
wget https://github.com/stanford-rc/slurm-spank-lua/archive/v$version.tar.gz \
  -O slurm-spank-lua-$version.tar.gz
# build the RPM package
rpmbuild --nodeps -ta slurm-spank-lua-0.39.tar.gz
# install run-time dependencies
yum install -y lua-posix
# install the RPM package
rpm --nodeps -i ~/rpmbuild/RPMS/x86_64/slurm-spank-lua-0.39-1.x86_64.rpm
# list file in package
rpm -ql slurm-spank-lua
# enable the demo plugins
cp /etc/slurm/lua.d/disabled/spank_demo.lua /etc/slurm/lua.d
# restart to load the new configuration
systemctl restart slurmctld
```

Run a command to verify that the plugin works:

```bash
>>> srun hostname
srun: spank_demo: ctx:local host:lxrm01 caller:slurm_spank_init uid:root gid:root
srun: spank_demo: ctx:local host:lxrm01 caller:slurm_spank_init_post_opt uid:root gid:root
srun: spank_demo: ctx:local host:lxrm01 caller:slurm_spank_local_user_init uid:root gid:root
lxrm01
srun: spank_demo: ctx:local host:lxrm01 caller:slurm_spank_exit uid:root gid:root
```





## References

[spank] SPANK - Slurm Plug-in Architecture for Node and job (K)control  
<https://slurm.schedmd.com/spank.html>

[splhc] SPANK plugins used on LBNL HPCS clusters  
<https://github.com/yqin/slurm-plugins>

[spkhf] SPANK Header File  
<https://github.com/SchedMD/slurm/blob/master/slurm/spank.h>

[splua] Lua SPANK plugin enables support of Lua job submit plugins  
<https://slurm.schedmd.com/job_submit_plugins.html>  
<https://github.com/stanford-rc/slurm-spank-lua>  
<https://funinit.wordpress.com/2018/06/07/how-to-use-job_submit_lua-with-slurm/>

[sppyh] Python SPANK plugin enables support of Python job submit plugins  
<https://github.com/ACRC/slurm-job-submit-python>

[spx11] X11 SPANK plugin enables to export X11 display  
<https://github.com/hautreux/slurm-spank-x11>

[spx11] SLURM SPANK plugins used at LLNL  
<https://github.com/chaos/slurm-spank-plugins>

[spsng] Singularity SPANK plugin  
<https://github.com/sylabs/singularity/tree/master/docs/2.x-slurm>  
<https://slurm.schedmd.com/SLUG17/SLUG_Bull_Singularity.pdf>

[sppyx] Pyxis SPANK plugin  
<https://github.com/NVIDIA/pyxis>
