<p align="center"><img src="assets/lockup-org-slate.png" width="560" alt="tandem rng"></p>

Tandem8x32 is a noncryptographic pseudorandom number generator built to be fast on CPUs and GPUs alike.
The [specification](https://github.com/tandem-rng/spec) defines how the bitstream is produced, and every port below writes it bit for bit, so a seed gives the same bitstream in every language and on every device.

| language | repository | status |
|---|---|---|
| Julia | [TandemRNG.jl](https://github.com/tandem-rng/TandemRNG.jl) | reference, CPU and GPU arrays |
| C, C++17 | [tandem-c](https://github.com/tandem-rng/tandem-c) | reference, SIMD and OpenMP offload |
| Rust | [tandem-rs](https://github.com/tandem-rng/tandem-rs) | `rand_core` traits, `wgpu` fills |
| Python | [tandem-numpy](https://github.com/tandem-rng/tandem-numpy) | NumPy `BitGenerator` |
| CUDA | [tandem-cuda](https://github.com/tandem-rng/tandem-cuda) | header-only device core |
| JAX | [tandem-jax](https://github.com/tandem-rng/tandem-jax) | `jax.random` key, CUDA kernels |
| R | [tandem-r](https://github.com/tandem-rng/tandem-r) | package `tandemrng`, base R hook |
| PyTorch | [tandem-torch](https://github.com/tandem-rng/tandem-torch) | CPU and CUDA tensors |
| WebGPU | [tandem-webgpu](https://github.com/tandem-rng/tandem-webgpu) | WGSL shader, TypeScript CPU path |
| Fortran | [tandem-fortran](https://github.com/tandem-rng/tandem-fortran) | module, CUDA Fortran fills |
| Kokkos | [tandem-kokkos](https://github.com/tandem-rng/tandem-kokkos) | every Kokkos backend |
| Java | [tandem-java](https://github.com/tandem-rng/tandem-java) | `RandomGenerator`, CUDA through FFM |
| Mojo | [tandem-mojo](https://github.com/tandem-rng/tandem-mojo) | CPU and GPU fills |
| SYCL | [tandem-sycl](https://github.com/tandem-rng/tandem-sycl) | any SYCL device |

| | GiB/s | baseline | source |
|---|---|---|---|
| Float64 fill, NVIDIA A100 | 1392 | cuRAND Philox 795 | [tandem-cuda](https://github.com/tandem-rng/tandem-cuda/blob/main/docs/speed.md) |
| `randn` float32, NVIDIA A100 | 1255 | `torch.randn` 913 | [tandem-torch](https://github.com/tandem-rng/tandem-torch) |
| `standard_normal` float64, Apple M4, one thread | 4.9 | NumPy `PCG64` 2.0 | [tandem-numpy](https://github.com/tandem-rng/tandem-numpy) |

Portions of the code were generated with the assistance of LLMs.

[Specification](https://github.com/tandem-rng/spec/blob/main/SPEC.md) · [tandem-rng.github.io](https://tandem-rng.github.io) · [Apache 2.0 license](https://github.com/tandem-rng/.github/blob/main/LICENSE)
