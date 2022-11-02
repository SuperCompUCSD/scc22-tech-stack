#!/bin/bash
source /etc/profile
export hipcc=$(which hipcc)
export install_prefix=.
export mpi_cxx=$(which mpicxx)
cmake \
  -DPKG_KOKKOS=on \
  -DPKG_REAXFF=on \
  -DPKG_MANYBODY=on \
  -DPKG_ML-SNAP=on \
  -DBUILD_MPI=on \
  -DCMAKE_INSTALL_PREFIX=${install_prefix} \
  -DMPI_CXX_COMPILER=${mpi_cxx} \
  -DKokkos_ENABLE_HIP=on \
  -DKokkos_ENABLE_SERIAL=on \
  -DBUILD_OMP=off \
  -DCMAKE_CXX_STANDARD=14 -DKokkos_CXX_STANDARD=14 \
  -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
  -DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}" \
  -DCMAKE_CXX_COMPILER=${HIP_PATH}/bin/hipcc \
  -DKokkos_ARCH_ZEN3=ON \
  -DKokkos_ARCH_VEGA90A=ON \
  ../cmake

