#include <fstream>
#include <iostream>

#include "prime/coverage.hpp"
#include "prime/crt/bitmasks.hpp"
#include "prime/input.hpp"

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  const int iter = prime::read_test_count(in);
  for (int case_idx = 0; case_idx < iter; ++case_idx) {
    int total = 0;
    int iter_mod = 0;
    const std::vector<int> primes = prime::read_primes_only(in, total, iter_mod);
    const auto seq = prime::crt::build_residue_masks(primes, total);
    for (int variant = 0; variant < iter_mod; ++variant) {
      const std::vector<int> mods = prime::derived_mods(primes, variant);
      const auto acc =
          prime::crt::leading_zero_histogram(primes, mods, seq, total);
      prime::check_moment_budget(acc, total, primes, mods, case_idx, variant);
    }
    std::cout << "iteration " << case_idx << " completed\n";
  }
  return 0;
}
