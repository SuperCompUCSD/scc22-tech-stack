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

**REMEMBER TO EXPORT THE NUM THREADS VARIABLE**
To run shmem, perform the following in the directory that the setup script was executed in:
1. `cd npbench/`
2. `conda activate repro`
3. `python run_framework.py -f numpy -p paper`
4. `python run_framework.py -f dace_cpu -p paper`
5. `python plot_results.py -p paper`

This entire process should take about **3 hours**.

## GPU Benchmarking (Azure)

1. `sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub`
2. `sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"`
3. `sudo apt-get update`
4. `sudo apt install cuda-11-4`
5. `export PATH="/usr/local/cuda-10.1/bin:$PATH"`
    `export LD_LIBRARY_PATH="/usr/local/cuda-10.1/lib64:$LD_LIBRARY_PATH"`
6. `pip install --no-cache-dir -I cupy-cuda114`


### Errors for GPU Benchmarking:

Note, despite some errors, we still got plottable results that we could use in the paper. I have no clue how because some of these errors are
straight up compiler errors, but a win is a win.

**~~atax:~~** Resolved by installing cuda from apt instead of conda
```
/usr/bin/ld: cannot find -lcublas
collect2: error: ld returned 1 exit status
CMakeFiles/parallel.dir/build.make:653: recipe for target 'libparallel.so' failed
```

**azimint_naive, conv2d_bias, lenet, INCLUDED resnet:**
```
***** Testing DaCe GPU with azimint_naive on the S dataset *****
NumPy - default - validation: 393ms
DaCe GPU - fusion - first/validation: 83ms
DaCe GPU - fusion - validation: SUCCESS
DaCe GPU - fusion - median: 73ms
DaCe GPU - parallel - first/validation: 332ms
Failed to run DaCe GPU validation.
Failed to execute the DaCe GPU - parallel implementation.
cudaErrorIllegalAddress: an illegal memory access was encountered
Failed to execute the DaCe GPU - auto_opt implementation.
cudaErrorIllegalAddress: an illegal memory access was encountered
Failed to run DaCe GPU validation.
Failed to execute the DaCe GPU - auto_opt implementation.
cudaErrorIllegalAddress: an illegal memory access was encountered
```

**contour_integral, crc16, scattering_self_energies:** (These are failing tests)
```
***** Testing DaCe GPU with contour_integral on the S dataset *****
NumPy - default - validation: 16ms
??? Where is the rest of the info ???
```

