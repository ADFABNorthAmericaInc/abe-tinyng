#!/bin/bash
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Make sure source dir is supplied
if [ -z "$1" ]
  then
  echo "Missing argument. Supply the source directory containing the images to be optimized. Usage: ./tiny.sh <source_dir>"
  exit 1
fi
 
INDIR=$1
 
# Make sure api key is set
if [ -z "$2" ]
  then
  echo "Missing API KEY"
  exit 1
fi
 
TINYAPIKEY=$2
 
# Make sure min image size is set
if [ -z "$3" ]
  then
  echo "Missing min image size"
  exit 1
fi
 
MINSIZE=$3
SLEEPTIME=${4:-"1m"}
SLEEPCOUNT_DEFAULT=${5:-100}
SLEEPCOUNT=$SLEEPCOUNT_DEFAULT

# Make sure source dir exists
if [ ! -d "$INDIR" ]; then
  echo ""$INDIR" directory not found. Supply the source directory containing the images to be optimized. Source directory should be relative to location of this script. Usage: ./tiny.sh <source_dir>"
  exit 1
fi
 
DIR=${INDIR%/*}
FOLDER=${INDIR##/*/}
DIRNAME=${INDIR##*/}
OUTDIRNAME="${DIR}/${DIRNAME}_tiny"

# Create output dir if it does not already exist
if [ ! -d "$OUTDIRNAME" ]; then
  mkdir $OUTDIRNAME
fi
 
start=`date +%s`
# Begin optimizing images
cd $INDIR
# count file over minimum file size, use a tmp file to write the counter to use inside child bash function
count=$(find . -maxdepth 1 -type f -size $MINSIZE | wc -l | awk '{print $1}')
TEMPFILE=/tmp/$$.tmp
echo $count > $TEMPFILE

# @param $1 = image filename
optimize () {
  # curl tinify.com and catch response header, grep location > to Cfile variable (= url of the file tinified)
  Cfile=`curl --insecure https://api.tinify.com/shrink --user api:$TINYAPIKEY --data-binary @"$1" --dump-header /dev/stdout --silent | grep location | awk '{print $2}'`
  Cfile=`echo -n "$Cfile"| sed s/.$//`
  # curl tinified image
  curl -n --insecure $Cfile -o "${OUTDIRNAME}/${file}" --silent || cp $file $OUTDIRNAME/$file
  COUNTER=$[$(cat $TEMPFILE) - 1]
  echo $COUNTER > $TEMPFILE
  end=`date +%s`
  runtime=$((end-start))
  percent=$(awk "BEGIN { pc=100-(${COUNTER}/${count}*100); i=int(pc); print (pc-i<0.5)?i:i+1 }")
  printf "\033c${PURPLE}Number of file to optimize ${COUNTER} / ${count}${NC} ${percent}%% %02dh:%02dm:%02ds\n" $(($runtime/3600)) $(($runtime%3600/60)) $(($runtime%60))
  # when counter is equal to zero, rename file and print the end
  if [ "$COUNTER" -le "0" ]; then
    cd $DIR 
    mkdir "${INDIR}_old"
    cp -r $INDIR/ "${FOLDER}_old/"
    sleep 3s
    rsync -a $OUTDIRNAME/ $INDIR/
    rm -rf $OUTDIRNAME
    printf "${GREEN}Images optimized${NC} 👍"
    unlink $TEMPFILE
  fi
}

find . -maxdepth 1 -type f -size $MINSIZE -print0 | while read -d $'\0' file
do
  optimize $file  &
  SLEEPCOUNT=$((SLEEPCOUNT-1))
  if [ "$SLEEPCOUNT" -eq 0 ]; then
    sleep $SLEEPTIME
    SLEEPCOUNT=$SLEEPCOUNT_DEFAULT
  fi
done
