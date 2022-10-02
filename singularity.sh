#!/bin/sh -e

mkdir -p ~/.local
export VERSION=1.19.1 OS=linux ARCH=amd64
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz
tar -C ~/.local -xzvf go$VERSION.$OS-$ARCH.tar.gz
rm go$VERSION.$OS-$ARCH.tar.gz
echo 'export GOPATH=${HOME}/go' >> ~/.bashrc
export GOPATH=${HOME}/go
echo 'export PATH=~/.local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc
export PATH=~/.local/go/bin:${PATH}:${GOPATH}/bin
export VERSION=3.10.0 && # adjust this as necessary
wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz
tar -xvzf singularity-ce-${VERSION}.tar.gz
rm singularity-ce-${VERSION}.tar.gz
cd singularity-ce-${VERSION}
./mconfig --without-suid --without-conmon --without-seccomp --prefix=~/.local/
cd builddir
make
make install

echo "now, run 'export PATH=~/.local/bin:\$PATH' to be able to use singularity, or exit and log back in"
