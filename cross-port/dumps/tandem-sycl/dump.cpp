// The four streams of cross-port/README.md from tandem-sycl on the default device, which is the
// CPU on a runner: dump OUT
#include <tandem/sycl.hpp>

#include <cstdint>
#include <cstdio>
#include <string>

namespace {

constexpr size_t N = 1000000;
constexpr uint64_t starts[] = {0, 1, 77, 12345, 1ull << 30};

tandem::Rng at(uint64_t start) {
    tandem::Rng r(2026, 7, 0);
    r.set_position(start);
    return r;
}

} // namespace

int main(int argc, char **argv) {
    if (argc != 2) {
        std::fprintf(stderr, "usage: %s OUT\n", argv[0]);
        return 2;
    }
    sycl::queue q;
    std::printf("device: %s\n", q.get_device().get_info<sycl::info::device::name>().c_str());
    const std::string out = argv[1];
    auto open = [&](const char *name) { return std::fopen((out + "/" + name).c_str(), "wb"); };
    std::FILE *uniform = open("uniform.bin"), *bounded = open("bounded.bin"), *normal = open("normal.bin"),
              *exponential = open("exponential.bin");
    auto *u = sycl::malloc_shared<uint32_t>(N, q);
    auto *d = sycl::malloc_shared<double>(N, q);
    auto *f = sycl::malloc_shared<float>(N, q);
    if (!uniform || !bounded || !normal || !exponential || !u || !d || !f)
        return 1;
    for (uint64_t s : starts) {
        tandem::Rng r = at(s);
        tandem::fill(q, u, N, r).wait();
        std::fwrite(u, sizeof *u, N, uniform);
        tandem::fill(q, d, N, r).wait();
        std::fwrite(d, sizeof *d, N, uniform);

        r = at(s);
        tandem::fill_below(q, u, N, r, 1000u).wait();
        std::fwrite(u, sizeof *u, N, bounded);
        tandem::fill_below(q, u, N, r, 3221225473u).wait();
        std::fwrite(u, sizeof *u, N, bounded);

        r = at(s);
        tandem::fill_normal(q, d, N, r).wait();
        std::fwrite(d, sizeof *d, N, normal);

        r = at(s);
        tandem::fill_exponential(q, d, N, r).wait();
        std::fwrite(d, sizeof *d, N, exponential);
        tandem::fill_exponential(q, f, N, r).wait();
        std::fwrite(f, sizeof *f, N, exponential);
    }
    sycl::free(u, q);
    sycl::free(d, q);
    sycl::free(f, q);
    return std::fclose(uniform) | std::fclose(bounded) | std::fclose(normal) | std::fclose(exponential);
}