**INCLUDED correlation, INCLUDED deriche, doitgen:**
```
WARNING: Shadowing variable i from type (<DefinedType.Scalar: 2>, 'long long') to DefinedType.Scalar
WARNING: Shadowing variable i from type (<DefinedType.Scalar: 2>, 'long long') to DefinedType.Scalar
WARNING: Shadowing variable i from type (<DefinedType.Scalar: 2>, 'long long') to DefinedType.Scalar
Failed to compile DaCe gpu auto_opt implementation.
Compiler failure:
[ 20%] Building NVCC (Device) object CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o
nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(96): warning: variable "a" was declared but never referenced
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(237): warning: variable "__out" was declared but never referenced

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(287): error: identifier "__tmp12" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(289): error: identifier "__tmp12" is undefined

2 errors detected in the compilation of "/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu".
CMake Error at cuda_compile_1_generated_auto_opt_cuda.cu.o.RelWithDebInfo.cmake:276 (message):
Error generating file
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/./cuda_compile_1_generated_auto_opt_cuda.cu.o


CMakeFiles/auto_opt.dir/build.make:557: recipe for target 'CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o' failed
make[2]: *** [CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o] Error 1
CMakeFiles/Makefile2:84: recipe for target 'CMakeFiles/auto_opt.dir/all' failed
make[1]: *** [CMakeFiles/auto_opt.dir/all] Error 2
Makefile:90: recipe for target 'all' failed
make: *** [all] Error 2

Traceback (most recent call last):
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/compiler.py", line 229, in configure_and_compile
_run_liveoutput("cmake --build . --config %s" % (Config.get('compiler', 'build_type')),
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/compiler.py", line 413, in _run_liveoutput
raise subprocess.CalledProcessError(process.returncode, command, output.getvalue())
subprocess.CalledProcessError: Command 'cmake --build . --config RelWithDebInfo' returned non-zero exit status 2.

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
File "/shared/home/888aaen/repro/npbench/npbench/infrastructure/dace_framework.py", line 274, in implementations
dc_exec, compile_time = util.benchmark("__npb_result = sdfg.compile()",
File "/shared/home/888aaen/repro/npbench/npbench/infrastructure/utilities.py", line 140, in benchmark
output = timeit.repeat(stmt, setup=setup, repeat=repeat, number=1, globals=ldict)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 238, in repeat
return Timer(stmt, setup, timer, globals).repeat(repeat, number)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 205, in repeat
t = self.timeit(number)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 177, in timeit
timing = self.inner(it, self.timer)
File "<timeit-src>", line 6, in inner
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/sdfg/sdfg.py", line 2253, in compile
    shared_library = compiler.configure_and_compile(program_folder, sdfg.name)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/compiler.py", line 238, in configure_and_compile
    raise cgx.CompilationError('Compiler failure:\n' + ex.output)
    dace.codegen.exceptions.CompilationError: Compiler failure:
    [ 20%] Building NVCC (Device) object CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o
    nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
    nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
    /shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(96): warning: variable "a" was declared but never referenced
    /shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(237): warning: variable "__out" was declared but never referenced

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(287): error: identifier "__tmp12" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(289): error: identifier "__tmp12" is undefined

2 errors detected in the compilation of "/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu".
CMake Error at cuda_compile_1_generated_auto_opt_cuda.cu.o.RelWithDebInfo.cmake:276 (message):
Error generating file
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/./cuda_compile_1_generated_auto_opt_cuda.cu.o


CMakeFiles/auto_opt.dir/build.make:557: recipe for target 'CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o' failed
make[2]: *** [CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o] Error 1
CMakeFiles/Makefile2:84: recipe for target 'CMakeFiles/auto_opt.dir/all' failed
make[1]: *** [CMakeFiles/auto_opt.dir/all] Error 2
Makefile:90: recipe for target 'all' failed
make: *** [all] Error 2
```

