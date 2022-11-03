#!/bin/bash
source /etc/profile
cmake \
  -DPKG_KOKKOS=yes \
  -DPKG_REAXFF=yes \
  -DPKG_MANYBODY=yes \
  -DPKG_ML-SNAP=yes \
  -DBUILD_MPI=yes \
  -DCMAKE_INSTALL_PREFIX=. \
  -DMPI_CXX_COMPILER=/opt/mpi_install/ompi/bin/mpicxx \
  -DKokkos_ARCH_ZEN3=yes \
  -DKokkos_ARCH_VEGA90A=yes \
  -DKokkos_ENABLE_HIP=yes \
  -DCMAKE_CXX_COMPILER=/usr/bin/hipcc \
  -DCMAKE_CXX_FLAGS=-I/opt/rocm-5.3.0/hip/include \
  -DCMAKE_SHARED_LINKER_FLAGS=-L/opt/rocm-5.3.0/hip/lib \
  -DClangFormat_EXECUTABLE=/usr/bin/clang-format \
  ../cmake

  #-DKokkos_ENABLE_HWLOC=on \
  #-DHWLOC_LIBRARY=/usr/lib/x86_64-linux-gnu/hwloc \
  #-DHWLOC_INCLUDE_DIRS=/usr/mpi/gcc/openmpi-4.1.5a1/include/openmpi/opal/mca/hwloc/hwloc201/hwloc/include \
  #-DKokkos_HWLOC_DIR=$with_hwloc
  # -DKokkos_HWLOC_DIR=/usr/mpi/gcc/openmpi-4.1.5a1/include/openmpi/opal/mca/hwloc/hwloc201/hwloc/include/hwloc \
  # -DCMAKE_CXX_STANDARD=14 -DKokkos_CXX_STANDARD=14 \
  # -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
  # -DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}" \
