#include <fstream>
#include <iostream>

#include "prime/coverage.hpp"
#include "prime/crt/bitmasks.hpp"
#include "prime/input.hpp"

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  const int iter = prime::read_test_count(in);
  for (int case_idx = 0; case_idx < iter; ++case_idx) {
    const prime::ModulusConfig cfg = prime::read_modulus_config(in);
    const int total = cfg.period();
    const auto seq =
        prime::crt::build_residue_masks(cfg.prime, total);
    const auto acc = prime::crt::leading_zero_histogram(cfg.prime, cfg.mod, seq,
                                                        total);
    prime::check_moment_budget(acc, total, cfg.prime, cfg.mod, case_idx);
    std::cout << "iteration " << case_idx << " completed\n";
  }
  return 0;
}
