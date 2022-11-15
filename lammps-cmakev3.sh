cmake \
  	-DPKG_KOKKOS=yes \
	-DCMAKE_CXX_COMPILER=hipcc \
	-DCMAKE_INSTALL_PREFIX=/home/mlmikhai \
	-DKokkos_ENABLE_HIP=on \
	-DKokkos_ARCH_VEGA908=on \
	-DBUILD_OMP=no \
	-DKokkos_ARCH_ZEN3=on \
	../cmake
