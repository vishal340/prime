// input: input and output file
//
// input file is slightly different for first line of each iteration
// instead of contain 1 number it contains 2 numbers, the second one being x

#include <cmath>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>

long double particular(uint8_t number, unsigned int x,
                       const std::vector<uint8_t> &prime,
                       const std::vector<uint8_t> &mod) {
  uint8_t P = prime[number - 1];
  std::vector<std::vector<uint8_t>> seq(number - 1);
  for (uint8_t i = 0; i < number - 1; i++) {
    seq[i].assign(mod[i] - 1, 0);
    for (uint8_t j = 1; j < prime[i]; j++) {
      seq[i] = (j * P) % prime[i];
    }
  }
}
long double average(uint8_t number, unsigned int x,
                    const std::vector<uint8_t> &prime,
                    const std::vector<uint8_t> &mod) {}

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  uint8_t iter;
  in >> iter;
  out << iter << "\n";
  while (iter--) {
    uint8_t number;
    unsigned int x;
    in >> number >> x;
    std::vector<uint8_t> prime(number), mod(number);
    int total = 1;
    for (i = 0; i < number; i++) {
      in >> prime[i] >> mod[i];
      total *= prime[i];
    }
    long double p1 = 1.0;
    for (uint8_t i = 0; i < number; i++) {
      p1 *= (long double)mod[i] / (long double)prime[i];
    }
    p1 = 1.0 - p1;
    out << std::pow(p1, x) << ' ';
    out << particular(number, x, prime, mod) << ' ';
    out << average(number, x, prime, mod) << '\n';
  }
  return 0;
}
