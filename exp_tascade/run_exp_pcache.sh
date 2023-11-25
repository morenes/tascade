#!/bin/bash

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
exp="NPCACHESCL"

i=0

let chiplet_w=$grid_w
let board_w=$grid_w #Specify board so that the package has the same size as the board

let noc_conf=1
let dcache=0
let ruche=0
let torus=1


local_run=0

sufix="-v $verbose -r $assert -t $th -u $noc_conf -m $grid_w -c $chiplet_w -k $board_w -l $ruche -o $torus -y $dcache -s $local_run"

# We already have F1 and F4 from proxy experiment!
let proxy_w=16

strings[$i]="${exp}${proxy_w}F2"
options[$i]="-n ${strings[$i]} -e $proxy_w -f 2 $sufix"
let i=$i+1

strings[$i]="${exp}${proxy_w}F8"
options[$i]="-n ${strings[$i]} -e $proxy_w -f 8 $sufix"
let i=$i+1

strings[$i]="${exp}${proxy_w}F16"
options[$i]="-n ${strings[$i]} -e $proxy_w -f 16 $sufix"
let i=$i+1


###############

for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
