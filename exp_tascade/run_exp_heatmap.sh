#!/bin/bash

if [ $1 -gt 5 ]; then
  apps="0 1 2 3 4 5"
else
  apps=$1
fi

if [ -z "$4" ]; then
  let grid_w=64
  echo "Default grid_w=$grid_w"
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

th=2 # To avoid artifacts in the heatmap due to frame asynchrony
verbose=2
assert=0
exp="HEAT"

let noc_conf=1
let dcache=0
let ruche=0
let torus=0

let chiplet_w=$grid_w
let board_w=$grid_w #Specify board so that the package has the same size as the board



local_run=1

sufix="-v $verbose -r $assert -t $th -u $noc_conf -m $grid_w -c $chiplet_w -k $board_w -l $ruche -y $dcache -s $local_run"
i=0
### MESH
# No Proxy
let proxy_w=$grid_w
strings[$i]="${exp}${proxy_w}M"
options[$i]="-n ${strings[$i]} -e $proxy_w -o $torus $sufix"
let i=$i+1

# Proxy 8x8
let proxy_w=8
strings[$i]="${exp}${proxy_w}M"
options[$i]="-n ${strings[$i]} -e $proxy_w -o $torus $sufix"
let i=$i+1

### TORUS
torus=1
# No Proxy
let proxy_w=$grid_w
strings[$i]="${exp}${proxy_w}T"
options[$i]="-n ${strings[$i]} -e $proxy_w -o $torus $sufix"
let i=$i+1

# Proxy 8x8
let proxy_w=8
strings[$i]="${exp}${proxy_w}T"
options[$i]="-n ${strings[$i]} -e $proxy_w -o $torus $sufix"
let i=$i+1


####
# Sync & Merge 8x8
let proxy_w=8
let proxy_routing=3
strings[$i]="${exp}${proxy_w}S"
options[$i]="-n ${strings[$i]} -e $proxy_w -o $torus -z $proxy_routing -j 0 -b 2 $sufix"
let i=$i+1


###############

for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
