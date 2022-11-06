#!/bin/bash

cd ~
MYHOME=$(pwd)
mkdir -p matt/local/ucx
cd matt
git clone -b v1.14.x https://github.com/openucx/ucx.git
cd ucx
./autogen.sh
./contrib/configure-release --prefix=${MYHOME}/matt/local/ucx
make -j8
make install

