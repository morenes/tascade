#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Error: Missing required parameters."
    exit 1
fi

if [ $1 -gt 8 ]; then
  apps="0 2 3 4 5"
else
  apps=$1
fi

datasets="Kron26"

verbose=1
assert=0
exp="SCALINGB"

let noc_conf=1
let dcache=1

let grid_w=32
let chiplet_w=32
let proxy_w=16



local_run=0
prefix="-v $verbose -r $assert -u $noc_conf -c $chiplet_w -y $dcache -s $local_run"


i=0
declare -A options
declare -A strings

####### START EXPERIMENT #######
#0 - 32
let th=$grid_w/2
strings[$i]="000 Min size"
options[$i]="-n ${exp} -e $proxy_w -m $grid_w -t $th $prefix"
let i=$i+1


#1 - 64
let grid_w=$grid_w*2
let th=$grid_w/2
strings[$i]="111 Min size"
options[$i]="-n ${exp} -e $proxy_w -m $grid_w -t $th $prefix"
let i=$i+1

#2 - 128
let grid_w=$grid_w*2
let th=$grid_w/2
strings[$i]="222 Scaling step"
options[$i]="-n ${exp} -e $proxy_w -m $grid_w -t $th $prefix"
let i=$i+1


# De-activate the cache for more than 128x128 (Kron26)
dcache=0
prefix="-v $verbose -r $assert -u $noc_conf -c $chiplet_w -y $dcache -s $local_run"

#3 - 256
let grid_w=$grid_w*2
strings[$i]="333 Scaling step"
options[$i]="-n ${exp} -e $proxy_w -m $grid_w -t $th $prefix"
let i=$i+1


# Big cases OOM!
let proxy_w=32
#4 - 512
let grid_w=$grid_w*2
strings[$i]="444 Scaling step"
options[$i]="-n ${exp} -e $proxy_w -m $grid_w -t $th $prefix"
let i=$i+1

let th=64
#5: 1024
let proxy_w=32
let grid_w=$grid_w*2
strings[$i]="666 Scaling step"
options[$i]="-n ${exp} -e $proxy_w -m $grid_w -t $th $prefix"
let i=$i+1



for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
