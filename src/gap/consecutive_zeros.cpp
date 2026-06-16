/**
 * @file consecutive_zeros.cpp
 * @brief Maximum consecutive ZERO prefix before the first ONE.
 */

#include <cstdint>
#include <fstream>
#include <iostream>

#include "prime/coverage.hpp"
#include "prime/crt/residue_enum.hpp"
#include "prime/input.hpp"

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  const int iter = prime::read_test_count(in);
  for (int case_idx = 0; case_idx < iter; ++case_idx) {
    const prime::ModulusConfig cfg = prime::read_modulus_config(in);
    out << prime::expected_gap_log(cfg.prime, cfg.mod) << '\t';
    const int max_zero =
        prime::crt::max_consecutive_ones_prefix(cfg.prime, cfg.mod);
    out << max_zero << '\t';

    int64_t cumulative_pairs = 1;
    for (int p : cfg.prime)
      cumulative_pairs *= static_cast<int64_t>(p) * (p - 1) / 2;

    int covered_classes = 1;
    int total_space = 1;
    for (std::size_t i = 0; i < cfg.prime.size(); ++i) {
      covered_classes *= cfg.prime[i] - cfg.mod[i];
      total_space *= cfg.prime[i];
    }

    const int uncovered_space = total_space - max_zero;
    long double gap_ratio = 1.0;
    for (int i = 0; i < covered_classes; ++i)
      gap_ratio *= static_cast<long double>(total_space - i) /
                   static_cast<long double>(uncovered_space - i);
    out << cumulative_pairs / gap_ratio << '\n';
  }
  return 0;
}
