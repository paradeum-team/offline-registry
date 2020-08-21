#!/bin/bash
set -e
BASE_DIR=$(cd `dirname $0` && pwd)
CONFIG_DIR="config/registry"
cd $BASE_DIR
if [  -f "../offline-okd/config.cfg" ];then
	. ../offline-okd/config.cfg
elif [ -f "../config.cfg" ];then
        . ../config.cfg
elif [ -f "./config.cfg" ];then
	. ./config.cfg
fi
if [ x"$LOCAL_IP" == x ];then
	echo "LOCAL_IP is empty, set 127.0.0.1"
	LOCAL_IP=127.0.0.1
fi
registry_image_name=docker.io/library/registry:2.7
if [ -f $CONFIG_DIR/config.yml ];then
	rm -rf $CONFIG_DIR/config.yml
fi
cp $CONFIG_DIR/config.yml.templ $CONFIG_DIR/config.yml && \
sed -i 's/--registry_ip--/'$LOCAL_IP'/g' $CONFIG_DIR/config.yml && \
docker images|grep $registry_image_name || docker load -i ../offline-images/registry.tar.gz 

mkdir -p ../offline-registry_data

docker stop offline-registry || echo
docker rm offline-registry || echo
docker run -d --name offline-registry \
                        --privileged --restart=always \
                        --log-driver journald \
                        --net host \
                        -v /data/offline-openshift-origin/offline-registry_data:/var/lib/registry \
                        -v /data/offline-openshift-origin/offline-registry/config/registry:/etc/registry \
                        -e GODEBUG=netdns=cgo \
                        $registry_image_name serve /etc/registry/config.yml



# 安装rhsm redhat-uep.pem, 解决pull radhat 镜像问题
wget http://${CONFIGSERVER_IP}:${CONFIGSERVER_PORT}/packages/centos/base/RPMS/python-rhsm-certificates-1.19.10-1.el7_4.x86_64.rpm
rpm2cpio python-rhsm-certificates-1.19.10-1.el7_4.x86_64.rpm | cpio -iv --to-stdout ./etc/rhsm/ca/redhat-uep.pem > /etc/rhsm/ca/redhat-uep.pem
rm -f python-rhsm-certificates-1.19.10-1.el7_4.x86_64.rpm
