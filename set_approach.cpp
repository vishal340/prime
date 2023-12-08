// Copyright (C) 2023 All rights reserved.
// Author        : vishal tripathy
// Email         : vishaltripathy54@gmail.com

#include <algorithm>
#include <cstdint>
#include <fstream>
#include <gmpxx.h>
#include <iomanip>
#include <iostream>
#include <random>
#include <vector>

void permute(std::vector<mpz_class> *comb, int ones) {
  int t = ones * (ones - 1);
  t /= 2;
  comb->push_back(t);
  for (int i = 3; i <= ones; i++) {
    auto t1 = (ones - i + 1) * t;
    t1 /= i;
    t = t1;
    comb->push_back(t);
  }
}

int main(int argc, char *argv[]) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  int iter;
  in >> iter;
  for (int it = 0; it < iter; it++) {
    int number;
    in >> number;
    std::vector<unsigned int> prime(number);
    uint32_t total = 1, phi = 1;
    for (int i = 0; i < number; i++) {
      in >> prime[i];
      total *= prime[i];
      phi *= prime[i] - 1;
    }
    int ones, rank, x;
    in >> ones >> rank >> x;

    std::vector<std::vector<mpz_class>> comb(ones - 1);

    for (int i = 0; i < ones - 1; i++) {
      permute(&comb[i], i + 2);
    }

    std::vector<std::vector<unsigned int>> basis(
        rank, std::vector<unsigned int>(ones, 0));
    for (int i = 0; i < rank; i++) {
      std::random_device rd;
      std::mt19937 gen(rd());
      std::uniform_int_distribution<> dist(0, total - 1);
      auto &temp = basis[i];
      temp[0] = dist(gen);
      for (int j = 1; j < ones; j++) {
        auto t = dist(gen);
        if (std::find(temp.begin(), temp.begin() + j, t) == temp.end())
          temp[j] = t;
      }
    }
    std::vector<mpz_class> acc(ones - 1, 0);
    auto func = [phi, total, number, ones, prime, x, comb,
                 &acc](const std::vector<unsigned int> &dist) {
      for (unsigned int i = 1; i <= phi; i++) {
        bool next = false;
        for (int j = 0; j < number; j++) {
          if (i % prime[j] == 0) {
            next = true;
            break;
          }
        }
        if (next)
          continue;
        std::vector<unsigned int> temp(dist);
        for (int j = 1; j < ones; j++)
          temp[j] = ((temp[j] - temp[0]) * i + temp[j]) % total;
        std::sort(temp.begin(), temp.end());
        for (int t = 0; t < total; t++) {
          int ret;
          if (t + x > t) {
            ret = std::count_if(temp.begin(), temp.end(), [t, x](auto a) {
              if (a >= t && a < t + x)
                return true;
            });
          } else {
            ret = std::count_if(temp.begin(), temp.end(), [t, x](auto a) {
              if (a >= t || a < t + x)
                return true;
            });
          }
          for (int k = 2; k <= ret; k++) {
            acc[k - 2] += comb[ret - 2][k - 2];
          }
        }
      }
    };
    for (int i = 0; i < rank; i++) {
      func(basis[i]);
    }
    out << it << '\n';
    mpz_class normalize = x * (x - 1);
    normalize /= 2;
    mpf_class compare = (mpf_class)(2 * phi) / (total - 1);
    int inc = 2;
    uint64_t prod = (uint64_t)total * phi * rank;
    for (auto a : acc) {
      if (a != 0) {
        mpf_class temp = (mpf_class)a / normalize;
        temp /= prod;
        out << std::setprecision(atoi(argv[3])) << temp << ' ' << compare
            << '\n';
        normalize *= x - inc;
        compare *= (mpf_class)(inc + 1) / (total - inc);
        inc++;
        normalize /= inc;
      } else
        break;
    }
    out << '\n';
  }
  return 0;
}
