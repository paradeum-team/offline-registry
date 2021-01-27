BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

# 打包标签，dev 或 stable, dev 从 dev.imagelist.txt取镜像列表
#PACKAGEING_TAG=${1:-stable}

#./load_concurrent_registry_data.sh ../offline-k8s/images_manage/docker.io.imagelist.txt docker.io &
#./load_concurrent_registry_data.sh ../offline-k8s/images_manage/quay.io.imagelist.txt quay.io &
#./load_concurrent_registry_data.sh ../offline-k8s/images_manage/docker.mirrors.ustc.edu.cn.imagelist.txt docker.mirrors.ustc.edu.cn &
#./load_concurrent_registry_data.sh ../offline-k8s/images_manage/registry.cn-hangzhou.aliyuncs.com.imagelist.txt registry.cn-hangzhou.aliyuncs.com &

#wait
echo "all k8s images download is starting..."
./loadimage.sh ../offline-k8s/image_require/k8s.images.properties

