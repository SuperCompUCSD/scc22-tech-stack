[1] MVAPICH2 AZURE (ignore since we got it working but its a good backup option)

https://github.com/Azure/azhpc-images/releases/tag/centos-hpc-20210525


[2] MVAPICH2 from source

(a) Download

wget https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.7-1.tar.gz

(b) Install libpmi2

sudo apt-get install libpmi2-0
sudo apt-get install libpmi2-0-dev

NOTE: Need to install atleast libpmi2-0 on all the compute nodes

(c) Install MVAPICH2

./configure --prefix=$HOME/installs/mvapich2/v2.3.7-1 --enable-shared --enable-romio --disable-silent-rules --disable-new-dtags --enable-fortran=all --enable-threads=multiple --with-ch3-rank-bits=32 --enable-wrapper-rpath=yes --disable-alloca --enable-fast=all --disable-cuda --enable-registration-cache --with-pmi=pmi2 --with-pm=slurm --with-slurm=/usr  --with-device=ch3:mrail --with-rdma=gen2 --disable-mcast

make -j32
make install

```
#%Module1.0

prepend-path PATH "/shared/home/888aaen/installs/mvapich2/v2.3.7-1/bin"
prepend-path MANPATH "/shared/home/888aaen/installs/mvapich2/v2.3.7-1/share/man"
prepend-path LD_LIBRARY_PATH "/shared/home/888aaen/installs/mvapich2/v2.3.7-1/lib"
```

NOTE: I built this with the system default gcc compilers. If you want to use something else you can always set CC, CXX, FC, F77 and then run a configure (if you do this install it in a different prefix).

[3] Created a module file (manually) in:

/shared/home/888aaen/modulefiles

[4] Example OSU runs are in:

/shared/home/888aaen/osu_benchmarks

[5] Backups on Expanse:

/expanse/projects/qstore/use300/bkup

