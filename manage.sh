#/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../../../manageUtils.sh

githubProject watcher

BASE=$HGROOT/programs/system/watcher

case "$1" in
mirror)
  syncHg  
;;

esac

