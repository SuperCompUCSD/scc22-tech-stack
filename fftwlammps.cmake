set(ALL_PACKAGES KSPACE MANYBODY MOLECULE RIGID KOKKOS OPT)

foreach(PKG ${ALL_PACKAGES})
  set(PKG_${PKG} ON CACHE BOOL "" FORCE)
endforeach()

set(Kokkos_ENABLE_SERIAL ON CACHE BOOL "" FORCE)
set(Kokkos_ENABLE_OPENMP ON CACHE BOOL "" FORCE)
set(Kokkos_ENABLE_CUDA   OFF CACHE BOOL "" FORCE)
set(Kokkos_ENABLE_HIP    ON CACHE BOOL "" FORCE)
set(Kokkos_ARCH_VEGA90A on CACHE BOOL "" FORCE)
set(Kokkos_ARCH_ZEN3 on CACHE BOOL "" FORCE)
set(Kokkos_ENABLE_HIP_MULTIPLE_KERNEL_INSTANTIATIONS ON CACHE BOOL "" FORCE)
set(BUILD_OMP ON CACHE BOOL "" FORCE)

set(CMAKE_CXX_COMPILER hipcc CACHE STRING "" FORCE)
set(CMAKE_TUNE_FLAGS "-munsafe-fp-atomics" CACHE STRING "" FORCE)

# hide deprecation warnings temporarily for stable release
set(Kokkos_ENABLE_DEPRECATION_WARNINGS OFF CACHE BOOL "" FORCE)

include_directories(/home/shared/amd-fftw/include/)
link_directories(/home/shared/amd-fftw/lib/)
# these flags are needed to build with Cray MPICH on OLCF Crusher
#-D CMAKE_CXX_FLAGS="-I/${MPICH_DIR}/include"
#-D MPI_CXX_LIBRARIES="-L${MPICH_DIR}/lib -lmpi -L${CRAY_MPICH_ROOTDIR}/gtl/lib -lmpi_gtl_hsa"
