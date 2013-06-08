Watcher
============

Simple shell script to track when you have used which programs


Installation
------------------
Requirements: bash, gpg and X11 (xwininfo, xprop)

Copy watcher.sh somewhere, and adjust the following variables at the beginning of the file:

* RESFILE: The final log file it should create, gpg encrypted
* TMPFILE: A temporary log file, unencrypted (so put it on a ramdisk, not in /tmp)
* GPGKEYNAME: name of the local gpg key used to encrypt it (refer to the gpg documentation on how to use gpg). 

Then start the  shellscript and it will stay in the background, logging the current program to the 
log file you have set, every 20 seconds.

If you want to start it automatically at login, you can set the path to the .sh in the .desktop file
and copy the .desktop file to ~/.config/autostart/

The script will frequently (or when it receives SIGTERM) create the encrypted version from the unencrypted one.

If you also want to log the visited web pages, look in my firefox-stuff repository for a greasemonkey script,
adding the current url to the window title of Firefox.

Interpreting the log file
-----------------------

It will create a new log file every time it is started, with the filename of the log file containing 
the time and date it was started.

The unencrypted log file consists of time stamp, process command line, and X11 window title.

E.g.:

    2013-06-08 15:07:16: python /usr/local/bin/guake: Guake!


You can count how much time (in 20s intervals) you have spend using a certain program with

    cat logfiles* | grep programname | wc -l


The encrypted log files have to be unencryped  before being used. You can e.g. decrypt all log files
to an encrypted partition with:

    OUTPATH=/path/to/encrypted/partition
    for i in *; do
      if [[ ! ( -e $OUTPATH/$i ) ]]; then
        gpg -o - --use-agent $i > $OUTPATH/$i 
      fi
    done

