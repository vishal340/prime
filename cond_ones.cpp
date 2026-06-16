#include <fstream>
#include <iostream>

#include "prime/coverage.hpp"
#include "prime/crt/residue_enum.hpp"
#include "prime/input.hpp"

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  const int cases = prime::read_test_count(in);
  for (int case_idx = 0; case_idx < cases; ++case_idx) {
    const prime::ModulusConfig cfg = prime::read_modulus_config(in);
    out << prime::expected_gap_log(cfg.prime, cfg.mod) << '\t';
    out << prime::crt::max_consecutive_ones_prefix(cfg.prime, cfg.mod) << '\n';
  }
  return 0;
}
