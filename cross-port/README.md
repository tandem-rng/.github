# Cross-port streams

The workflow `.github/workflows/cross-port.yml` runs every night and on `gh workflow run cross-port.yml`.
It checks out the main branch of tandem-c and of every port, dumps the same streams from each, and fails a port whose SHA-256 differs from tandem-c's.
Each port is one matrix entry, so a failure names the port.
The run summary lists every stream and the paths that a runner without a GPU skips (`skipped.md`).

## Streams

Every stream starts from seed (2026, 7), at bit positions 0, 1, 77, 12345 and 2^30, with one generator per start.
The bytes are little-endian, N = 10^6.

| file | per start |
| --- | --- |
| `uniform.bin` | N u32, then N f64 uniforms |
| `bounded.bin` | N u32 below 1000, then N u32 below 3221225473 |
| `normal.bin` | N f64 normals, as tandem-c's `tools/dump_normals.c` |
| `exponential.bin` | N f64, then N f32 exponentials, as tandem-c's `tools/dump_exponentials.c` |
| `exponential-f64.bin` | N f64 exponentials, for ports without f32 exponentials |

`reference.c` writes the streams that tandem-c's own dump tools do not.

## Add a port

1. Write a dump in `dumps/` that writes the streams of the port into the directory it gets as an argument.
   Reuse a dump tool of the port where one exists, as tandem-rs, tandem-hs and tandem-mojo do.
2. Add a branch for the port to `dump.sh`, which builds the dump and runs it.
3. Add a matrix entry to the workflow.
   `kinds` lists the streams the port writes, and `toolchain` selects a setup step.
   Add a setup step if no existing one fits, at the latest stable toolchain.
4. List any GPU path the runner cannot check in `skipped.md`.
5. Run the workflow once with `gh workflow run cross-port.yml` and check that the new entry passes.
