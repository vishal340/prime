#ifndef PRIME_EARLY_ONES_HPP
#define PRIME_EARLY_ONES_HPP

#include <algorithm>
#include <cstdint>
#include <iostream>
#include <vector>

namespace prime {

inline double ones_threshold(const std::vector<int> &primes,
                             const std::vector<int> &mods) {
  int ones = 1;
  int64_t total = 1;
  for (std::size_t i = 0; i < primes.size(); ++i) {
    total *= primes[i];
    ones *= mods[i];
  }
  --ones;
  return static_cast<double>(ones) / static_cast<double>(total - 1);
}

inline double survival_weight(int i, const std::vector<int> &primes,
                              const std::vector<int> &mods) {
  double cur = 1.0;
  for (std::size_t j = 0; j < primes.size(); ++j) {
    if (i % primes[j] != 0) {
      const double t =
          static_cast<double>(mods[j] - 1) / static_cast<double>(primes[j] - 1);
      cur *= t;
    }
  }
  return cur;
}

inline bool scan_early_one_exceeds(const std::vector<int> &primes,
                                   const std::vector<int> &mods, int64_t total,
                                   double threshold, int iter, int variant = -1,
                                   int64_t limit = -1) {
  if (limit < 0)
    limit = total / primes.back();
  double acc = 0.0;
  for (int64_t i = 1; i <= limit; ++i) {
    acc += survival_weight(static_cast<int>(i), primes, mods);
    if (acc / static_cast<double>(i) > threshold) {
      if (variant >= 0)
        std::cout << iter << ' ' << variant << ' ' << i << ' ' << acc / i << ' '
                  << threshold << '\n';
      else
        std::cout << iter << ' ' << i << ' ' << acc / i << ' ' << threshold
                  << '\n';
      return true;
    }
  }
  return false;
}

inline int first_zero_index(const std::vector<uint64_t> &histogram, int total) {
  for (int i = 0; i < total; ++i) {
    if (!histogram[i])
      return i;
  }
  return total;
}

} // namespace prime

#endif
