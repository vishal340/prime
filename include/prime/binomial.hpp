#ifndef PRIME_BINOMIAL_HPP
#define PRIME_BINOMIAL_HPP

#include <cstdint>
#include <vector>

namespace prime {

inline uint64_t binomial_u64(int n, int k) {
  if (k < 0 || k > n)
    return 0;
  if (k == 0 || k == n)
    return 1;
  if (k > n - k)
    k = n - k;
  uint64_t result = 1;
  for (int j = 1; j <= k; ++j) {
    result *= static_cast<uint64_t>(n - j + 1);
    result /= static_cast<uint64_t>(j);
  }
  return result;
}

inline uint64_t product_binomial_u64(const std::vector<int> &primes,
                                     const std::vector<int> &mods) {
  uint64_t perm = 1;
  for (std::size_t i = 0; i < primes.size(); ++i)
    perm *= binomial_u64(primes[i], mods[i]);
  return perm;
}

inline long double product_binomial_ld(const std::vector<int> &primes,
                                       const std::vector<int> &mods) {
  long double total = 1.0;
  for (std::size_t i = 0; i < primes.size(); ++i) {
    for (int j = 0; j < mods[i]; ++j)
      total *= primes[i] - j;
    for (int j = 1; j <= mods[i]; ++j)
      total /= j;
  }
  return total;
}

} // namespace prime

#endif
