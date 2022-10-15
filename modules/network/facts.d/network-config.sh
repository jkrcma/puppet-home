#!/bin/sh
out="ifupdown"
if command -v netplan >/dev/null; then
    out="netplan"
fi
echo "network_config=$out"
