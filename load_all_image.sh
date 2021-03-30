BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

echo "all images download is starting..."
./loadimage.sh ../offline-imagelist/images.properties

