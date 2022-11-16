# to take advantage of hwloc, you should bind your mpi tasks and your openMP threads. 
#You should bind your MPI tasks by passing "--bind-to <some binding>" to the mpiexec command
# You should bind OpenMP threads by setting environment variables OMP_PROC_BIND=spread and OMP_PLACES=threads in your runscript. These are environment variables, not cmake variables, and you should export them.
# To take advantage of LMP_KOKKOS_USE_ATOMICS, you have to use half neighbor lists
cmake -C ~/scc22-scripts/optlammps.cmake -DFFT=FFTW3 -DKokkos_ENABLE_HWLOC=on -DLAMMPS_SIZES=bigbig -DLMP_KOKKOS_USE_ATOMICS=on -DFFTW3_INCLUDE_DIR=/home/shared/amd-fftw/include -DFFTW3_LIBRARY=/home/shared/amd-fftw/lib -DFFT_FFTW_THREADS=on -DFFTW3_OMP_LIBRARY=/home/shared/amd-fftw/lib ../cmake
