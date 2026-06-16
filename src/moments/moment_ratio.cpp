#include <fstream>
#include <iostream>

#include "prime/coverage.hpp"
#include "prime/crt/bitmasks.hpp"
#include "prime/input.hpp"

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  int iter = prime::read_test_count(in);
  while (iter-- > 0) {
    int total = 0;
    int iter_mod = 0;
    const std::vector<int> primes = prime::read_primes_only(in, total, iter_mod);
    const auto seq = prime::crt::build_residue_masks(primes, total);
    for (int variant = 0; variant < iter_mod; ++variant) {
      const std::vector<int> mods = prime::derived_mods(primes, variant);
      const auto acc =
          prime::crt::leading_zero_histogram(primes, mods, seq, total);

      long double hit = 1.0;
      for (std::size_t i = 0; i < primes.size(); ++i)
        hit *= static_cast<long double>(mods[i]) /
               static_cast<long double>(primes[i]);
      const long double threshold = 1.0 - hit;

      for (int i = 1; i < total; ++i) {
        if (static_cast<long double>(acc[i]) /
                static_cast<long double>(acc[i - 1]) >
            threshold) {
          std::cout << iter << ' '
                    << static_cast<long double>(acc[i]) /
                           static_cast<long double>(acc[i - 1])
                    << ' ' << threshold << ' ' << i << '\n';
          for (int m : mods)
            std::cout << m << ' ';
          std::cout << '\n';
          break;
        }
      }
    }
    std::cout << "iteration " << iter << " completed\n";
  }
  return 0;
}
