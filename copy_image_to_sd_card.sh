device=""
img_name=$(cat config | grep IMG_NAME | cut -d '=' -f 2)
img_date=""
img_type=""
img_suffix=$(cat stage2/EXPORT_IMAGE | grep ^IMG_SUFFIX | cut -d '"' -f 2)

lsblk

echo "enter device name to use (without number. e.g.: sdx):"

read device

umount "/dev/${device}1"
umount "/dev/${device}2"

echo "enter date of image to use. (yyyy-mm-dd):"

read img_date

ls  "work/${img_date}-${img_name}" &> /dev/null
if [ $? -ne 0 ]; then
  echo "directory: work/${img_date}-${img_name}/ does not exist."
  exit 2
fi

echo "choose lite image or desktop image. Type: l or d"

read img_type

if [[ $img_type != "l" ]]; then
  if [[ $img_type != "d" ]]; then
    echo "invalid image type. exit."
    exit 2
  fi
  img_suffix=$(cat stage4/EXPORT_IMAGE | grep ^IMG_SUFFIX | cut -d '"' -f 2)
fi

if [ ! -f "work/${img_date}-${img_name}/export-image/${img_date}-${img_name}${img_suffix}.img" ]; then
  echo "image: work/${img_date}-${img_name}/export-image/${img_date}-${img_name}${img_suffix}.img does not exist."
  exit 2
fi

echo "start writing image work/${img_date}-${img_name}/export-image/${img_date}-${img_name}${img_suffix}.img"

dd bs=4M if="work/${img_date}-${img_name}/export-image/${img_date}-${img_name}${img_suffix}.img" of="/dev/${device}" conv=fsync

if [ $? -eq 0 ]; then
	echo "done!"
else
	echo "an error occured!"
        exit 2
fi

exit 0