**INCLUDED gemver:**
```
Failed to compile DaCe gpu auto_opt implementation.
'Variable A_OUT_0 has not been defined'
Traceback (most recent call last):
File "/shared/home/888aaen/repro/npbench/npbench/infrastructure/dace_framework.py", line 274, in implementations
dc_exec, compile_time = util.benchmark("__npb_result = sdfg.compile()",
File "/shared/home/888aaen/repro/npbench/npbench/infrastructure/utilities.py", line 140, in benchmark
output = timeit.repeat(stmt, setup=setup, repeat=repeat, number=1, globals=ldict)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 238, in repeat
return Timer(stmt, setup, timer, globals).repeat(repeat, number)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 205, in repeat
t = self.timeit(number)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 177, in timeit
timing = self.inner(it, self.timer)
File "<timeit-src>", line 6, in inner
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/sdfg/sdfg.py", line 2240, in compile
    program_objects = codegen.generate_code(sdfg, validate=validate)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/codegen.py", line 229, in generate_code
    (global_code, frame_code, used_targets, used_environments) = frame.generate_code(sdfg, None)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/framecode.py", line 824, in generate_code
    states_generated = self.generate_states(sdfg, global_stream, callsite_stream)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/framecode.py", line 409, in generate_states
    callsite_stream.write(cft.as_cpp(self, sdfg.symbols), sdfg)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/control_flow.py", line 217, in as_cpp
    expr += elem.as_cpp(codegen, symbols)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/control_flow.py", line 129, in as_cpp
    expr += self.dispatch_state(self.state)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/framecode.py", line 386, in dispatch_state
    self._dispatcher.dispatch_state(sdfg, state, global_stream, stream)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/dispatcher.py", line 354, in dispatch_state
    disp.generate_state(sdfg, state, function_stream, callsite_stream)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/cuda.py", line 1182, in generate_state
    self._frame.generate_state(sdfg, state, function_stream, callsite_stream, generate_state_footer=False)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/framecode.py", line 353, in generate_state
    self._dispatcher.dispatch_subgraph(sdfg, state, sid, global_stream, callsite_stream, skip_entry_node=False)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/dispatcher.py", line 388, in dispatch_subgraph
    self.dispatch_scope(v.map.schedule, sdfg, scope_subgraph, state_id, function_stream, callsite_stream)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/dispatcher.py", line 432, in dispatch_scope
    self._map_dispatchers[map_schedule].generate_scope(sdfg, sub_dfg, state_id, function_stream, callsite_stream)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/cuda.py", line 1474, in generate_scope
    self.generate_kernel_scope(sdfg, dfg_scope, state_id, scope_entry.map, kernel_name, grid_dims, block_dims,
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/cuda.py", line 1890, in generate_kernel_scope
    self._dispatcher.dispatch_subgraph(sdfg,
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/dispatcher.py", line 393, in dispatch_subgraph
    self.dispatch_node(sdfg, dfg, state_id, v, function_stream, callsite_stream)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/dispatcher.py", line 420, in dispatch_node
    disp.generate_node(sdfg, dfg, state_id, node, function_stream, callsite_stream)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/cpu.py", line 145, in generate_node
    gen(sdfg, dfg, state_id, node, function_stream, callsite_stream)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/cpu.py", line 2002, in _generate_AccessNode
    self.process_out_memlets(
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/cpu.py", line 978, in process_out_memlets
    dispatcher.dispatch_copy(
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/dispatcher.py", line 562, in dispatch_copy
    target.copy_memory(sdfg, dfg, state_id, src_node, dst_node, edge, function_stream, output_stream)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/cuda.py", line 1148, in copy_memory
    self._emit_copy(state_id, src_node, src_storage, dst_node, dst_storage, dst_schedule, memlet, sdfg, dfg,
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/cuda.py", line 1081, in _emit_copy
    copy_shape, src_strides, dst_strides, src_expr, dst_expr = (memlet_copy_to_absolute_strides(
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/cpp.py", line 133, in memlet_copy_to_absolute_strides
    dst_expr = copy_expr(dispatcher,
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/targets/cpp.py", line 74, in copy_expr
    defined_types = dispatcher.defined_vars.get(ptrname, is_global=is_global)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/dispatcher.py", line 82, in get
    raise KeyError("Variable {} has not been defined".format(name))
    KeyError: 'Variable A_OUT_0 has not been defined'
    Traceback
```

**mandelbrot2:**
```
***** Testing DaCe GPU with mandelbrot2 on the S dataset *****
NumPy - default - validation: 18ms
WARNING: Shadowing variable j from type (<DefinedType.Scalar: 2>, 'long long') to DefinedType.Scalar
WARNING: Shadowing variable j from type (<DefinedType.Scalar: 2>, 'long long') to DefinedType.Scalar
WARNING: Shadowing variable j from type (<DefinedType.Scalar: 2>, 'long long') to DefinedType.Scalar
WARNING: Shadowing variable j from type (<DefinedType.Scalar: 2>, 'long long') to DefinedType.Scalar
WARNING: Shadowing variable j from type (<DefinedType.Scalar: 2>, 'long long') to DefinedType.Scalar
```

