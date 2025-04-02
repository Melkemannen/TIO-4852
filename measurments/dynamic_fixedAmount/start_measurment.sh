filename="measurment_dynamic_fixed___$(date +'%Y_%m_%d_%H%M')"
default="/dev/ttyACM0"

if [ $# -lt 1 ]; then 
        echo "to few arguments. expected a device. using default ${default}"
        device=$default
else
        device=$1
fi
if [ ! -c "$device" ]; then
        echo "no such device: $device"
        exit 1
fi


echo "saving to ${filename}"
cat ${device} | tee "${filename}.txt"
