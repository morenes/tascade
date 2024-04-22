#!/bin/bash

if [ $1 -gt 5 ]; then
  apps="0 1 2 3 4 5"
else
  apps=$1
fi

if [ -z "$4" ]; then
  let grid_w=128
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

th=16
verbose=1
assert=0
local_run=0
exp="PX_NOC"

# Monolithic SRAM
let chiplet_w=$grid_w
let board_w=$grid_w #Specify board so that the package has the same size as the board

let noc_conf=1
let dcache=0
let ruche=0
#NOC TYPE
let torus=0

sufix="-v $verbose -r $assert -t $th -u $noc_conf -m $grid_w -c $chiplet_w -k $board_w -l $ruche -o $torus -y $dcache -s $local_run"
i=0
# 0: Monolithic Mesh
let proxy_w=$grid_w
strings[$i]="${exp}0"
options[$i]="-n ${strings[$i]} -e $proxy_w  $sufix"
let i=$i+1

#1: With Proxy
let proxy_w=16
strings[$i]="${exp}11"
options[$i]="-n ${strings[$i]} -e $proxy_w  $sufix"
let i=$i+1

###### 
let torus=1
sufix="-v $verbose -r $assert -t $th -u $noc_conf -m $grid_w -c 32 -o $torus -y $dcache -s $local_run"
#2: Hierarchical Torus, chiplets 32x32
let proxy_w=$grid_w
strings[$i]="${exp}2"
options[$i]="-n ${strings[$i]} -e $proxy_w  $sufix"
let i=$i+1

let proxy_w=16
#3: With Proxy
strings[$i]="${exp}3"
options[$i]="-n ${strings[$i]} -e $proxy_w  $sufix"
let i=$i+1

####### Monolithic Torus
sufix="-v $verbose -r $assert -t $th -u $noc_conf -m $grid_w -c $chiplet_w -k $board_w -l $ruche -o $torus -y $dcache -s $local_run"
#4: Monolithic Torus
let proxy_w=$grid_w
strings[$i]="${exp}4"
options[$i]="-n ${strings[$i]} -e $proxy_w  $sufix"
let i=$i+1

#5: With Proxy
let proxy_w=16
strings[$i]="${exp}5"
options[$i]="-n ${strings[$i]} -e $proxy_w  $sufix"
let i=$i+1


###############

for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
