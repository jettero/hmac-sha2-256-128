#!/bin/bash

echo; echo try to remove links and keys
for i in ipsec0 ipsec1 ipsec2 gretap0 gre0; do
    sudo ip tunnel del $i
    sudo ip link del $i
done

sudo setkey -F
sudo setkey -PF

echo; echo try to remove modules

RMMODS=( ip_gre gre af_key esp4 xfrm4_mode_transport xfrm_algo )

x=0
r=10
while [ $x -lt ${#RMMODS[*]} -a $r -gt 0 ]; do
for mod in ${RMMODS[*]}; do
    y="$( sudo rmmod $mod 2>&1 )"
    echo "x=$x r=$r y=$y"
    [[ "$y" =~ is.not.currently.loaded ]] && x=$(( x + 1 ))
    r=$(( r - 1 ))
done
done
