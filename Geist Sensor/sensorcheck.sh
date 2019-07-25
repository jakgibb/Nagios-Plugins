#!/bin/bash

#Nagios plugin to monitor a Geist Watchdog temperaure sensor
#To use:
#Place this script in the /usr/local/nagios/libexec directory
#Create a new Check Command to invoke this script: /usr/local/nagios/libexec/sensortempchek.sh $ARG1$ $ARG2$ $ARG3$ $ARG4$ $ARG5$
#Set up a Nagios Service passing the IP as $ARG1$; location as $ARG2$; SNMP community string as $ARG3$; warning/critical as $ARG4$/$ARG5$

sensorIP=$1
location=$2
community=$3
warning=$4
critical=$5

#Script can handle multiple sensors
#Pass in the relavent location from Nagios
if [ "$location" == "Room A" ]
then
        id="1.3.6.1.4.1.21239.5.1.2.1.5"
        temp=$(snmpwalk -c $community -v 1 -O vq $sensorIP $id)
        temp=$(echo $temp |sed 's/\s.*$//')
        temp=$(($temp/10))
elif [ "$location" == "Room B" ]
then
        id="1.3.6.1.4.1.21239.5.1.4.1.5"
        temp=$(snmpwalk -c $community -v 1 -O vq $sensorIP $id)
        temp=$(echo $temp |sed 's/\s.*$//')
        temp=$(($temp/10))
elif [ "$location" == "Room C" ]
then
        id="1.3.6.1.4.1.21239.5.1.4.1.5"
        temp=$(snmpwalk -c $community -v 1 -O vq $sensorIP $id)
        temp=$(echo $temp | awk '{print $2}' | sed 's/\s.*$//')
        temp=$(($temp/10))
fi


if [ -z "$temp" ]
then
        echo "Unable to get temperature from $location sensor"
        exit 3
fi

#Performance data can be passed to Nagios: all variables passed after the '|' are sent to Nagios for performance logging
if [ "$temp" -ge "$critical" ]
then
        echo "$location temperature is critical - Current temperature: $temp degres |temp=$temp"
        exit 2
elif [ "$temp" -ge "$warning" ]
then
        echo "$location temperature is at a warning - Current temperature: $temp degress | temp=$temp"
        exit 1
else
        echo "$location temperature is OK - Current temperature: $temp degress | temp=$temp"
        exit 0
fi
