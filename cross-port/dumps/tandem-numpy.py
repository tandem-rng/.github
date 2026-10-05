"""The four streams of cross-port/README.md from tandem-numpy: python numpy.py OUT"""

import sys
from pathlib import Path

import numpy as np
from tandem_rng import Tandem

N = 1_000_000
STARTS = (0, 1, 77, 12345, 1 << 30)


def at(start):
    g = Tandem(2026 + (7 << 64))
    g.position = start
    return g


out = Path(sys.argv[1])
with open(out / "uniform.bin", "wb") as f:
    for s in STARTS:
        g = at(s)
        f.write(g.raw(N, np.uint32).tobytes())
        f.write(g.random(N).tobytes())
with open(out / "bounded.bin", "wb") as f:
    for s in STARTS:
        g = at(s)
        f.write(g.below(1000, N, np.uint32).tobytes())
        f.write(g.below(3221225473, N, np.uint32).tobytes())
with open(out / "normal.bin", "wb") as f:
    for s in STARTS:
        f.write(at(s).normal(N).tobytes())
with open(out / "exponential.bin", "wb") as f:
    for s in STARTS:
        g = at(s)
        f.write(g.exponential(N).tobytes())
        f.write(g.exponential(N, np.float32).tobytes())
