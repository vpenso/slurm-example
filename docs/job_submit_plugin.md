## Slurm Job Submit Plugin

Slurm includes a job submit plugin interface [sjbsp] enabling administrators to
implement custom functionality in `/etc/slurm/job_submit.lua`:

```bash
yum install -y lua
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


### References

[sjbsp] Slurm Job Submit Plugin  
<https://github.com/SchedMD/slurm/tree/master/src/lua>  
<https://github.com/SchedMD/slurm/blob/master/src/plugins/job_submit/lua/job_submit_lua.c>  
<https://github.com/SchedMD/slurm/blob/master/contribs/lua/job_submit.lua>

[sjdoc] Slurm Job Submit Plugin Documentation  
<https://slurm.schedmd.com/job_submit_plugins.html>

[htujp] How to use job_submit_lua plugin with Slurm?  
<https://funinit.wordpress.com/2018/06/07/how-to-use-job_submit_lua-with-slurm/>
