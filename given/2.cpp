#include <fstream>
#include <iostream>
#include <omp.h>
#include <vector>

int main(int argc, char *argv[]) {
  std::ifstream in(argv[1]);
  int iter;
  in >> iter;
  while (iter--) {
    int number;
    in >> number;
    std::vector<int> primes(number);
    for (int i = 0; i < number; i++) {
      in >> primes[i];
    }
    int64_t total = 1;
    int64_t iter_mod = 1;
    for (int i = 0; i < number; i++) {
      total *= primes[i];
      iter_mod *= primes[i] - 3;
    }
#pragma omp parallel for schedule(dynamic, iter_mod / atoi(argv[2]))
    for (int64_t k = 0; k < iter_mod; k++) {
      std::vector<int> mod(number);
      int ones = 1;
      for (int i = 0; i < number; i++) {
        mod[i] = 2 + (k % (primes[i] - 3));
        ones *= mod[i];
      }
      ones--;
      double P = (double)ones / (double)(total - 1);
      double acc = 0;
      for (int64_t i = 1; i < total / primes[number - 1]; i++) {
        double cur = 1;
        for (int j = 0; j < number; j++) {
          if (i % primes[j] != 0) {
            const double t = (double)(mod[j] - 1) / (double)(primes[j] - 1);
            cur *= t;
          }
        }
        acc += cur;
        if (acc / i > P) {
          std::cout << iter << ' ' << k << ' ' << i << ' ' << acc / i << ' '
                    << ' ' << P << '\n';
        }
      }
    }
    std::cout << "iteration " << iter << " done\n";
  }
  return 0;
}