**nbody, INCLUDED vadv:**
```
***** Testing DaCe GPU with nbody on the S dataset *****
NumPy - default - validation: 9ms
Failed to compile DaCe gpu auto_opt implementation.
Compiler failure:
[ 20%] Building NVCC (Device) object CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o
nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(309): warning: variable "a" was declared but never referenced
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(420): error: identifier "__tmp102" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(422): error: identifier "__tmp102" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(890): error: identifier "__tmp101" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(894): error: identifier "__tmp101" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(907): error: identifier "__tmp107" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1161): error: identifier "__tmp103" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1163): error: identifier "__tmp103" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1616): error: identifier "__tmp106" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1618): error: identifier "__tmp106" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1896): error: identifier "__tmp104" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1898): error: identifier "__tmp104" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1898): error: identifier "__tmp108" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1911): error: identifier "__tmp105" is undefined

13 errors detected in the compilation of "/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu".
CMake Error at cuda_compile_1_generated_auto_opt_cuda.cu.o.RelWithDebInfo.cmake:276 (message):
Error generating file
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/./cuda_compile_1_generated_auto_opt_cuda.cu.o


CMakeFiles/auto_opt.dir/build.make:567: recipe for target 'CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o' failed
make[2]: *** [CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o] Error 1
CMakeFiles/Makefile2:84: recipe for target 'CMakeFiles/auto_opt.dir/all' failed
make[1]: *** [CMakeFiles/auto_opt.dir/all] Error 2
Makefile:90: recipe for target 'all' failed
make: *** [all] Error 2

Traceback (most recent call last):
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/compiler.py", line 229, in configure_and_compile
_run_liveoutput("cmake --build . --config %s" % (Config.get('compiler', 'build_type')),
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/compiler.py", line 413, in _run_liveoutput
raise subprocess.CalledProcessError(process.returncode, command, output.getvalue())
subprocess.CalledProcessError: Command 'cmake --build . --config RelWithDebInfo' returned non-zero exit status 2.

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
File "/shared/home/888aaen/repro/npbench/npbench/infrastructure/dace_framework.py", line 274, in implementations
dc_exec, compile_time = util.benchmark("__npb_result = sdfg.compile()",
File "/shared/home/888aaen/repro/npbench/npbench/infrastructure/utilities.py", line 140, in benchmark
output = timeit.repeat(stmt, setup=setup, repeat=repeat, number=1, globals=ldict)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 238, in repeat
return Timer(stmt, setup, timer, globals).repeat(repeat, number)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 205, in repeat
t = self.timeit(number)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 177, in timeit
timing = self.inner(it, self.timer)
File "<timeit-src>", line 6, in inner
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/sdfg/sdfg.py", line 2253, in compile
    shared_library = compiler.configure_and_compile(program_folder, sdfg.name)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/compiler.py", line 238, in configure_and_compile
    raise cgx.CompilationError('Compiler failure:\n' + ex.output)
    dace.codegen.exceptions.CompilationError: Compiler failure:
    [ 20%] Building NVCC (Device) object CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o
    nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
    nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
    /shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(309): warning: variable "a" was declared but never referenced
    /shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(420): error: identifier "__tmp102" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(422): error: identifier "__tmp102" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(890): error: identifier "__tmp101" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(894): error: identifier "__tmp101" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(907): error: identifier "__tmp107" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1161): error: identifier "__tmp103" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1163): error: identifier "__tmp103" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1616): error: identifier "__tmp106" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1618): error: identifier "__tmp106" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1896): error: identifier "__tmp104" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1898): error: identifier "__tmp104" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1898): error: identifier "__tmp108" is undefined

/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(1911): error: identifier "__tmp105" is undefined

13 errors detected in the compilation of "/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu".
CMake Error at cuda_compile_1_generated_auto_opt_cuda.cu.o.RelWithDebInfo.cmake:276 (message):
Error generating file
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/./cuda_compile_1_generated_auto_opt_cuda.cu.o


CMakeFiles/auto_opt.dir/build.make:567: recipe for target 'CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o' failed
make[2]: *** [CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o] Error 1
CMakeFiles/Makefile2:84: recipe for target 'CMakeFiles/auto_opt.dir/all' failed
make[1]: *** [CMakeFiles/auto_opt.dir/all] Error 2
Makefile:90: recipe for target 'all' failed
make: *** [all] Error 2

Traceback
DaCe GPU - fusion - first/validation: 599ms
DaCe GPU - fusion - validation: SUCCESS
DaCe GPU - fusion - median: 129ms
DaCe GPU - parallel - first/validation: 133ms
DaCe GPU - parallel - validation: SUCCESS
DaCe GPU - parallel - median: 125ms
```

