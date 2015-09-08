#!/bin/bash

#
# Raspberry pi relay script by bert janssen
# bert@firezone.org
#

#
# VARS
#

#put GPIO pins in array to match array positions with relay numbers
RELAY[1]='17'
RELAY[2]='10'
RELAY[3]='22'
RELAY[4]='23'
RELAY[5]='24'
RELAY[6]='25'
RELAY[7]='8'
RELAY[8]='7'

COMMAND=$1
COMMANDOPT=$2
ONOFFTIME="1"

if [ -z $COMMAND ] ; then 
	echo "no command specified -> opletten bert!"
	echo "u can use one of the following options:"
	echo "./gpiorelay.sh init to initialize"
	echo "./gpiorelay.sh toggle 1 to toggle relay 1"
	echo "./gpiorelay.sh onoff 1 to swith relay 1 on and off for a short period"
	echo "./gpiorelay.sh readstatus 1 to check the status of relay 1"
fi

#
# functions
#

function initrelay {
#
# Initialization
#

#export GPIO pins 
for PIN in "${RELAY[@]}"
do
	echo "exporting GPIO pin: ${PIN}"
	echo "${PIN}" > /sys/class/gpio/export
done

#set pins as out
for PIN in "${RELAY[@]}"
do
        echo "set GPIO pin as out: ${PIN}"
        echo "out" > /sys/class/gpio/gpio${PIN}/direction
done

#set GPIO pins to off so relay is in low position
for PIN in "${RELAY[@]}"
do
        echo "set GPIO to value:1 (relay off) for GPIO pin number: ${PIN}"
	echo "1" > /sys/class/gpio/gpio${PIN}/value
done
}

#
# main stuff
#

if [[ $COMMAND == "init" ]]; then
        echo "initializing GPIO"
        initrelay
fi


if [[ $COMMAND == "toggle" ]]; then
	#check if relay number is valid
        if (( $COMMANDOPT>=1 && $COMMANDOPT<=8 ));
        then
		STARTSTATUS=`cat /sys/class/gpio/gpio${RELAY[$COMMANDOPT]}/value`
		echo "start status of relay is: $STARTSTATUS"
		if [[ $STARTSTATUS -eq 1 ]]; then
			echo "0" > /sys/class/gpio/gpio${RELAY[$COMMANDOPT]}/value
		else
			echo "1" > /sys/class/gpio/gpio${RELAY[$COMMANDOPT]}/value
		fi
        else
        	echo "invalid input choose a relay number 1-8"
        fi
fi

if [[ $COMMAND == "onoff" ]]; then
        #check if relay number is valid
	if (( $COMMANDOPT>=1 && $COMMANDOPT<=8 ));
	then	
		echo "Switching relay $COMMANDOPT"
        	echo "0" > /sys/class/gpio/gpio${RELAY[$COMMANDOPT]}/value
        	sleep $ONOFFTIME
        	echo "1" > /sys/class/gpio/gpio${RELAY[$COMMANDOPT]}/value
	else
		echo "invalid input choose a relay number 1-8"
	fi
fi

if [[ $COMMAND == "readstatus" ]]; then
        #check if relay number is valid
        if (( $COMMANDOPT>=1 && $COMMANDOPT<=8 ));
        then
		RELAYSTATUS=`cat /sys/class/gpio/gpio${RELAY[$COMMANDOPT]}/value`
		echo "status=$RELAYSTATUS"
	else
		echo "invalid input choose a relay number 1-8"
	fi
fi

#echo "${RELAY[6]}"
