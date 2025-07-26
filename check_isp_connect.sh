#!/bin/sh
# check_isp_connect plugin for Nagios/Icinga
# Written by Udo Seidel
#
# Description:
#
# This plugin will perform 2 basic checks regarding connection to the internet (via ISP)
#
# 

MYCHECK1=""
MYCHECK2=""
# One idea would be to use IPs of the famous DNS servers
# here is an example for the Google ones
#MYCHECK2=8.8.8.8
#CHECK2=8.8.4.4


# Nagios return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

EXITSTATUS=$STATE_UNKNOWN #default


PROGNAME=`basename $0`

print_usage() {
	echo 
	echo " This plugin will perform 2 internet connectivity checks."
	echo 
	echo 
        echo " Usage: $PROGNAME -u <URL> -i <IP>"
        echo
        echo "   -u: URL to be checked against"
        echo
        echo "   -i: IP adress to be checked against"
        echo
        echo "   -h: print this help"
	echo 
}

if [ "$#" -lt 1 ]; then
	print_usage
        EXITSTATUS=$STATE_UNKNOWN
        exit $EXITSTATUS
fi

check_isp_connect()
{
# first we check simple including DNS resolution
ping -c3 $MYCHECK1 > /dev/null 2>&1
if [ "$?" -ne 0  ];
then
	EXITSTATUS=$STATE_WARNING
        # looks like we need to check on IP level only
        ping -c3 $MYCHECK2 > /dev/null 2>&1
        if [ "$?" -eq 0  ];
        then
        	# IP level works ... let's do nothing right now
		echo "WARNING - DNS does not work but $MYCHECK2 is reachable"
        	exit $EXITSTATUS
	else
		EXITSTATUS=$STATE_CRITICAL
		echo "CRITICAL - checks on $MYCHECK1 but $MYCHECK2 failed"
		exit $EXITSTATUS
        fi
else
	EXITSTATUS=$STATE_OK
	echo "OK - Looks ok ($MYCHECK1 and $MYCHECK2 are reachable)"
	exit $EXITSTATUS
fi
}

while getopts "h:u:i" OPT
do		
	case "$OPT" in
	h)
		print_usage
		exit $STATE_UNKNOWN
		;;
	u)
		MYCHECK1=$2
		;;
	i)
		MYCHECK2=$4
		;;
	*)
		print_usage
		exit $STATE_UNKNOWN
	esac
done

check_isp_connect $MYCHECK1
exit $EXITSTATUS
