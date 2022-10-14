#!/bin/sh

pidfile=/var/run/puppet/master.pid

test -f $pidfile || exit 1
kill -0 $( cat $pidfile )
