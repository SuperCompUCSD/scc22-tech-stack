#!/bin/bash -e

cd ~
if [ "$EUID" -ne 0 ]; then 
  echo "please run as root"
  exit
fi
if ! [[ -e /usr/local/go ]]; then
  apt-get update
  apt-get install -y build-essential libseccomp-dev libglib2.0-dev pkg-config squashfs-tools cryptsetup runc
  export VERSION=1.18.1 OS=linux ARCH=amd64
  wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz
  tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz
  rm go$VERSION.$OS-$ARCH.tar.gz
  if [[ $GOPATH != ${HOME}/go ]]; then
    export GOPATH=${HOME}/go
    echo 'export GOPATH=${HOME}/go' >> ~/.bashrc
  fi
  if [[ $PATH != *"/usr/local/go/bin:${PATH}:${GOPATH}/bin"* ]]; then
    echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> /etc/profile
  fi
else
  printf "\ngo already installed\n"
fi
# put this here so that go can be used while compiling singularity, without reloading bashrc
if [[ $PATH != *"/usr/local/go/bin:${PATH}:${GOPATH}/bin"* ]]; then
  export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin
fi
if ! [[ -e /usr/local/bin/singularity ]]; then
  export VERSION=3.10.3
  wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz
  tar -xzf singularity-ce-${VERSION}.tar.gz
  cd singularity-ce-${VERSION}
  git clone --recurse-submodules https://github.com/sylabs/singularity.git
  cd singularity
  git checkout --recurse-submodules v${VERSION}
  ./mconfig
  make -C ./builddir
  make -C ./builddir install
else
  printf "\nsingularity already installed\n"
fi

