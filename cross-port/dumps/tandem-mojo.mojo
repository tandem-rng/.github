# The uniform, bounded and exponential streams of cross-port/README.md from tandem-mojo. The
# port's tools/dump_normals.mojo gives the normals. From the port's directory:
#   mojo run -I . tandem-mojo.mojo OUT
from std.memory.alloc import unsafe_alloc
from std.sys import argv

from tandem import Tandem

comptime N = 1000000


def at(s: UInt64) raises -> Tandem:
    var g = Tandem(UInt128(2026) | (UInt128(7) << 64))
    g.set_position(s)
    return g^


def main() raises:
    var starts: List[UInt64] = [0, 1, 77, 12345, 1 << 30]
    var out = String(argv()[1])
    var u = unsafe_alloc[UInt32](N)
    var d = unsafe_alloc[Float64](N)
    var f = unsafe_alloc[Float32](N)
    with open(out + "/uniform.bin", "w") as file:
        for s in starts:
            var g = at(s)
            g.fill_u32(u, N)
            file.write_bytes(Span(unsafe_ptr=u.unsafe_bitcast[UInt8](), length=N * 4))
            g.fill_f64(d, N)
            file.write_bytes(Span(unsafe_ptr=d.unsafe_bitcast[UInt8](), length=N * 8))
    with open(out + "/bounded.bin", "w") as file:
        for s in starts:
            var g = at(s)
            g.fill_below_u32(u, N, 1000)
            file.write_bytes(Span(unsafe_ptr=u.unsafe_bitcast[UInt8](), length=N * 4))
            g.fill_below_u32(u, N, 3221225473)
            file.write_bytes(Span(unsafe_ptr=u.unsafe_bitcast[UInt8](), length=N * 4))
    with open(out + "/exponential.bin", "w") as file:
        for s in starts:
            var g = at(s)
            g.fill_exponential_f64(d, N)
            file.write_bytes(Span(unsafe_ptr=d.unsafe_bitcast[UInt8](), length=N * 8))
            g.fill_exponential_f32(f, N)
            file.write_bytes(Span(unsafe_ptr=f.unsafe_bitcast[UInt8](), length=N * 4))
    u.unsafe_free()
    d.unsafe_free()
    f.unsafe_free()
