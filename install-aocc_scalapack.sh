#!/bin/sh -e

$AOCC_LOC="/opt/AMD/aocc-compiler-3.2.0/lib"
$AOCC="https://developer.amd.com/aocc-compiler-eula/"
$BLIS="https://developer.amd.com/amd-cpu-libraries_blis_eula/"
$FLAME="https://developer.amd.com/amd-cpu-libraries_libflame_eula/"
$SCALA="https://developer.amd.com/amd-optimizing-cpu-libraries_scalapack_libraries-eula/"

download() 
{
    if [ -z "$1" ]
    then
        echo "ERROR: No link given. ┻━┻ ︵ ＼( °□° )／ ︵ ┻━┻"
        exit(1)
    elif [ -z "$2" ]
    then
        echo "ERROR: No file name given. ┻━┻ ︵ ＼( °□° )／ ︵ ┻━┻"
    fi

    curl "$1" \
        --data-raw 'amd_developer_central_nonce=c5d5a7f2b0&f=YW9jYy1jb21waWxlci0zLjIuMF8xX2FtZDY0LmRlYg%3D%3D' \
        --output /tmp/$2
}

if [ "$(id -u)" -ne 0 ]
then 
    echo "ERROR: Gimme root. (╯‵□′)╯︵┻━┻"
    exit
fi

echo "---- Installing AOCC ----"
echo -e "Ctrl+C to cancel within 5 seconds. Starting in 5..."
sleep 1

for (( i=4; i>0; i-- ))
do
    echo -e "$i..."
    sleep 1
done

# Install AOCC first
cd aocc
if [ ! -d "/opt/AMD" ]
then
    echo ": Downloading AOCC... :"
    download $AOCC "aocc.deb"
    echo ": Installing .deb file... :"
    dpkg -i /tmp/aocc.deb
    #dpkg -i aocc-compiler-3.2.0_1_amd64.deb
fi

echo "---- Installing AOCC Libraries ----"
echo -e "Ctrl+C to cancel within 3 seconds. Starting in 3..."
sleep 1

for (( i=2; i>0; i-- ))
do
    echo -e "$i..."
    sleep 1
done

# Install scalapack, libflame, and blis
cd scalapack

echo ": Downloading AOCC... :"
download $BLIS blis.tar.gz

echo ": Downloading AOCC... :"
download $FLAME flame.tar.gz

echo ": Downloading AOCC... :"
download $SCALA scala.tar.gz

tar -xvf /tmp/blis.tar.gz -C /tmp
tar -xvf /tmp/flame.tar.gz -C /tmp
tar -xvf /tmp/scala.tar.gz -C /tmp

echo ": Moving library files :"
cp /tmp/amd-blis/include/LP64/* $AOCC_LOC
cp /tmp/amd-blis/examples/LP64/* $AOCC_LOC
cp /tmp/amd-blis/lib/LP64/* $AOCC_LOC
cp /tmp/amd-libflame/lib/LP64/* $AOCC_LOC
cp /tmp/amd-scalapack/lib/LP64/* $AOCC_LOC

echo "---- Finished. ----"
