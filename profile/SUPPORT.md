# Port support

Each port writes the Tandem8x32 bitstream. Floating-point mappings and derived draws have separate contracts, so matching bits do not imply identical values from every framework's samplers.

This table describes documented interfaces, not a hardware validation matrix. Follow each port's link for its API and tested devices.
The precision columns cover Float32 and Float64 draws. They do not list every integer, half-precision, or complex type.
A dash in the GPU column means the port documents no GPU interface. “CPU conversion” means GPU-generated words become floating-point values on the host.

| Port and API | CPU interface | GPU interface | Float32 | Float64 | Limits |
|---|---|---|---|---|---|
| [Julia](https://tandem-rng.github.io/TandemRNG.jl/devices/) | Native | CUDA, AMDGPU, Metal, Reactant | CPU and GPU | CPU, CUDA, AMDGPU, Reactant | Metal rejects Float64 array draws. AMDGPU hardware validation remains open. |
| [C / C++](https://tandem-rng.github.io/tandem-c/api.html) | Native, SIMD fills | OpenMP target | CPU and target fills | CPU and target fills | — |
| [Rust](https://tandem-rng.github.io/tandem-rs/api.html) | Native, SIMD and Rayon fills | Optional wgpu word fills | CPU | CPU | The wgpu interface fills raw words, not floating-point arrays. |
| [NumPy](https://tandem-rng.github.io/tandem-numpy/api.html) | C-backed arrays | — | CPU | CPU | NumPy's own samplers can differ from Tandem's. Use `TandemGenerator` for Tandem's distribution draws. |
| [CUDA](https://tandem-rng.github.io/tandem-cuda/api.html) | Portable C++ core | CUDA | CPU core and GPU | CPU core and GPU | GPU Float32 normal tolerance: 16 ulps + 2.1e-6. |
| [JAX](https://tandem-rng.github.io/tandem-jax/api.html) | JAX, optional C fills | JAX backends, optional CUDA kernels | CPU and GPU | CPU and GPU with x64 enabled | Use Tandem's mappings for cross-port draws. `jax.random` can use different mappings and samplers. |
| [R](https://tandem-rng.github.io/tandem-r/api.html) | C-backed vectors | — | CPU, stored as doubles | CPU | Large seeds and positions need decimal strings. The base R hook retains R's exponential sampler. |
| [PyTorch](https://tandem-rng.github.io/tandem-torch/api.html) | C-backed tensors | Optional CUDA extension | CPU and CUDA | CPU and CUDA | This port supplies tensors, not a `torch.Generator`. |
| [WebGPU / JavaScript](https://tandem-rng.github.io/tandem-webgpu/api.html) | JavaScript / TypeScript | WebGPU | CPU and GPU | CPU conversion | WGSL has no Float64 arithmetic. GPU normals and exponentials use documented tolerances. |
| [Fortran](https://tandem-rng.github.io/tandem-fortran/api.html) | C bindings | CUDA, CUDA Fortran, OpenMP target, `do concurrent` | CPU and GPU | CPU and GPU | GPU modules use separate toolchains and builds from the CPU fpm package. |
| [Kokkos](https://tandem-rng.github.io/tandem-kokkos/api.html) | Kokkos host backends | Kokkos device backends | CPU and GPU | CPU and GPU | — |
| [Java](https://tandem-rng.github.io/tandem-java/gpu.html) | Native Java, optional C fills | Optional CUDA module via FFM | CPU and CUDA | CPU and CUDA | The GPU module needs compute capability 8.0 or later. |
| [Mojo](https://tandem-rng.github.io/tandem-mojo/api.html) | Native, SIMD fills | MAX GPU fills | CPU and GPU | CPU and GPU | Prototype. GPU fills take whole rows and do not advance a generator's position. |
| [SYCL](https://tandem-rng.github.io/tandem-sycl/api.html) | SYCL CPU devices | SYCL GPU devices | CPU and GPU | CPU and GPU | — |
| [Metal / Swift](https://tandem-rng.github.io/tandem-metal/api.html) | Swift | Metal | CPU and GPU | CPU | Metal has no Float64 arithmetic. Float64 uniforms, normals, and exponentials run on the CPU. |
| [MLX](https://tandem-rng.github.io/tandem-mlx/api.html) | Float64 uniform conversion | Metal on Apple silicon | GPU | CPU conversion for uniforms | Float64 normals and exponentials raise. |
| [Haskell](https://tandem-rng.github.io/tandem-hs/api.html) | Pure Haskell, optional C fills | — | CPU | CPU | — |
| [OCaml](https://tandem-rng.github.io/tandem-ml/api.html) | Pure OCaml, C fills | — | Not supported | CPU | Give each concurrent domain its own generator. |

For exact distribution rules, use the port's API and Design pages and the [specification](https://github.com/tandem-rng/spec/blob/main/SPEC.md).
For measured throughput, use each port's Performance page and the [benchmark overview](https://tandem-rng.github.io/#bench).

[All ports and docs](https://github.com/tandem-rng/.github/blob/main/profile/README.md) · [Website](https://tandem-rng.github.io/) · [Specification](https://github.com/tandem-rng/spec/blob/main/SPEC.md)
