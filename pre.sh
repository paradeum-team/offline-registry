#!/bin/bash
set -e
BASE_DIR=$(cd `dirname $0` && pwd)
CONFIG_DIR="config/registry"
cd $BASE_DIR
if [  -f "../config/config.cfg" ];then
	. ../config/config.cfg
elif [ -f "../config.cfg" ];then
        . ../config.cfg
elif [ -f "./config.cfg" ];then
	. ./config.cfg
fi

if [ x"$LOCAL_IP" == x ];then
	echo "LOCAL_IP is empty, set 127.0.0.1"
	LOCAL_IP=127.0.0.1
fi
if [ x"$PORT" == x ];then
	echo "PORT is empty, set 5000"
	PORT=5000
fi


registry_image_name=docker.io/library/registry:2.7
if [ -f $CONFIG_DIR/config.yml ];then
	rm -rf $CONFIG_DIR/config.yml
fi

#创建证书
./mkcsr.sh

cp $CONFIG_DIR/config.yml.templ $CONFIG_DIR/config.yml && \
sed -i 's/--registry_ip--/'$LOCAL_IP'/g' $CONFIG_DIR/config.yml && \
sed -i 's/--port--/'$PORT'/g' $CONFIG_DIR/config.yml && \
docker images|grep $registry_image_name || docker load -i ./offline-registry-image/registry.tar.gz 

mkdir -p ../offline-registry_data


#自动获取挂载目录
mount_path1=$(dirname $(pwd))"/offline-registry_data"
mount_path2=$BASE_DIR"/"$CONFIG_DIR

docker stop offline-registry || echo
docker rm offline-registry || echo
docker run -d --name offline-registry \
                        --privileged --restart=always \
                        --log-driver journald \
                        --net host \
                        -v $mount_path1:/var/lib/registry \
                        -v $mount_path2:/etc/registry \
                        -e GODEBUG=netdns=cgo \
                        $registry_image_name serve /etc/registry/config.yml



