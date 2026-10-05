/* The streams of cross-port/README.md that tandem-c's tools/dump_normals.c and
 * tools/dump_exponentials.c do not write, as raw little-endian bytes:
 *   reference OUT
 * From seed (2026, 7) at each start, one generator per stream writes
 *   uniform.bin:         N u32, then N f64
 *   bounded.bin:         N u32 below 1000, then N u32 below 3221225473
 *   exponential-f64.bin: N f64 exponentials, the f64 half of dump_exponentials, for ports
 *                        without f32 exponentials */
#include <stdio.h>
#include <stdlib.h>

#include "tandem.h"

enum { N = 1000000 };
static const uint64_t starts[] = {0, 1, 77, 12345, 1u << 30};

static FILE *open_out(const char *dir, const char *name) {
    char path[4096];
    snprintf(path, sizeof path, "%s/%s", dir, name);
    FILE *f = fopen(path, "wb");
    if (!f) {
        perror(path);
        exit(1);
    }
    return f;
}

static tandem_rng at(uint64_t start) {
    tandem_rng g = tandem_seed(2026, 7, 0);
    tandem_set_position(&g, start);
    return g;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s OUT\n", argv[0]);
        return 2;
    }
    FILE *uniform = open_out(argv[1], "uniform.bin"), *bounded = open_out(argv[1], "bounded.bin"),
         *exponential = open_out(argv[1], "exponential-f64.bin");
    uint32_t *u = malloc(N * sizeof *u);
    double *d = malloc(N * sizeof *d);
    if (!u || !d)
        return 1;
    for (size_t i = 0; i < sizeof starts / sizeof starts[0]; i++) {
        tandem_rng g = at(starts[i]);
        tandem_fill_u32(&g, u, N);
        fwrite(u, sizeof *u, N, uniform);
        tandem_fill_f64(&g, d, N);
        fwrite(d, sizeof *d, N, uniform);

        g = at(starts[i]);
        tandem_fill_u32_below(&g, u, N, 1000);
        fwrite(u, sizeof *u, N, bounded);
        tandem_fill_u32_below(&g, u, N, 3221225473u);
        fwrite(u, sizeof *u, N, bounded);

        g = at(starts[i]);
        tandem_fill_exponential_f64(&g, d, N);
        fwrite(d, sizeof *d, N, exponential);
    }
    free(u);
    free(d);
    return fclose(uniform) | fclose(bounded) | fclose(exponential);
}
