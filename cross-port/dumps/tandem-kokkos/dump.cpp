// The four streams of cross-port/README.md from tandem-kokkos on the default host backend:
//   dump OUT
#include <Kokkos_Core.hpp>
#include <tandem/kokkos.hpp>

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

template <class T> using View = Kokkos::View<T *, Kokkos::HostSpace>;

template <class T> void put(std::FILE *f, const View<T> &v) { std::fwrite(v.data(), sizeof(T), v.size(), f); }

} // namespace

int main(int argc, char **argv) {
    if (argc != 2) {
        std::fprintf(stderr, "usage: %s OUT\n", argv[0]);
        return 2;
    }
    Kokkos::ScopeGuard guard(argc, argv);
    const std::string out = argv[1];
    auto open = [&](const char *name) { return std::fopen((out + "/" + name).c_str(), "wb"); };
    std::FILE *uniform = open("uniform.bin"), *bounded = open("bounded.bin"), *normal = open("normal.bin"),
              *exponential = open("exponential.bin");
    if (!uniform || !bounded || !normal || !exponential)
        return 1;
    View<uint32_t> u("u", N);
    View<double> d("d", N);
    View<float> f("f", N);
    for (uint64_t s : starts) {
        tandem::Rng r = at(s);
        tandem::fill(u, r);
        put(uniform, u);
        tandem::fill(d, r);
        put(uniform, d);

        r = at(s);
        tandem::fill_below(u, r, 1000u);
        put(bounded, u);
        tandem::fill_below(u, r, 3221225473u);
        put(bounded, u);

        r = at(s);
        tandem::fill_normal(d, r);
        put(normal, d);

        r = at(s);
        tandem::fill_exponential(d, r);
        put(exponential, d);
        tandem::fill_exponential(f, r);
        put(exponential, f);
    }
    return std::fclose(uniform) | std::fclose(bounded) | std::fclose(normal) | std::fclose(exponential);
}
