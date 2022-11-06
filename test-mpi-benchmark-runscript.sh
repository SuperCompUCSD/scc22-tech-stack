#!/bin/bash
# stolen from Khai
# sm: shared memory byte transfer layer
# openib: infiniband byte transfer layer

/home/testcpu/matt/local/ompi/bin/mpirun \
    -mca btl ^uct,openib \
    -mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1,mlx5_1:1 \
    -rf /home/testcpu/mpi-benchmarks/rankfileB \
    -rf /home/testcpu/mpi-benchmarks/rankfileC \
    -np 2 \
    /home/testcpu/matt/mpi-benchmarks/IMB-MPI1 PingPong

