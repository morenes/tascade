#!/bin/bash

if [ $1 -gt 5 ]; then
  apps="0 1 2 3 4 5"
else
  apps=$1
fi

if [ -z "$4" ]; then
  echo "All datasets by default"
  datasets="Kron22 wikipedia"
else
  echo "Dataset $4"
  datasets="$4"
fi

declare -A options
declare -A strings

th=16
verbose=1
assert=0
exp="DLX_SCALE_"
# Monolithic SRAM, runs 64x64 and 256x256. Tascade uses Proxy 16x16.
# Plot dependency: Uses 128x128 from the Proxy experiment!


let proxy_routing=4
let noc_conf=1
let dcache=0
let ruche=0
let torus=1

sufix="-v $verbose -r $assert -t $th -u $noc_conf -l $ruche -o $torus -z $proxy_routing -y $dcache"

let proxy_w=16
let grid_w=64
i=0
# Dalorex 64
strings[$i]="${exp}D${grid_w}"
options[$i]="-n ${strings[$i]} -e $grid_w -c $grid_w -k $grid_w -m $grid_w $sufix" # Proxy, Chiplet, Board, Grid
let i=$i+1

# Tascade 64
strings[$i]="${exp}T${grid_w}"
options[$i]="-n ${strings[$i]} -e $proxy_w -c $grid_w -k $grid_w -m $grid_w $sufix"
let i=$i+1

let grid_w=256
# Dalorex 256
strings[$i]="${exp}D${grid_w}"
options[$i]="-n ${strings[$i]} -e $grid_w -c $grid_w -k $grid_w -m $grid_w $sufix" # Proxy, Chiplet, Board, Grid
let i=$i+1

# Tascade 256
strings[$i]="${exp}T${grid_w}"
options[$i]="-n ${strings[$i]} -e $proxy_w -c $grid_w -k $grid_w -m $grid_w $sufix"
let i=$i+1



###############

for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
