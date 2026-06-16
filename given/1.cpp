#include <fstream>
#include <iostream>

#include "prime/early_ones.hpp"
#include "prime/input.hpp"

int main(int argc, char *argv[]) {
  std::ifstream in(argv[1]);
  const int iter = prime::read_test_count(in);
  for (int case_idx = 0; case_idx < iter; ++case_idx) {
    const prime::ModulusConfig cfg = prime::read_modulus_config(in);
    const double threshold = prime::ones_threshold(cfg.prime, cfg.mod);
    prime::scan_early_one_exceeds(cfg.prime, cfg.mod, cfg.period(), threshold,
                                  case_idx);
    std::cout << "iteration " << case_idx << " done\n";
  }
  return 0;
}
