#include <fstream>
#include <iostream>
#include <vector>

int main(int argc, char *argv[]) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  int iter;
  in >> iter;
  while (iter--) {
    int number;
    in >> number;
    std::vector<int> primes(number), mod(number);
    for (int i = 0; i < number; i++) {
      in >> primes[i] >> mod[i];
    }
    int ones = 1;
    int64_t total = 1;
    for (int i = 0; i < number; i++) {
      total *= primes[i];
      ones *= mod[i];
    }
    ones--;
    double P = (double)ones / (double)(total - 1);
    double acc = 0;
    for (int64_t i = 1; i <= total / primes[number - 1]; i++) {
      double cur = 1;
      for (int j = 0; j < number; j++) {
        if (i % primes[j] != 0) {
          const double t = (double)(mod[j] - 1) / (double)(primes[j] - 1);
          cur *= t;
        }
      }
      acc += cur;
      if (acc / i > P) {
        std::cout << iter << ' ' << i << ' ' << acc / i << ' ' << ' ' << P
                  << '\n';
      }
    }
    std::cout << "iteration " << iter << " done\n";
  }
  return 0;
}
