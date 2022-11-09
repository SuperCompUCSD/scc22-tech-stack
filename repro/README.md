# Reproducibility

## `setup-repro.sh`
Copy the script into an empty directory and run it.
No arguments are required to be passed in.
2 directories will be added, and a `conda` environment (called `repro`) will be created if it hasn't already.

It is important to run the following commands after activating the environment (`conda activate repro`):

```
conda install blas numpy mpi4py mkl-include
```

## Shared Memory (NEIL)

To run shmem, perform the following in the directory that the setup script was executed in:
1. `cd npbench/`
2. `conda activate repro`
3. `python run_framework.py -f numpy -p paper`
4. `python run_framework.py -f dace_cpu -p paper`
5. `python plot_results.py -p paper`

This entire process should take about **3 hours**.

## GPU Benchmarking (Azure)

1. `spack load miniconda3`
nvidia-driver-470
`conda install -c nvidia cudatoolkit=11.4 cuda`
`pip install cupy pygount`

**ATAX BENCHMARKING ERROR:**
```
/usr/bin/ld: cannot find -lcublas
collect2: error: ld returned 1 exit status
CMakeFiles/parallel.dir/build.make:653: recipe for target 'libparallel.so' failed
```

...

## Distributed Benchmarking (Azure)
...
