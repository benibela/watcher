#!/bin/bash

#This is a time tracking script
#Detecting the currently running program in 20s intervals and storing it in an encrypted, history file
#It is supposed to be put in an autostart file and be running as long as the computer runs

#configuration options:

TMPFILE=/ramdisk/curwatch
RESFILE=`date  +"/home/benito/hg/programs/system/watcher/records/%F_%T"`
LOOPS=30
#10*60/20


if [ -f $RESFILE ]; then echo $RESFILE exists;  exit; fi

rm -f $TMPFILE

#detect shutdown signal
STOP=
trap "STOP=true" SIGTERM

i=0;

while [[ -z $STOP ]]; do

  #detect program

  ID=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d ' ' -f 5`
  TITLE=`xwininfo -id $ID | grep "Window id"  | cut -d "\"" -f 2`
  PROCID=`xwininfo -id $ID -all | grep "Process id"  | grep -oE [0-9]+ `
  PROG=`ps -o %a p$PROCID | tail -1` # | tr -s " " "#"  | cut -d "#" -f 6-10  --output-delimiter " " | tr : " "`
  DATE=`date  +"%F %T"`

  #save

  echo $DATE: $PROG: $TITLE >> $TMPFILE

  #kill time wasters
  if [[ ("$TITLE" =~ "Iceweasel") || ("$PROG" =~ "firefox") ]]; then
    if [[ "$TITLE" =~ www\.reddit\.com|spiegel\.de|www\.heise\.de|www\.cracked\.com|deviantart\.com|rerefefe\.netaction\.de|blog\.refefe\.de|blog\.fefe\.de ]]; then 
    TIME=`date | grep -oE [0-9]+: | head -1`
    if [[ ($TIME != "23:") && ($TIME != "11:")  ]]; then
      killall firefox-bin; 
      sudo -u firefox killall firefox-bin;  
    fi
  fi
  fi

  #wait for next interval

  sleep 20;

  ((i++));

  #save encrypted

  if [[ $i -gt $LOOPS ]]; then
    #echo crypted
    gpg -e -r benito_local --output $RESFILE.TMP < $TMPFILE
    mv $RESFILE.TMP $RESFILE
    i=0
  fi

done

gpg -e -r benito_local --output $RESFILE.TMP < $TMPFILE
mv $RESFILE.TMP $RESFILE

