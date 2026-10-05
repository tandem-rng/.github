"""The four streams of cross-port/README.md from tandem-torch on the CPU: python tandem-torch.py OUT"""

import sys
from pathlib import Path

import tandem_torch as tt
import torch

N = 1_000_000
STARTS = (0, 1, 77, 12345, 1 << 30)
KEY = tt.Tandem(2026 + (7 << 64)).key


def write(f, t):
    f.write(t.numpy().tobytes())


out = Path(sys.argv[1])
with open(out / "uniform.bin", "wb") as f:
    for s in STARTS:
        u, p = tt.bits(KEY, s, N, dtype=torch.uint32)
        write(f, u)
        write(f, tt.rand(KEY, p, N)[0])
with open(out / "bounded.bin", "wb") as f:
    for s in STARTS:
        b, p = tt.randint(KEY, s, 0, 1000, N, dtype=torch.uint32)
        write(f, b)
        write(f, tt.randint(KEY, p, 0, 3221225473, N, dtype=torch.uint32)[0])
with open(out / "normal.bin", "wb") as f:
    for s in STARTS:
        write(f, tt.randn(KEY, s, N)[0])
with open(out / "exponential.bin", "wb") as f:
    for s in STARTS:
        e, p = tt.exponential(KEY, s, N)
        write(f, e)
        write(f, tt.exponential(KEY, p, N, dtype=torch.float32)[0])
