#!/bin/bash -e

if ! [[ -e /etc/infiniband/info ]]; then
  tput bold; tput setaf 196;
  printf "THIS SCRIPT WILL RENAME YOUR INTERFACES CAUSING YOU TO LOSE NETWORK CONNECTION TO THE NODE <3\n
  TO RESET NETWORK CONNECTION YOU MUST CONNNECT OVER IPMI AND MODIFY THE NETPLAN SETTINGS UNDER /etc/netplan\n
  OVER IPMI YOU MUST ADD THE CORRECT INTERFACE NAMES BASED ON THE OUTPUT OF ip addr\n
  DO YOU UNDERSTAND AND APPROVE? [Y/n] "
  tput sgr0
  read answer
  if [[ $answer != Y ]] && [[ $answer != y ]] ; then
    exit 1
  fi
  OSVER=$(grep VERSION_ID /etc/os-release | cut -d'"' -f 2)
  echo "OSVER: $OSVER"
  cd ~
  if [[  $OSVER == "22.04" ]]; then
    wget https://www.mellanox.com/downloads/ofed/MLNX_OFED-5.7-1.0.2.0/MLNX_OFED_SRC-debian-5.7-1.0.2.0.tgz
    TARFILE=MLNX_OFED_SRC-debian-5.7-1.0.2.0.tgz
    tar -xvzf $TARFILE
    cd MLNX_OFED_SRC-5.7-1.0.2.0/
    ./install.pl
  elif [[ $OSVER == "20.04" ]]; then
    wget https://content.mellanox.com/ofed/MLNX_OFED-5.7-1.0.2.0/MLNX_OFED_LINUX-5.7-1.0.2.0-ubuntu20.04-x86_64.tgz
    TARFILE=MLNX_OFED_LINUX-5.7-1.0.2.0-ubuntu20.04-x86_64.tgz
    tar -xvzf $TARFILE
    cd MLNX_OFED_LINUX-5.7-1.0.2.0-ubuntu20.04-x86_64/
    ./mlnxofedinstall
  else
    >&2 echo "I do not know where to find ofed drivers for $OSVER"
    exit 1
  fi
  if [[ $LD_LIBRARY_PATH != *"/opt/mellanox/hcoll/lib"* ]]; then
    echo 'export LD_LIBRARY_PATH=/opt/mellanox/hcoll/lib:$LD_LIBRARY_PATH' >> /etc/profile
  fi
else
  >&2 echo "infiniband already installed"
  exit 1
fi
