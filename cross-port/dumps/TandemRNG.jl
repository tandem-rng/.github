# The four streams of cross-port/README.md from TandemRNG.jl:
#   julia --project=<port> TandemRNG.jl OUT
using TandemRNG

const N = 1_000_000
const STARTS = (0, 1, 77, 12345, 1 << 30)
const KEY = rngkey(Tandem8x32(2026 + UInt128(7) << 64))
const OUT = ARGS[1]

function save(fill, name)
    open(joinpath(OUT, name), "w") do io
        foreach(s -> fill(io, Tandem8x32(KEY, s)), STARTS)
    end
end

u = Vector{UInt32}(undef, N)
d = Vector{Float64}(undef, N)
f = Vector{Float32}(undef, N)
save("uniform.bin") do io, rng
    rng = rand_fill!(rng, u)
    write(io, u)
    rand_fill!(rng, d)
    write(io, d)
end
save("bounded.bin") do io, rng
    rng = rand_below_fill!(rng, u, UInt32(1000))
    write(io, u)
    rand_below_fill!(rng, u, UInt32(3221225473))
    write(io, u)
end
save("normal.bin") do io, rng
    normal_fill!(rng, d)
    write(io, d)
end
save("exponential.bin") do io, rng
    rng = exponential_fill!(rng, d)
    write(io, d)
    exponential_fill!(rng, f)
    write(io, f)
end
