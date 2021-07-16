#!/bin/sh
out=0
if test -d /etc/node-exporter; then
    out=1
fi
echo "node_exporter_textfile_dir=$out"

