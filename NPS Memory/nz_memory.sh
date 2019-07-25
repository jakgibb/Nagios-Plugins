#!/bin/bash
#Script for use with Nagios to check for high NPS memory usage

critical=800
memory="$(sudo -u nz /nz/kit/bin/adm/nzsqa memtbl -sys | grep 'region calc inuse' |awk -F: '{print $2}' |awk '{print $1}')"
memory=$((memory / 10**6))

if [ $memory -gt "$critical" ]; then
        echo "High system memory usage - currently: $memory MB in use | mem=$memory"
        exit 2
else
        echo "System memory usage OK - currently: $memory MB | mem=$memory"
        exit 0
fi
