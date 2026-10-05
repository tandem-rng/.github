## Not checked here

A GitHub runner has no GPU, so these paths are skipped:

- tandem-cuda: all device fills. Its core.hpp runs on the CPU through tandem-kokkos and tandem-sycl.
- tandem-kokkos: the CUDA backend.
- tandem-sycl: the CUDA device.
- tandem-torch: the CUDA fills.
- tandem-jax: the CUDA and CPU FFI fills.
- tandem-java: the PTX module in cuda/ and the libtandem fills.
- tandem-webgpu and tandem-rs: the WebGPU fills.
- tandem-metal: the Metal kernels.
- tandem-mlx: every fill, since all of them run Metal kernels.
- TandemRNG.jl: the GPU extensions.
- tandem-fortran: the CUDA Fortran module.

Some ports lack a stream:

- tandem-jax has no exponentials.
- tandem-r and tandem-ml have no float32 exponentials, so they write the float64 half only.
