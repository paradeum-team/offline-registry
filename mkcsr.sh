#!/bin/bash
set -e 
BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR
CONFIG_DIR="config/registry"

if [  -f "../config/config.cfg" ];then
	. ../config/config.cfg
elif [ -f "../config.cfg" ];then
        . ../config.cfg
elif [ -f "./config.cfg" ];then
	. ./config.cfg
fi

project=`echo $TARGET_REGISTRY | awk -F ":" '{print $1}'`
project_short=`echo $project | awk -F "." '{print $2}'`
domain="*.$project_short.com"

key="$CONFIG_DIR/ssl/$project.key"
crt="$CONFIG_DIR/ssl/$project.crt"

if [ -f $key || -f $crt ]; then
	rm -rf $CONFIG_DIR/ssl/*
fi


# 生成ca key
openssl genrsa -out $key 2048

# 创建根证书
openssl req -utf8 -new -nodes -x509 -days 3650 -key $key  -out $crt -subj "/C=CN/ST=beijing/L=beijing/O=$project_short/OU=IT/CN=$domain"

# 修改配置
sed -i 's/--project--/'$project'/g' $CONFIG_DIR/config.yml.templ
