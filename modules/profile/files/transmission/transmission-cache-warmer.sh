#!/bin/sh

datadir="$1"

if [ ! -d "$datadir" ]; then
    echo "Can't access transmission data directory"
    exit 1
fi

transmission-remote -l | grep Seeding | awk '{print $1}' | while read id; do
    transmission-remote -t $id -if | tail -n +3 | awk '{$1=$2=$3=$4=$5=$6=""}1' | sed 's/^ \+//g'
done | while read f; do
    cat "$datadir"/"$f" > /dev/null
done
