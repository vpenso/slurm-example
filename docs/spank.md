
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

SLURM plugins used on LBNL HPCS clusters  
<https://github.com/yqin/slurm-plugins>

X11 SLURM spank plugin enables to export X11 display  
<https://github.com/hautreux/slurm-spank-x11>
