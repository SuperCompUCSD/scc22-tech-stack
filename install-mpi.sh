#!/bin/bash -e

if [ "$EUID" -ne 0 ]; then 
  echo "please run as root"
  exit
fi
SCRIPTDIR=$( dirname -- "$0"; )
if ! [[ -e /opt/AMD/aocc-compiler-3.0.0 ]]; then
  printf "\nAMD AOCC not found, installing AMD AOCC\n"
  source $SCRIPTDIR/install-aocc.sh
else
  printf "\nAMD AOCC already installed\n"
fi
# set-clang-paths is in install-aocc as well, added here for robustness
SCRIPTDIR=$( dirname -- "$0"; )
source $SCRIPTDIR/set-clang-paths.sh
export INSTALL_DIR=/opt/mpi_install
export UCX_DIR=$INSTALL_DIR/ucx
if ! [[ -e $UCX_DIR ]]; then
  printf "\nucx not found, installing ucx\n"
  cd ~
  rm -rf ucx
  git clone https://github.com/openucx/ucx.git -b v1.14.x
  cd ucx
  if ! [[ -e /usr/bin/autoconf ]]; then
    apt-get install autoconf
  fi
  if ! [[ -e /usr/bin/libtool ]]; then
    apt-get install libtool
  fi
  ./autogen.sh
  mkdir build
  cd build
  if ! [[ -e /opt/knem-1.1.4.90mlnx1/ ]]; then
    $SCRIPTDIR/mlnx-ofed.sh
  fi
  ../contrib/configure-release --prefix=$UCX_DIR \
    --with-rocm=/opt/rocm --with-knem=/opt/knem-1.1.4.90mlnx1 \
    --with-xpmem=$XPMEM_DIR  --without-cuda \
    --enable-optimizations --disable-logging \
    --disable-debug --disable-assertions \
    --disable-params-check  --without-java
  make -j$(nproc)
  make -j$(nproc) install
  ln -s /opt/mpi_install/ucx/bin/* /usr/bin/
else
  printf "\nucx already installed\n"
fi
export OMPI_DIR=$INSTALL_DIR/ompi
if ! [[ -e /opt/mellanox/hcoll ]]; then
  printf "\nmlnx-ofed not found, installing mlnx-ofed\n"
  $SCRIPTDIR/mlnx-ofed.sh
else
  printf "\nmlnx-ofed already installed\n"
fi
export LD_LIBRARY_PATH=/opt/mellanox/hcoll/lib:$LD_LIBRARY_PATH
if ! [[ -e $OMPI_DIR ]]; then
  printf "\nopen-mpi not found, installing open-mpi\n"
  cd ~
  rm -rf ompi
  git clone --recursive https://github.com/open-mpi/ompi.git -b v4.1.x
  cd ompi
  ./autogen.pl
  mkdir build
  cd build
  ../configure --prefix=$OMPI_DIR --with-ucx=$UCX_DIR \
    --enable-mca-no-build=btl-uct --enable-mpi1-compatibility \
    --enable-mpi-cxx --with-hcoll=/opt/mellanox/hcoll \
    --with-slurm --with-pmix CC=clang CXX=clang++ FC=flang
  make -j $(nproc)
  make -j $(nproc) install
  if ! [[ -e /usr/lib/libnuma.so ]]; then
    ln -sfn /usr/lib/x86_64-linux-gnu/libnuma.so.1 /usr/lib/libnuma.so
  fi
  if [[ $PATH != *"/opt/mpi_install/ompi/bin"* ]]; then
    echo "aocc not in path, adding"
    export PATH=/opt/mpi_install/ompi/bin:$PATH
    echo 'export PATH=/opt/mpi_install/ompi/bin:$PATH' >> /etc/profile
  fi
  if [[ $LD_LIBRARY_PATH != *"/opt/mpi_install/ompi/lib"* ]]; then
    echo "aocc not in path, adding"
    export LD_LIBRARY_PATH=/opt/mpi_install/ompi/lib:$LD_LIBRARY_PATH
    echo 'export LD_LIBRARY_PATH=/opt/mpi_install/ompi/lib:$LD_LIBRARY_PATH' >> /etc/profile
  fi
  ln -s /opt/mpi_install/ompi/bin/* /usr/bin/
else
  printf "\nopen-mpi already installed\n"
fi
