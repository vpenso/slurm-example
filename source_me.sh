# Find the correct path even if dereferenced by a link
__source=$0
__dir="$( dirname $__source )"
while [ -h $__source ]
do
  __source="$( readlink "$__source" )"
  [[ $__source != /* ]] && __source="$__dir/$__source"
  __dir="$( cd -P "$( dirname "$__source" )" && pwd )"
done
__dir="$( cd -P "$( dirname "$__source" )" && pwd )"

export SLURM_EXAMPLE=$__dir
unset __dir
unset __source

#export PATH=$SLURM_EXAMPLE/bin:/usr/sbin:$PATH
#PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')

#for file in `\ls $SLURM_EXAMPLE/var/aliases/*.sh`
#do 
#  source $file
#done
