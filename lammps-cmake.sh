cmake \
  	-DPKG_KOKKOS=yes \
	-DCMAKE_CXX_COMPILER=hipcc \
	-DCMAKE_INSTALL_PREFIX=/home/mlmikhai \
	-DKokkos_ENABLE_HIP=on \
	-DKokkos_ENABLE_OPENMP=yes \
	-DBUILD_OMP=yes \
	-DKokkos_ARCH_VEGA90A=on \
	-DKokkos_ARCH_ZEN3=on \
	../cmake
