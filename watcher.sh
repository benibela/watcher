#!/bin/bash

TMPFILE=/ramdisk/curwatch
RESFILE=`date  +"/home/benito/hg/programs/system/watcher/records/%F_%T"`
LOOPS=30
#10*60/20


if [ -f $RESFILE ]; then echo $RESFILE exists;  exit; fi

rm -f $TMPFILE

STOP=
trap "STOP=true" SIGTERM

i=0;

while [[ -z $STOP ]]; do

ID=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d ' ' -f 5`
TITLE=`xwininfo -id $ID | grep "Window id"  | cut -d "\"" -f 2`
PROCID=`xwininfo -id $ID -all | grep "Process id"  | grep -oE [0-9]+ `
PROG=`ps -o %a p$PROCID | tail -1` # | tr -s " " "#"  | cut -d "#" -f 6-10  --output-delimiter " " | tr : " "`
DATE=`date  +"%F %T"`

echo $DATE: $PROG: $TITLE >> $TMPFILE

sleep 20;

((i++));

#echo ping

if [[ $i -gt $LOOPS ]]; then
#echo crypted
gpg -e -r benito_local --output $RESFILE.TMP < $TMPFILE
mv $RESFILE.TMP $RESFILE
i=0
fi

done

gpg -e -r benito_local --output $RESFILE.TMP < $TMPFILE
mv $RESFILE.TMP $RESFILE

