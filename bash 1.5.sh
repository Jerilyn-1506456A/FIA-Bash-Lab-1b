#!/bin/bash

#######################

reset

if [ "$EUID" -ne 0 ] ; then
	printf "\e[31mPlease run as root!\n"
	printf "Press any key to exit\e[0m\n"
	read -n 1 -s
	exit
fi

if [ -e /etc/redhat-release ] ; then
	printf "\e[1mRunning Scan for "
	printf "$(cat /etc/redhat-release)"
	printf "\e[0m\n"
else
	printf "\e[31m\e[1mYou are not on a Red Hat System!\n"
	printf "Press any key to exit\e[0m\n"
	read -n 1 -s
	kill -9 $PPID
fi

function ctrl_C() {
	kill -9 $PPID	
}

function ctrl_Z() {
	kill -9 $PPID
}

trap ctrl_C INT
trap ctrl_Z 2 20

######################

#1.5 /var
printf "\e[1mCreating separate /var partition.\e[0m\n"
if lvcreate -l 10%VG -n var rhel ; then
	echo "/dev/rhel/var	/var	ext4	defaults	0 0" >> /etc/fstab
	printf "\e[32mExecuted.\e[0m\n"
else
	printf "\e[31mUnable to create /var!\e[0m\n"
fi

printf "\e[32mCompleted!\n"
printf "Press any key to exit\e[0m\n"

#This kills the process, please remove if not needed.
read -n 1 -s
kill -9 $PPID
