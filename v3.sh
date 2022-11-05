cmake \
  	-DPKG_KOKKOS=yes \
	-DCMAKE_CXX_COMPILER=g++ \
	-DCMAKE_INSTALL_PREFIX=/home/mlmikhai \
	-DKokkos_ENABLE_OPENMP=yes \
	-DBUILD_OMP=yes \
	-DKokkos_ARCH_VEGA90A=on \
	../cmake
