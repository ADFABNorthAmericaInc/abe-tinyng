#!/bin/bash

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
 
# Begin optimizing images
cd $INDIR
shopt -s nullglob
for file in *.png *.PNG *.jpg *.JPG *.jpeg *.JPEG
do
    SIZE="$(wc -c <"$file")"
    if [ "$SIZE" -gt "$MINSIZE" ]; then
      Cfile=`curl https://api.tinify.com/shrink --user api:$TINYAPIKEY --data-binary @"${file}" --dump-header /dev/stdout --silent | grep location | awk '{print $2 }'`
      Cfile=${Cfile// }
      Cfile=`echo -n "$Cfile"| sed s/.$//`
      curl $Cfile -o "${OUTDIRNAME}/${file}" --silent
    fi
    if [ "$SIZE" -le "$MINSIZE" ]; then
      cp $file $OUTDIRNAME/$file
    fi
done

cd $DIR
mv $INDIR "${FOLDER}_old"
mv $OUTDIRNAME "${DIR}/${FOLDER}"