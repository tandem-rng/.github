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
| Metal | [tandem-metal](https://github.com/tandem-rng/tandem-metal) | Swift package, MSL shader, Swift CPU fills |
| MLX | [tandem-mlx](https://github.com/tandem-rng/tandem-mlx) | `mx.fast.metal_kernel` over the tandem-metal shader |
| Haskell | [tandem-hs](https://github.com/tandem-rng/tandem-hs) | pure Haskell, `random` interface, under review |
| OCaml | [tandem-ml](https://github.com/tandem-rng/tandem-ml) | fills over tandem-c, pure OCaml fallback, Float64 only |

| port | hardware | Float64 uniform fill, GiB/s | Float64 normal fill, GiB/s | source |
|---|---|---|---|---|
| tandem-c | Apple M4 Pro, one thread | 16.1, Philox4x32-10 2.3 | 7.5 | [docs/speed.md at d9e1e54](https://github.com/tandem-rng/tandem-c/blob/d9e1e54/docs/speed.md) |
| TandemRNG.jl | Apple M4 Pro, one task | 17.4, `Xoshiro` 20.2 | 6.24, `Xoshiro` 7.17 | [performance.md at 6f2988b](https://github.com/tandem-rng/TandemRNG.jl/blob/6f2988b/docs/src/performance.md) |
| tandem-cuda | NVIDIA A100 40 GB | 1392, cuRAND 795 | 1065 to 1096, cuRAND 597 | [docs/speed.md at 4260acf](https://github.com/tandem-rng/tandem-cuda/blob/4260acf/docs/speed.md) |

Every port's figures are on [tandem-rng.github.io](https://tandem-rng.github.io/#bench).

Portions of the code were generated with the assistance of LLMs.

[Specification](https://github.com/tandem-rng/spec/blob/main/SPEC.md) · [tandem-rng.github.io](https://tandem-rng.github.io) · [Apache 2.0 license](https://github.com/tandem-rng/.github/blob/main/LICENSE)
