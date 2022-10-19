#!/bin/bash

mkdir -p /tmp/Sim4n6/
FILE=/tmp/Sim4n6/sim4n6.txt

for f in $(ls TarSlip_*.py); do
	echo "$f";
	python3 "$f" archive_malign.tar;
	if test -f "$FILE"; then
    		echo -e "\e[32mOK\e[0m"
		rm "$FILE";
	else
		echo -e "\e[31mNot OK\e[0m";
	fi
done;
