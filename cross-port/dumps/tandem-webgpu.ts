// The four streams of cross-port/README.md from tandem-webgpu's CPU path:
//   node tandem-webgpu.ts PORT OUT
import { writeFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { pathToFileURL } from "node:url";

const [port, out] = process.argv.slice(2);
const { seed, Tandem } = await import(pathToFileURL(resolve(port, "src/mod.ts")).href);

const N = 1_000_000;
const STARTS = [0n, 1n, 77n, 12345n, 1n << 30n];
const KEY = seed(2026n + (7n << 64n));
const at = (position: bigint) => new Tandem(KEY, { position });

function save(name: string, fill: (start: bigint) => ArrayBufferView[]) {
  const parts = STARTS.flatMap(fill).map((a) => new Uint8Array(a.buffer, a.byteOffset, a.byteLength));
  writeFileSync(join(out, name), Buffer.concat(parts));
}

save("uniform.bin", (s) => {
  const g = at(s);
  return [g.fillU32(N), g.fillF64(N)];
});
save("bounded.bin", (s) => {
  const g = at(s);
  return [g.fillU32Below(N, 1000), g.fillU32Below(N, 3221225473)];
});
save("normal.bin", (s) => [at(s).fillNormalF64(N)]);
save("exponential.bin", (s) => {
  const g = at(s);
  return [g.fillExponentialF64(N), g.fillExponentialF32(N)];
});