**symm:**
```
***** Testing DaCe GPU with symm on the S dataset *****
NumPy - default - validation: 9ms
Failed to compile DaCe gpu auto_opt implementation.
Compiler failure:
[ 20%] Building NVCC (Device) object CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o
nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(200): error: identifier "__tmp10" is undefined
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(204): error: identifier "__tmp10" is undefined

2 errors detected in the compilation of "/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu".
CMake Error at cuda_compile_1_generated_auto_opt_cuda.cu.o.RelWithDebInfo.cmake:276 (message):
Error generating file
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/./cuda_compile_1_generated_auto_opt_cuda.cu.o


CMakeFiles/auto_opt.dir/build.make:567: recipe for target 'CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o' failed
make[2]: *** [CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o] Error 1
CMakeFiles/Makefile2:84: recipe for target 'CMakeFiles/auto_opt.dir/all' failed
make[1]: *** [CMakeFiles/auto_opt.dir/all] Error 2
Makefile:90: recipe for target 'all' failed
make: *** [all] Error 2

Traceback (most recent call last):
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/compiler.py", line 229, in configure_and_compile
_run_liveoutput("cmake --build . --config %s" % (Config.get('compiler', 'build_type')),
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/compiler.py", line 413, in _run_liveoutput
raise subprocess.CalledProcessError(process.returncode, command, output.getvalue())
subprocess.CalledProcessError: Command 'cmake --build . --config RelWithDebInfo' returned non-zero exit status 2.

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
File "/shared/home/888aaen/repro/npbench/npbench/infrastructure/dace_framework.py", line 274, in implementations
dc_exec, compile_time = util.benchmark("__npb_result = sdfg.compile()",
File "/shared/home/888aaen/repro/npbench/npbench/infrastructure/utilities.py", line 140, in benchmark
output = timeit.repeat(stmt, setup=setup, repeat=repeat, number=1, globals=ldict)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 238, in repeat
return Timer(stmt, setup, timer, globals).repeat(repeat, number)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 205, in repeat
t = self.timeit(number)
File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/timeit.py", line 177, in timeit
timing = self.inner(it, self.timer)
File "<timeit-src>", line 6, in inner
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/sdfg/sdfg.py", line 2253, in compile
    shared_library = compiler.configure_and_compile(program_folder, sdfg.name)
    File "/shared/home/888aaen/miniconda3/envs/repro/lib/python3.8/site-packages/dace/codegen/compiler.py", line 238, in configure_and_compile
    raise cgx.CompilationError('Compiler failure:\n' + ex.output)
    dace.codegen.exceptions.CompilationError: Compiler failure:
    [ 20%] Building NVCC (Device) object CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o
    nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
    nvcc warning : The 'compute_35', 'compute_37', 'compute_50', 'sm_35', 'sm_37' and 'sm_50' architectures are deprecated, and may be removed in a future release (Use -Wno-deprecated-gpu-targets to suppress warning).
    /shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(200): error: identifier "__tmp10" is undefined
    /shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu(204): error: identifier "__tmp10" is undefined

2 errors detected in the compilation of "/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/src/cuda/auto_opt_cuda.cu".
CMake Error at cuda_compile_1_generated_auto_opt_cuda.cu.o.RelWithDebInfo.cmake:276 (message):
Error generating file
/shared/home/888aaen/repro/npbench/.dacecache/auto_opt/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/./cuda_compile_1_generated_auto_opt_cuda.cu.o


CMakeFiles/auto_opt.dir/build.make:567: recipe for target 'CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o' failed
make[2]: *** [CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/repro/npbench/.dacecache/auto_opt/src/cuda/cuda_compile_1_generated_auto_opt_cuda.cu.o] Error 1
CMakeFiles/Makefile2:84: recipe for target 'CMakeFiles/auto_opt.dir/all' failed
make[1]: *** [CMakeFiles/auto_opt.dir/all] Error 2
Makefile:90: recipe for target 'all' failed
make: *** [all] Error 2

Traceback
DaCe GPU - fusion - first/validation: 537ms
DaCe GPU - fusion - validation: SUCCESS
DaCe GPU - fusion - median: 59ms
DaCe GPU - parallel - first/validation: 3ms
DaCe GPU - parallel - validation: SUCCESS
DaCe GPU - parallel - median: 1ms
```

...

## Distributed Benchmarking (Azure)
...
