#ifndef PRIME_CRT_RESIDUE_ENUM_HPP
#define PRIME_CRT_RESIDUE_ENUM_HPP

#include <algorithm>
#include <vector>

#include "prime/binomial.hpp"

namespace prime {
namespace crt {

inline int leading_ones_run(const std::vector<std::vector<int>> &current_mod,
                            const std::vector<int> &primes,
                            const std::vector<int> &mods) {
  const int number = static_cast<int>(primes.size());
  int last_covered = 0;
  for (int candidate = 0; candidate < primes[0]; ++candidate) {
    bool covered = false;
    for (int i = 0; i < number; ++i) {
      for (int j = 0; j < mods[i]; ++j) {
        if (current_mod[i][2 * j] == candidate % primes[i]) {
          covered = true;
          break;
        }
      }
      if (covered)
        break;
    }
    if (covered)
      last_covered = candidate;
    else
      break;
  }
  return last_covered;
}

inline void advance_mod_state(std::vector<std::vector<int>> &current_mod,
                              const std::vector<int> &primes,
                              const std::vector<int> &mods, int decrement) {
  if (current_mod[decrement][0] == current_mod[decrement][1]) {
    for (int j = 0; j < mods[decrement]; ++j)
      current_mod[decrement][2 * j] = j;
  } else if (current_mod[decrement][2 * (mods[decrement] - 1)] !=
             current_mod[decrement][2 * mods[decrement] - 1]) {
    ++current_mod[decrement][2 * (mods[decrement] - 1)];
  } else {
    for (int i = 0; i < mods[decrement] - 1; ++i) {
      if (current_mod[decrement][2 * (i + 1)] ==
          current_mod[decrement][2 * i + 3]) {
        ++current_mod[decrement][2 * i];
        for (int j = i + 1; j < mods[decrement]; ++j)
          current_mod[decrement][2 * j] =
              current_mod[decrement][2 * i] + j - i;
      }
    }
  }
}

inline void enumerate_configurations(std::vector<std::vector<int>> &current_mod,
                                     const std::vector<int> &primes,
                                     const std::vector<int> &mods,
                                     const std::vector<int> &totals, int number,
                                     int &max_zero, int decrement) {
  int remaining = totals[decrement];
  while (remaining-- > 0) {
    if (decrement > 0)
      enumerate_configurations(current_mod, primes, mods, totals, number,
                               max_zero, decrement - 1);
    else {
      const int zeros = leading_ones_run(current_mod, primes, mods);
      max_zero = std::max(max_zero, zeros);
    }
    advance_mod_state(current_mod, primes, mods, decrement);
  }
}

inline int max_consecutive_ones_prefix(const std::vector<int> &primes,
                                       const std::vector<int> &mods) {
  const int number = static_cast<int>(primes.size());
  int max_zero = 0;
  std::vector<std::vector<int>> current_mod(number);
  for (int i = 0; i < number; ++i) {
    current_mod[i].assign(2 * mods[i], 0);
    for (int j = 0; j < mods[i]; ++j) {
      current_mod[i][2 * j] = j;
      current_mod[i][2 * j + 1] = j + primes[i] - mods[i];
    }
  }

  std::vector<int> totals(number);
  for (int i = 0; i < number; ++i)
    totals[i] = static_cast<int>(binomial_u64(primes[i], mods[i]));

  enumerate_configurations(current_mod, primes, mods, totals, number, max_zero,
                           number - 1);
  return max_zero;
}

} // namespace crt
} // namespace prime

#endif
