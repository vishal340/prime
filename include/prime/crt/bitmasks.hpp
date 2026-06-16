#ifndef PRIME_CRT_BITMASKS_HPP
#define PRIME_CRT_BITMASKS_HPP

#include <cmath>
#include <cstdint>
#include <ostream>
#include <vector>

#include "prime/binomial.hpp"

namespace prime {
namespace crt {

using MaskTable = std::vector<std::vector<std::vector<uint32_t>>>;

inline MaskTable build_residue_masks(const std::vector<int> &primes, int total) {
  const int len = static_cast<int>(std::ceil(total / 32.0));
  MaskTable seq(primes.size());
  for (std::size_t i = 0; i < primes.size(); ++i) {
    seq[i].assign(primes[i], std::vector<uint32_t>(len, 0));
    const int stride = total / primes[i];
    for (int residue = 0; residue < primes[i]; ++residue) {
      int pos = residue;
      for (int step = 0; step < stride; ++step) {
        seq[i][residue][pos / 32] |= static_cast<uint32_t>(1u << (pos % 32));
        pos += primes[i];
      }
    }
  }
  return seq;
}

inline void advance_residue_choice(std::vector<std::vector<int>> &cur,
                                   const std::vector<int> &primes,
                                   const std::vector<int> &mods) {
  int i = 0;
  while (cur[i][0] == primes[i] - mods[i]) {
    for (int j = 0; j < mods[i]; ++j)
      cur[i][j] = j;
    ++i;
  }
  int j = mods[i] - 1;
  while (cur[i][j] == primes[i] + j - mods[i])
    --j;
  const int t = cur[i][j];
  for (int k = j; k < mods[i]; ++k)
    cur[i][k] = t + k - j + 1;
}

inline std::vector<uint64_t>
leading_zero_histogram(const std::vector<int> &primes,
                       const std::vector<int> &mods, const MaskTable &seq,
                       int total) {
  const int len = static_cast<int>(std::ceil(total / 32.0));
  const int number = static_cast<int>(primes.size());
  std::vector<uint64_t> acc(total, 0);
  uint64_t perm = product_binomial_u64(primes, mods);

  std::vector<std::vector<int>> cur(number);
  for (int i = 0; i < number; ++i) {
    cur[i].resize(mods[i]);
    for (int j = 0; j < mods[i]; ++j)
      cur[i][j] = j;
  }

  uint32_t comp[32];
  for (int i = 0; i < 32; ++i)
    comp[i] = static_cast<uint32_t>(1u << i);

  while (perm-- > 0) {
    std::vector<uint32_t> dist(len, 0);
    for (int j = 0; j < mods[0]; ++j) {
      const int residue = cur[0][j];
      for (int k = 0; k < len; ++k)
        dist[k] |= seq[0][residue][k];
    }
    for (int i = 1; i < number; ++i) {
      std::vector<uint32_t> temp(len, 0);
      for (int j = 0; j < mods[i]; ++j) {
        const std::vector<uint32_t> &mask = seq[i][cur[i][j]];
        for (int k = 0; k < len; ++k)
          temp[k] |= mask[k];
      }
      for (int k = 0; k < len; ++k)
        dist[k] &= temp[k];
    }

    for (int i = 0; i < len; ++i) {
      if (dist[i]) {
        for (int j = 0; j < 32; ++j) {
          if (dist[i] & comp[j]) {
            for (int k = 0; k < j; ++k)
              ++acc[i * 32 + k];
            break;
          }
        }
        break;
      }
      for (int j = i * 32; j < (i + 1) * 32; ++j)
        ++acc[j];
    }

    if (perm > 0)
      advance_residue_choice(cur, primes, mods);
  }

  return acc;
}

inline void write_histogram(std::ostream &out,
                            const std::vector<uint64_t> &acc, int total,
                            uint64_t perm_count) {
  out << "0 " << perm_count << ' ';
  for (int i = 0; i < total; ++i) {
    if (acc[i])
      out << i + 1 << ' ' << acc[i] << ' ';
    else {
      out << '\n';
      break;
    }
  }
}

} // namespace crt
} // namespace prime

#endif
