#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Error: Missing required parameters."
    return 1
fi

if [ $1 -gt 5 ]; then
  apps="0 1 2 3 4 5"
else
  apps=$1
fi

if [ -z "$4" ]; then
  echo "Default grid_w=64"
  let grid_w=64
else
  let grid_w=$4
  echo "grid_w=$grid_w"
fi
if [ -z "$5" ]; then
  echo "All datasets by default"
  datasets="Kron22 wikipedia"
else
  echo "Dataset $5"
  datasets="$5"
fi

declare -A options
declare -A strings

th=32
verbose=1
assert=0
iter="SYNCUP"

i=0

local_run=0

let noc_conf=1
let dcache=0
let ruche=0
let torus=1

let chiplet_w=$grid_w
let board_w=$grid_w #Specify board so that the package has the same size as the board

sufix="-v $verbose -r $assert -t $th -u $noc_conf -m $grid_w -c $chiplet_w -k $board_w -l $ruche -o $torus -y $dcache -s $local_run"

let proxy_w=16
let write_thru=0

#Set Stronger barrier for cache drain!
barrier=2

#C0 means Proxy Sync Never Cascading
let proxy_routing=3
strings[$i]="${iter}0"
options[$i]="-n ${strings[$i]} -e $proxy_w -z $proxy_routing -j $write_thru -b $barrier $sufix"
let i=$i+1

#C1 means Proxy Sync Always Cascading
let proxy_routing=5
strings[$i]="${iter}1"
options[$i]="-n ${strings[$i]} -e $proxy_w -z $proxy_routing -j $write_thru -b $barrier $sufix"
let i=$i+1

#C2 means Selective
let proxy_routing=4
strings[$i]="${iter}2"
# Let write thru be based on app, and also barrier
options[$i]="-n ${strings[$i]} -e $proxy_w -z $proxy_routing $sufix"
let i=$i+1

###############

for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
