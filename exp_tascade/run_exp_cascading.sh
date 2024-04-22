#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Error: Missing required parameters."
    exit 1
fi

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

echo "apps=$apps"
echo "datasets=$datasets"

declare -A options
declare -A strings

th=16
verbose=1
assert=0
iter="CASC"

# Monolithic SRAM, runs 128x128. Tascade uses Proxy 16x16.
# Plot dependency: Uses 128x128 from the Proxy experiment!


let chiplet_w=$grid_w
let board_w=$grid_w #Specify board so that the package has the same size as the board

let noc_conf=1
let dcache=0
let ruche=0
let torus=1
let phy_nocs=1

sufix="-v $verbose -r $assert -t $th -u $noc_conf -m $grid_w -c $chiplet_w -k $board_w -l $ruche -o $torus -y $dcache -x $phy_nocs"

let proxy_w=16

#C0 means Never Cascading
let proxy_routing=3
i=0
strings[$i]="${iter}0"
options[$i]="-n ${strings[$i]} -e $proxy_w -z $proxy_routing   $sufix"
let i=$i+1

#C1 means Always Cascading, no write thru, because it may deadlock since it's forced to cascade
let proxy_routing=5
strings[$i]="${iter}1"
options[$i]="-n ${strings[$i]} -e $proxy_w -z $proxy_routing  -j 0 $sufix" # j=0 -> Force write-back
let i=$i+1

#C2 means Selective
let proxy_routing=4
strings[$i]="${iter}2"
options[$i]="-n ${strings[$i]} -e $proxy_w -z $proxy_routing  $sufix" # Use write-thru or write-back, depending on the app!
let i=$i+1

###############

for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
