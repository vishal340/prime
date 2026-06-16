#ifndef PRIME_INPUT_HPP
#define PRIME_INPUT_HPP

#include <istream>
#include <vector>

namespace prime {

struct ModulusConfig {
  std::vector<int> prime;
  std::vector<int> mod;

  int count() const { return static_cast<int>(prime.size()); }

  int period() const {
    int total = 1;
    for (int p : prime)
      total *= p;
    return total;
  }
};

inline int read_test_count(std::istream &in) {
  int iter = 0;
  in >> iter;
  return iter;
}

inline ModulusConfig read_modulus_config(std::istream &in) {
  ModulusConfig cfg;
  int number = 0;
  in >> number;
  cfg.prime.resize(number);
  cfg.mod.resize(number);
  for (int i = 0; i < number; ++i)
    in >> cfg.prime[i] >> cfg.mod[i];
  return cfg;
}

inline std::vector<int> read_primes_only(std::istream &in, int &total,
                                         int &iter_mod) {
  int number = 0;
  in >> number;
  std::vector<int> primes(number);
  total = 1;
  iter_mod = 1;
  for (int i = 0; i < number; ++i) {
    in >> primes[i];
    total *= primes[i];
    iter_mod *= primes[i] - 2;
  }
  return primes;
}

inline std::vector<int> derived_mods(const std::vector<int> &primes, int it) {
  std::vector<int> mods(primes.size());
  for (std::size_t i = 0; i < primes.size(); ++i)
    mods[i] = 2 + (it % (primes[i] - 2));
  return mods;
}

} // namespace prime

#endif
