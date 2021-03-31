set  -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR
is_use_private_registry=$1
user=$2
password=$3
registry=$4 
if [ "$1"x = "true"x ];then
	if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ];then
		echo "Usage: $0 true user password registry"
		echo "please enter login parameter"
		exit 1
	else
		docker login -u $2 -p $3 $4
	fi
fi


IMAGELIST_DIR="../offline-imagelist"

echo "all images download is starting..."

#for file in `ls $IMAGELIST_DIR`;
#do
#	filedir="$IMAGELIST_DIR/$file"
#	./loadimage.sh $filedir
#done


