"""The streams of cross-port/README.md from tandem-jax on the XLA CPU path: python tandem-jax.py OUT
tandem-jax has no exponential fill, so exponential.bin is absent."""

import sys
from pathlib import Path

import jax

jax.config.update("jax_enable_x64", True)

import jax.numpy as jnp  # noqa: E402
import numpy as np  # noqa: E402
import tandem_jax as tj  # noqa: E402

N = 1_000_000
STARTS = (0, 1, 77, 12345, 1 << 30)
KEY = jax.random.wrap_key_data(tj.whiten(2026, 7), impl=tj.impl)


def write(f, x):
    f.write(np.asarray(x).tobytes())


out = Path(sys.argv[1])
with open(out / "uniform.bin", "wb") as f:
    for s in STARTS:
        u, p = tj.stream(KEY, s, N, jnp.uint32)
        write(f, u)
        write(f, tj.stream(KEY, p, N, jnp.float64)[0])
with open(out / "bounded.bin", "wb") as f:
    for s in STARTS:
        b, p = tj.stream_randint(KEY, s, N, 0, 1000, jnp.uint32)
        write(f, b)
        write(f, tj.stream_randint(KEY, p, N, 0, 3221225473, jnp.uint32)[0])
with open(out / "normal.bin", "wb") as f:
    for s in STARTS:
        write(f, tj.stream_normal(KEY, s, N, jnp.float64)[0])
