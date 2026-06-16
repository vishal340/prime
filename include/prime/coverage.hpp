#ifndef PRIME_COVERAGE_HPP
#define PRIME_COVERAGE_HPP

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <vector>

#include "prime/binomial.hpp"

namespace prime {

inline long double intersection_miss_prob(const std::vector<int> &primes,
                                          const std::vector<int> &mods) {
  long double prob = 1.0;
  for (std::size_t i = 0; i < primes.size(); ++i)
    prob *= static_cast<long double>(primes[i] - mods[i]) /
            static_cast<long double>(primes[i]);
  return 1.0 - prob;
}

inline long double expected_gap_log(const std::vector<int> &primes,
                                    const std::vector<int> &mods) {
  const long double miss = intersection_miss_prob(primes, mods);
  const long double configs = product_binomial_ld(primes, mods);
  return std::log(configs) / std::log(1.0 / miss);
}

inline long double moment_log_step(const std::vector<int> &primes,
                                   const std::vector<int> &mods) {
  long double hit = 1.0;
  for (std::size_t i = 0; i < primes.size(); ++i)
    hit *= static_cast<long double>(mods[i]) /
           static_cast<long double>(primes[i]);
  return std::log(1.0 - hit);
}

inline long double moment_log_total(const std::vector<int> &primes,
                                    const std::vector<int> &mods) {
  long double log_total = 1.0;
  for (std::size_t i = 0; i < primes.size(); ++i) {
    const int t = std::min(mods[i], primes[i] - mods[i]);
    int64_t comb = primes[i];
    for (int j = 1; j < t; ++j)
      comb = comb * (primes[i] - j) / (j + 1);
    log_total += std::log(static_cast<long double>(comb));
  }
  return log_total;
}

inline void check_moment_budget(const std::vector<uint64_t> &acc, int total,
                                const std::vector<int> &primes,
                                const std::vector<int> &mods, int iter,
                                int variant = -1) {
  const long double step = moment_log_step(primes, mods);
  const long double log_total = moment_log_total(primes, mods);
  long double cur_prob = log_total;
  for (int i = 0; i < total; ++i) {
    if (!acc[i])
      break;
    if (std::log(static_cast<long double>(acc[i])) <= cur_prob) {
      cur_prob += step;
    } else {
      if (variant >= 0)
        std::cout << "exception: " << iter << ' ' << variant << ' ' << i << ' '
                  << std::log(static_cast<long double>(acc[i])) - log_total
                  << ' ' << i * step << '\n';
      else
        std::cout << "exception: " << iter << ' ' << i << ' '
                  << std::log(static_cast<long double>(acc[i])) - log_total
                  << ' ' << i * step << '\n';
      break;
    }
  }
}

} // namespace prime

#endif
