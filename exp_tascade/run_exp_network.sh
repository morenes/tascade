#!/bin/bash

if [ $1 -gt 5 ]; then
  apps="0 1 2 3 4 5"
else
  apps=$1
fi

datasets="Kron22 wikipedia"
declare -A options
declare -A strings

th=8
verbose=1
assert=0
exp="NOC"

i=0

let mesh_w=64
let chiplet_w=16
let proxy_w=16

let proxy_routing=4
let dcache=0


local_run=0

sufix="-v $verbose -r $assert -t $th -m $mesh_w -c $chiplet_w -e $proxy_w -z $proxy_routing -y $dcache -s $local_run"


strings[$i]="${exp}N0"
# u: wide noc, l: long-wires Ruche
options[$i]="-n ${strings[$i]} -u 0  $sufix"
let i=$i+1

strings[$i]="${exp}N1"
options[$i]="-n ${strings[$i]} -u 1  $sufix"
let i=$i+1

strings[$i]="${exp}N2"
options[$i]="-n ${strings[$i]} -u 2  $sufix"
let i=$i+1

strings[$i]="${exp}N3"
options[$i]="-n ${strings[$i]} -u 3  $sufix"
let i=$i+1


for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
