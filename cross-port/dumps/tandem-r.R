# The streams of cross-port/README.md from tandem-r: Rscript tandem-r.R OUT
# tandem-r has no float32 exponentials, so it writes exponential-f64.bin, not exponential.bin.
library(tandemrng)

n <- 1e6
starts <- c(0, 1, 77, 12345, 2^30)
out <- commandArgs(trailingOnly = TRUE)[1]

at <- function(start) {
  rng <- tandem("129127208515966863338") # 2026 + 7 * 2^64
  tandem_set_position(rng, start)
  rng
}

# R integers are signed 32-bit, so words from 2^31 on wrap to their two's complement value.
u32 <- function(x) as.integer(ifelse(x >= 2^31, x - 2^32, x))

save <- function(name, fill) {
  con <- file(file.path(out, name), "wb")
  for (s in starts) fill(con, at(s))
  close(con)
}

save("uniform.bin", function(con, rng) {
  writeBin(u32(tandem_rbits(rng, n, 32)), con, size = 4, endian = "little")
  writeBin(tandem_runif(rng, n), con, size = 8, endian = "little")
})
save("bounded.bin", function(con, rng) {
  writeBin(u32(tandem_below(rng, n, 1000)), con, size = 4, endian = "little")
  writeBin(u32(tandem_below(rng, n, 3221225473)), con, size = 4, endian = "little")
})
save("normal.bin", function(con, rng) writeBin(tandem_rnorm(rng, n), con, size = 8, endian = "little"))
save("exponential-f64.bin", function(con, rng) writeBin(tandem_rexp(rng, n), con, size = 8, endian = "little"))
