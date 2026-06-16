#include <cstdlib>
#include <fstream>
#include <iostream>
#include <omp.h>
#include <vector>

#include "prime/early_ones.hpp"
#include "prime/input.hpp"

namespace {

int64_t gcd_int64(int64_t a, int64_t b) {
  a = a < 0 ? -a : a;
  b = b < 0 ? -b : b;
  while (b != 0) {
    const int64_t t = b;
    b = a % b;
    a = t;
  }
  return a;
}

int64_t lcm_pair(int64_t a, int64_t b) {
  if (a == 0 || b == 0)
    return 0;
  return a / gcd_int64(a, b) * b;
}

} // namespace

int main(int argc, char *argv[]) {
  std::ifstream in(argv[1]);
  const int iter = prime::read_test_count(in);
  const int chunk = std::max(1, std::atoi(argv[2]));
  for (int case_idx = 0; case_idx < iter; ++case_idx) {
    int total = 0;
    int iter_mod = 0;
    const std::vector<int> primes = prime::read_primes_only(in, total, iter_mod);
    int64_t lcm_total = primes[0];
    for (std::size_t i = 1; i < primes.size(); ++i)
      lcm_total = lcm_pair(lcm_total, primes[i]);

#pragma omp parallel for schedule(dynamic, chunk)
    for (int64_t variant = 0; variant < iter_mod; ++variant) {
      const std::vector<int> mods = prime::derived_mods(primes, static_cast<int>(variant));
      int ones = 1;
      for (int m : mods)
        ones *= m;
      const double threshold =
          static_cast<double>(ones) / static_cast<double>(lcm_total);
      double acc = 0.0;
      for (int64_t i = 1; i < lcm_total; ++i) {
        acc += prime::survival_weight(static_cast<int>(i), primes, mods);
        if (acc / static_cast<double>(i) > threshold) {
          std::cout << case_idx << ' ' << variant << ' ' << i << ' ' << acc / i
                    << ' ' << threshold << '\n';
          break;
        }
      }
    }
    std::cout << "iteration " << case_idx << " done\n";
  }
  return 0;
}
