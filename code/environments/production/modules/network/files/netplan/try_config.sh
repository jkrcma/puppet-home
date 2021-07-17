#!/bin/sh

failed=0
for ip in $@; do
    gw=$( echo $ip | awk -F'.' '{print $1"."$2"."$3"."1}' )
    if ! ping -q -i0.2 -c5 $gw 2>/dev/null; then
        failed=1
        break
    fi
done

if [ $failed -eq 1 ]; then
    for f in /etc/netplan/*.puppet-bak; do
        cp -f $f $( dirname $f )/$( basename $f .puppet-bak )
    done

    netplan apply
    exit 1
fi
