#!/bin/bash

set -e

cd ~

if ! command -v spack &> /dev/null
then
    echo "Spack not found... installing..."
    git clone -c feature.manyFiles=true https://github.com/spack/spack.git
    cd spack/
    git checkout releases/v0.18
    echo 'export PATH=~/spack/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    cd ~
fi

spack init

spack compiler find
spack install miniconda3
spack load miniconda3

conda init

conda create --name=repro python=3.8

git clone --recursive https://github.com/spcl/dace
git clone --recursive https://github.com/spcl/npbench
