//! The uniform and bounded streams of cross-port/README.md. The workflow copies this file into
//! the port's examples/ and runs it with `cargo run --release --example cross_uniform -- OUT`.

use std::fs::File;
use std::io::{BufWriter, Write};
use std::path::Path;

use tandem_rng::Tandem;

const N: usize = 1_000_000;

fn at(start: u64) -> Tandem {
    let mut rng = Tandem::new(2026 | 7 << 64);
    rng.set_position(start);
    rng
}

fn main() {
    let dir = std::env::args().nth(1).expect("usage: cross_uniform OUT");
    let open = |name| BufWriter::new(File::create(Path::new(&dir).join(name)).unwrap());
    let (mut uniform, mut bounded) = (open("uniform.bin"), open("bounded.bin"));
    let mut u = vec![0u32; N];
    let mut d = vec![0f64; N];
    for start in [0u64, 1, 77, 12345, 1 << 30] {
        let mut rng = at(start);
        rng.fill_u32(&mut u);
        u.iter().for_each(|x| uniform.write_all(&x.to_le_bytes()).unwrap());
        rng.fill_f64(&mut d);
        d.iter().for_each(|x| uniform.write_all(&x.to_le_bytes()).unwrap());

        let mut rng = at(start);
        for bound in [1000, 3_221_225_473] {
            rng.fill_below_u32(&mut u, bound);
            u.iter().for_each(|x| bounded.write_all(&x.to_le_bytes()).unwrap());
        }
    }
}
