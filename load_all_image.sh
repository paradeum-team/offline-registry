BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

IMAGELIST_DIR="../offline-imagelist"

echo "all images download is starting..."

for file in `ls $IMAGELIST_DIR`;
do
	filedir="$IMAGELIST_DIR/$file"
	./loadimage.sh $filedir
done


