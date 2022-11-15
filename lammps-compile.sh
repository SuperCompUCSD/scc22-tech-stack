#!/bin/bash

if ! [[ -e ./lammps-23Jun2022 ]]; then
  tar -xvzf lammps-stable.tar.gz
  cd lammps-23Jun2022
  mkdir build
  cd build
  source ${1}
  cmake --build . -j 28
else
  printf "\nlammps-23Jun2022 directory already exists, please move to prevent overwriting\n"
fi

