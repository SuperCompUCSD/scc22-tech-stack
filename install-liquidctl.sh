#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]
then 
    echo "ERROR: Gimme root. (╯‵□′)╯︵┻━┻"
    exit 1
fi

echo "---- Installing liquidctl ----"
echo -e "Ctrl+C to cancel within 5 seconds. Starting in 5..."
sleep 1

for (( i=4; i>0; i-- ))
do
    echo -e "$i..."
    sleep 1
done

apt install -y python3-dev python3-setuptools python3-pkg-resources python3-usb python3-colorlog python3-crcmod python3-hidapi python3-docopt python3-pil python3-smbus i2c-tools libusb-1.0-0-dev python3-setuptools-scm
python3 -m pip install ./liquidctl/
