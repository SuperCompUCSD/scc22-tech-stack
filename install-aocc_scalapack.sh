#!/bin/bash
AOCC_LOC="/opt/AMD/aocc-compiler-3.2.0/lib"

AOCC="https://developer.amd.com/aocc-compiler-eula/"
AOCC_VALS='amd_developer_central_nonce=c5d5a7f2b0&f=YW9jYy1jb21waWxlci0zLjIuMF8xX2FtZDY0LmRlYg%3D%3D'

BLIS="https://developer.amd.com/amd-cpu-libraries_blis_eula/"
BLIS_VALS="amd_developer_central_nonce=8ef6291fce&_wp_http_referer=%2Famd-cpu-libraries_blis_eula%2F&f=YW9jbC1ibGlzLWxpbnV4LWFvY2MtMy4yLjAudGFyLmd6"

FLAME="https://developer.amd.com/amd-cpu-libraries_libflame_eula/"
FLAME_VALS="amd_developer_central_nonce=aa4856827e&_wp_http_referer=%2Famd-cpu-libraries_libflame_eula%2F&f=YW9jbC1saWJmbGFtZS1saW51eC1hb2NjLTMuMi4wLnRhci5neg%3D%3D"

SCALA="https://developer.amd.com/amd-optimizing-cpu-libraries_scalapack_libraries-eula/"
SCALA_VALS="amd_developer_central_nonce=0022651802&_wp_http_referer=%2Famd-optimizing-cpu-libraries_scalapack_libraries-eula%2F&f=YW9jbC1zY2FsYXBhY2stbGludXgtYW9jYy0zLjIuMC50YXIuZ3o%3D"
download() 
{
    if [ -z "$1" ]
    then
        echo "ERROR: No link given. ┻━┻ ︵ ＼( °□° )／ ︵ ┻━┻"
        exit 1
    elif [ -z "$2" ]
    then
        echo "ERROR: No file name given. ┻━┻ ︵ ＼( °□° )／ ︵ ┻━┻"
    fi

    curl "$1" \
        --data-raw "$3" \
        --output /tmp/$2
}

if [ "$(id -u)" -ne 0 ]
then 
    echo "ERROR: Gimme root. (╯‵□′)╯︵┻━┻"
    exit 1
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
    download $AOCC "aocc.deb" $AOCC_VALS
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
download $BLIS blis.tar.gz $BLIS_VALS

echo ": Downloading AOCC... :"
download $FLAME flame.tar.gz $FLAME_VALS

echo ": Downloading AOCC... :"
download $SCALA scala.tar.gz $SCALA_VALS

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
