// The four streams of cross-port/README.md from tandem-metal's CPU path, compiled together with
// its sources minus the Metal kernels, which Linux lacks:
//   swiftc -O <port>/Sources/Tandem/{Tandem,Draws,Normal,ZigTables}.swift main.swift -o dump
//   ./dump OUT
import Foundation

let n = 1_000_000
let starts: [UInt64] = [0, 1, 77, 12345, 1 << 30]
let out = CommandLine.arguments[1]

func at(_ start: UInt64) -> Tandem {
    var g = Tandem(seed: 2026 | 7 << 64)
    g.position = start
    return g
}

func write(_ name: String, _ fill: (UInt64) -> Data) {
    var data = Data()
    for s in starts { data.append(fill(s)) }
    try! data.write(to: URL(fileURLWithPath: out).appendingPathComponent(name))
}

func bytes<T>(_ a: [T]) -> Data { a.withUnsafeBytes { Data($0) } }

write("uniform.bin") { s in
    var g = at(s), u = [UInt32](repeating: 0, count: n), d = [Double](repeating: 0, count: n)
    g.fillU32(&u)
    g.fillF64(&d)
    return bytes(u) + bytes(d)
}
write("bounded.bin") { s in
    var g = at(s), a = [UInt32](repeating: 0, count: n), b = [UInt32](repeating: 0, count: n)
    g.fillU32(&a, below: 1000)
    g.fillU32(&b, below: 3_221_225_473)
    return bytes(a) + bytes(b)
}
write("normal.bin") { s in
    var g = at(s), d = [Double](repeating: 0, count: n)
    g.fillNormalF64(&d)
    return bytes(d)
}
write("exponential.bin") { s in
    var g = at(s), d = [Double](repeating: 0, count: n), f = [Float](repeating: 0, count: n)
    g.fillExponentialF64(&d)
    g.fillExponentialF32(&f)
    return bytes(d) + bytes(f)
}
