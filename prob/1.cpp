#include <fstream>
#include <iostream>

#include "prime/crt/bitmasks.hpp"
#include "prime/input.hpp"

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  const int iter = prime::read_test_count(in);
  out << iter << '\n';
  for (int case_idx = 0; case_idx < iter; ++case_idx) {
    const prime::ModulusConfig cfg = prime::read_modulus_config(in);
    const int total = cfg.period();
    const auto seq =
        prime::crt::build_residue_masks(cfg.prime, total);
    const auto acc = prime::crt::leading_zero_histogram(cfg.prime, cfg.mod, seq,
                                                        total);
    prime::crt::write_histogram(out, acc, total,
                                prime::product_binomial_u64(cfg.prime, cfg.mod));
  }
  return 0;
}
