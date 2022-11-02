#!/bin/bash
source /etc/profile
export hipcc=$(which hipcc)
export install_prefix=.
export mpi_cxx=$(which mpicxx)
cmake \
  -DPKG_KOKKOS=yes \
  -DPKG_REAXFF=yes \
  -DPKG_MANYBODY=yes \
  -DPKG_ML-SNAP=yes \
  -DBUILD_MPI=yes \
  -DCMAKE_INSTALL_PREFIX=${install_prefix} \
  -DMPI_CXX_COMPILER=${mpi_cxx} \
  -DKokkos_ARCH_ZEN3=yes \
  -DKokkos_ARCH_VEGA90A=yes \
  -DKokkos_ENABLE_HIP=yes \
  -DCMAKE_CXX_STANDARD=14 -DKokkos_CXX_STANDARD=14 \
  -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
  -DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}" \
  -DCMAKE_CXX_COMPILER=${HIP_PATH}/bin/hipcc \
  ../cmake

#  -DBUILD_OMP=yes \
#  -DKokkos_ENABLE_OPENMP=yes \
