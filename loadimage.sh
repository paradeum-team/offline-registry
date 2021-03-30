#!/bin/bash
set -e 

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

if [ -f "../config/config.cfg" ]; then
        . ../config/config.cfg
elif [ -f "../config.cfg" ];then
        . ../config.cfg
else
	. ./config.cfg
fi

file=${1:-"images.properties"}


target_registry=$TARGET_REGISTRY


load_imamge(){
    v=$1
    k=$2

    docker pull ${v}
    if [ -z "$k" ];then
	k=`echo ${v}|sed 's#^[^/]*#'"${target_registry}"'#'`
    fi
    echo "------------ k=v ${k}=${v}"
    docker tag ${v} ${k}
    #docker rmi ${v}
    docker push ${k}
}

if [ -f "$file" ]
then
  echo "$file found."

  while IFS='=' read -r target source
  do
    load_imamge $source $target &
  done < "$file"

  wait

else
  echo "$file not found."
fi
