#!/bin/bash

set -e

cd ~

case="ALL"
while getopts 'cgd' OPTION; do
    case "$OPTION" in
    c)
    case='CPU'
    ;;
    g)
    case='GPU'
    ;;
    d)
    case='DIST'
    ;;
    ?)
    usage: $(basename \$0) [-g/d]
    exit 1
    ;;
    esac
done
shift "$(($OPTIND -1))"

if [ $(which conda) == '' ]
then
echo "INSTALLING ANACONDA"
    wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh
    sh Miniconda3-py38_4.12.0-Linux-x86_64.sh -b -p ~/miniconda3/
    . ~/miniconda3/etc/profile.d/conda.sh

    conda create --name=repro python=3.8 -y
    conda activate repro

    echo "SETTING UP DACE AND NPBENCH"
    git clone --recursive https://github.com/spcl/dace
    git clone --recursive https://github.com/spcl/npbench

    cd dace
    pip install --editable .

    cd ../npbench
    pip install -r requirements.txt
    pip install --editable .
fi

cd
. ~/miniconda3/etc/profile.d/conda.sh
conda activate repro

echo "INSTALLING DACE CPU DEPENDENCIES"
cd ..
conda install -c intel mkl mkl-include mkl-devel mkl-static numpy blas -y

echo "INSTALLING DACE GPU DEPENDENCIES"
if [ $case == 'GPU' ]
then
    pip install --no-cache-dir -I cupy-cuda112
fi

if ! [ $case == 'GPU' ] || ! [ $case == 'CPU' ]
then
    echo "INSTALLING DACE DISTRIBUTED DEPENDENCIES"
    cd ~
    conda install mpi4py -y
    wget https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.7-1.tar.gz
    tar -xf mvapich2-2.3.7-1.tar.gz
    cd mvapich2-2.3.7-1
    ./configure --prefix=$HOME/installs/mvapich2/v2.3.7-1 --enable-shared --enable-romio --disable-silent-rules --disable-new-dtags --enable-fortran=all --enable-threads=multiple --with-ch3-rank-bits=32 --enable-wrapper-rpath=yes --disable-alloca --enable-fast=all --disable-cuda --enable-registration-cache --with-pmi=pmi2 --with-pm=slurm --with-slurm=/usr  --with-device=ch3:mrail --with-rdma=gen2 --disable-mcast
    make -j32 && make install
    mkdir ~/modulefiles

    echo '
    #%Module1.0
    prepend-path PATH "/shared/home/888aaen/installs/mvapich2/v2.3.7-1/bin"
    prepend-path MANPATH "/shared/home/888aaen/installs/mvapich2/v2.3.7-1/share/man"
    prepend-path LD_LIBRARY_PATH "/shared/home/888aaen/installs/mvapich2/v2.3.7-1/lib"
    '> ~/modulefiles/mvapich2_gcc7.5.0

    mkdir ~/repro/distributed
    echo '
    #!/bin/bash
    #SBATCH -p hpc
    #SBATCH -N 2
    #SBATCH --ntasks-per-node=4
    #SBATCH --cpus-per-task=30
    #SBATCH -t 00:30:00
    #SBATCH -J osu
    #SBATCH -o osu.%j.%N.out
    #SBATCH -e osu.%j.%N.err

    ### Conda
    . ~/miniconda3/etc/profile.d/conda.sh
    conda activate repro

    ### Modules
    module purge
    export MODULEPATH=/shared/home/888aaen/modulefiles:$MODULEPATH
    module load mvapich2_gcc7.5.0

    export OMP_NUM_THREADS=30
    srun --export-all --mpi=pmi2 -n 8 --ntasks-per-node=4 --cpus-per-task=30 python polybench.py
    ' > ~/repro/distributed/run_dist.sb
fi

echo "DONE SETTING UP SYSTEM FOR DACE"

cd ~

echo "To run dace_cpu, run the following:"
echo -e "\t cd ~/repro/npbench/; conda activate repro; python run_framework.py -f dace_cpu -p paper"
echo ""
if [ $case == 'GPU' ]
then
    echo "To run dace_gpu run the following:"
    echo -e "\t cd ~/repro/npbench; conda activate repro; python run_framework.py -f dace_gpu -p paper"
    echo -e "\t NOTE: You MUST run this on a GPU instance. Ensure that 'nvidia-smi' works, and that the CUDA version is at least 11.2"
    echo -e "\t In case the benchmarks break, it might be advisable to 'conda install -c nvidiia cudatoolkit=11.2 cuda=11.2'"
else
    echo "dace_gpu is not installed. To install dace_gpu, ssh onto the HTC node then run './setup-repro -g'"
fi
echo ""
if ! [ $case == "GPU" ] || ! [ $case == "CPU" ]
then
    echo "To run dace_distributed run the following:"
    echo -e "\t cd ~/repro/distributed; sbatch run_dist.sb"
    echo -e "\t NOTE: You MUST edit the node configuration (n-tasks-per-node, cpus-per-task, N, OMP_NUM_THREADS, time, etc.)"
    echo -e "\t NOTE: You MUST have slurm instantiate the resources, do NOT instantiate them yourself."
fi