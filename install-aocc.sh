#!/bin/bash -e

echo "installing AOCC"
SCRIPTDIR=$( dirname -- "$0"; )
# install aocc 3.0.0 if it is not already installed
apt install $SCRIPTDIR/aocc-compiler-3.0.0_1_amd64.deb
if [[ $PATH != *"/opt/AMD/aocc-compiler-3.0.0/bin"* ]]; then
  echo "aocc not in path, adding"
  export PATH=/opt/AMD/aocc-compiler-3.0.0/bin:$PATH
  echo 'export PATH=/opt/AMD/aocc-compiler-3.0.0/bin:$PATH' >> /etc/profile
fi
if [[ $LD_LIBRARY_PATH != *"/opt/AMD/aocc-compiler-3.0.0/lib"* ]]; then
  echo "aocc not in link library path, adding"
  export LD_LIBRARY_PATH=/opt/AMD/aocc-compiler-3.0.0/lib:$LD_LIBRARY_PATH
  echo 'export LD_LIBRARY_PATH=/opt/AMD/aocc-compiler-3.0.0/lib:$LD_LIBRARY_PATH' >> /etc/profile
fi
source $SCRIPTDIR/set-clang-paths.sh
if ! [[ -e /opt/AMD/aocc-compiler-3.0.0 ]]; then
  >&2 echo "warning: aocc 3.0.0 not installed"
  exit 1
fi
