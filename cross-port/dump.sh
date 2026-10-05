#!/usr/bin/env bash
# Builds one port's dumps and writes its streams into OUT. See README.md.
#   dump.sh PORT CHECKOUT OUT [VARIANT]
# The toolchains come from the workflow's setup steps.
set -euo pipefail

port=$1
src=$(realpath "$2")
mkdir -p "$3"
out=$(realpath "$3")
variant=${4:-}
here=$(dirname "$(realpath "$0")")
dumps=$here/dumps

case $port in
tandem-c)
    cd "$src"
    flags=(-std=c23 -O2 -ffp-contract=off -Wall -Wextra -Werror -I.)
    for t in dump_normals dump_exponentials; do
        "$CC" "${flags[@]}" -o "/tmp/$t" "tools/$t.c" tandem.c -lm
    done
    "$CC" "${flags[@]}" -o /tmp/reference "$here/reference.c" tandem.c -lm
    /tmp/reference "$out"
    /tmp/dump_normals > "$out/normal.bin"
    /tmp/dump_exponentials > "$out/exponential.bin"
    ;;
TandemRNG.jl)
    julia --project="$src" -e 'using Pkg; Pkg.instantiate()'
    julia --project="$src" "$dumps/TandemRNG.jl" "$out"
    ;;
tandem-rs)
    cp "$dumps/tandem-rs/cross_uniform.rs" "$src/examples/"
    cd "$src"
    cargo build --release --examples
    cargo run --release --example cross_uniform -- "$out"
    cargo run --release --example dump_normals > "$out/normal.bin"
    cargo run --release --example dump_exponentials > "$out/exponential.bin"
    ;;
tandem-numpy | tandem-jax)
    pip install "$src"
    python "$dumps/$port.py" "$out"
    ;;
tandem-torch)
    pip install torch numpy --index-url https://download.pytorch.org/whl/cpu
    pip install --no-build-isolation "$src"
    python "$dumps/tandem-torch.py" "$out"
    ;;
tandem-r)
    lib=$(mktemp -d)
    R CMD INSTALL -l "$lib" "$src"
    R_LIBS="$lib" Rscript "$dumps/tandem-r.R" "$out"
    ;;
tandem-webgpu)
    node "$dumps/tandem-webgpu.ts" "$src" "$out"
    ;;
tandem-fortran)
    cp "$dumps/tandem-fortran.f90" "$src/test/cross_dump.f90"
    cd "$src"
    fpm test cross_dump --profile release --c-flag "-ffp-contract=off" -- "$out"
    ;;
tandem-kokkos | tandem-sycl)
    # tandem-sycl builds with AdaptiveCpp's own clang.
    cxx=()
    [ "$port" = tandem-kokkos ] && cxx=(-DCMAKE_CXX_COMPILER=clang++)
    pixi run --manifest-path "$src/pixi.toml" cmake -S "$dumps/$port" -B /tmp/build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release -DPORT="$src" "${cxx[@]}"
    pixi run --manifest-path "$src/pixi.toml" cmake --build /tmp/build
    OMP_PROC_BIND=false pixi run --manifest-path "$src/pixi.toml" /tmp/build/dump "$out"
    ;;
tandem-java)
    (cd "$src" && mvn -B -q package -DskipTests)
    java -cp "$src/target/classes" "$dumps/TandemJava.java" "$out"
    ;;
tandem-mojo)
    cd "$src"
    pixi run mojo run -I . "$dumps/tandem-mojo.mojo" "$out"
    pixi run mojo run -I . tools/dump_normals.mojo "$out/normal.bin"
    ;;
tandem-metal)
    # Kernels.swift and Shader.swift need the Metal framework, the rest is the CPU path.
    swiftc -O "$src"/Sources/Tandem/{Tandem,Draws,Normal,ZigTables}.swift \
        "$dumps/tandem-metal/main.swift" -o /tmp/dump
    /tmp/dump "$out"
    ;;
tandem-hs)
    cp "$dumps/tandem-hs/CrossUniform.hs" "$src/tools/"
    cat >> "$src/tandem.cabal" << 'EOF'

executable cross-uniform
  import:         common
  hs-source-dirs: tools
  main-is:        CrossUniform.hs
  build-depends:  base, bytestring, filepath, tandem, vector
  ghc-options:    -O2
EOF
    cd "$src"
    cabal build -f tools exe:tandem-dump exe:cross-uniform
    "$(cabal list-bin -f tools exe:cross-uniform)" "$out"
    dump=$(cabal list-bin -f tools exe:tandem-dump)
    "$dump" normals > "$out/normal.bin"
    "$dump" exponentials > "$out/exponential.bin"
    ;;
tandem-ml)
    cp -r "$dumps/tandem-ml" "$src/cross_dump"
    cd "$src"
    opam install . --deps-only
    opam exec -- dune exec ./cross_dump/cross_dump.exe -- "$out" $variant
    ;;
*)
    echo "dump.sh: unknown port $port" >&2
    exit 2
    ;;
esac
