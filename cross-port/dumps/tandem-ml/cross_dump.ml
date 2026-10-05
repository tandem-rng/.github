(* The streams of cross-port/README.md from tandem-ml. tandem-ml has no float32 exponentials, so
   it writes exponential-f64.bin, not exponential.bin. The workflow copies this directory into
   the port and runs: dune exec ./cross_dump/cross_dump.exe -- OUT [pure]
   With [pure] the fills are the OCaml ones, else those of the vendored tandem.c. *)

open Bigarray

let n = 1_000_000
let starts = [ 0; 1; 77; 12345; 1 lsl 30 ]
let at s = Tandem.seek (Tandem.seed_u128 2026L 7L) (Int64.of_int s)

let () =
  let out = Sys.argv.(1) in
  let pure = Array.length Sys.argv > 2 && Sys.argv.(2) = "pure" in
  let fill_u32, fill_float, fill_below32, fill_normal, fill_exponential =
    if pure then
      Tandem.Pure.(fill_u32, fill_float, fill_below32, fill_normal, fill_exponential)
    else Tandem.(fill_u32, fill_float, fill_below32, fill_normal, fill_exponential)
  in
  let u = Array1.create int32 c_layout n and d = Array1.create float64 c_layout n in
  let save name fill =
    let oc = open_out_bin (Filename.concat out name) in
    List.iter (fun s -> fill oc (at s)) starts;
    close_out oc
  in
  let put_u32 oc =
    let b = Bytes.create (4 * n) in
    for i = 0 to n - 1 do
      Bytes.set_int32_le b (4 * i) u.{i}
    done;
    output_bytes oc b
  in
  let put_f64 oc =
    let b = Bytes.create (8 * n) in
    for i = 0 to n - 1 do
      Bytes.set_int64_le b (8 * i) (Int64.bits_of_float d.{i})
    done;
    output_bytes oc b
  in
  save "uniform.bin" (fun oc g ->
      let g = fill_u32 g u in
      put_u32 oc;
      ignore (fill_float g d);
      put_f64 oc);
  save "bounded.bin" (fun oc g ->
      let g = fill_below32 g ~range:1000 u in
      put_u32 oc;
      ignore (fill_below32 g ~range:3221225473 u);
      put_u32 oc);
  save "normal.bin" (fun oc g ->
      ignore (fill_normal g d);
      put_f64 oc);
  save "exponential-f64.bin" (fun oc g ->
      ignore (fill_exponential g d);
      put_f64 oc)
