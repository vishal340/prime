// This program checks the probability of 1 in 1..x
// for every already existing 1s inside said 1..x

// here the input format is bit different in first line
// of each iteration
// it is as follows: you need to give number of primes
// 									then
// number of x and all x (all in same line)

#include <fstream>
#include <iomanip>
#include <iostream>
#include <vector>

int main(int argc, char *argv[]) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  int iter;
  in >> iter;
  while (iter--) {
    int number, t;
    in >> number >> t;
    std::vector<int> x(t);
    for (int i = 0; i < t; i++)
      in >> x[i];
    std::vector<int> primes(number), mod(number);
    for (int i = 0; i < number; i++) {
      in >> primes[i] >> mod[i];
    }
    int64_t total = 1;
    double P = 1;
    for (int i = 0; i < number; i++) {
      total *= primes[i];
      t *= mod[i];
    }
    P = t / (double)total;

    std::vector<int[2]> cur_mod(number);

    // NOTE: this is testing for small values(2) of k
    // later i might increse it to arbitrary k

    for (int I = 0; I < x.size(); I++) {
      for (int i = 0; i < (x[I] + 1) / 2; i++) {
        for (int it = 0; it < number; it++) {
          cur_mod[it][0] = i % primes[it];
        }
        for (int j = i + 1; j < x[I]; j++) {
          for (int it = 0; it < number; it++) {
            cur_mod[it][1] = j % primes[it];
          }
          double prob = 0;
          for (int l = 0; l < x[I]; l++) {
            if (l != i && l != j) {
              double temp_prob = 1.0;
              for (int it = 0; it < number; it++) {
                auto m1 = l % primes[it];
                if (m1 != cur_mod[it][0] && m1 != cur_mod[it][1]) {
                  if (cur_mod[it][0] != cur_mod[it][1]) {
                    temp_prob *= (mod[it] - 2) / (double)(primes[it] - 2);
                  } else {
                    temp_prob *= (mod[it] - 1) / (double)(primes[it] - 1);
                  }
                }
              }
              prob += temp_prob;
            }
          }
          prob /= (x[I] - 2);
          if (prob > P) {
            std::cout << iter << ' ' << I << ' ' << i << ' ' << j << ' ';
            std::cout << std::setprecision(16) << P << ' ' << prob << '\n';
          }
        }
      }
    }
  }
  return 0;
}
