// This code to check whether assuming for large number of primes,
// and each zero having exactly once invovement in a maximum AP of zeros
//
// check proved it wrong

#include <cmath>
#include <cstddef>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

bool compare_two(const std::vector<std::pair<int, int>> &primes) {
  double x = 1.0;
  double y = 1.0;
  for (int i = 0; i < primes.size(); i++) {
    for (int j = 1; j <= primes[i].second; j++)
      x *= (double)(primes[i].first - j + 1) / j;
  }
  y = std::log(x);
  long x1 = 1;
  long x2 = 1;
  for (int i = 0; i < primes.size(); i++) {
    x1 *= primes[i].first;
    x2 *= primes[i].second;
  }
  x *= (double)(x1 - x2) / (double)x1;
  y /= (std::log((double)x1 / (double)(x1 - x2)));
  double x3 = 1.0;
  for (int i = 0; i < primes.size(); i++)
    x3 *= (double)(primes[i].first - 1) / 2.0;
  x /= x3;
  std::cout << x << ' ' << y << '\n';
  return (y >= x);
}

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  int number, iter;
  in >> iter;
  while (iter--) {
    in >> number;
    std::vector<std::pair<int, int>> primes(number);
    for (int i = 0; i < number; i++) {
      in >> primes[i].first >> primes[i].second;
    }
    out << compare_two(primes) << '\n';
  }
  return 0;
}
