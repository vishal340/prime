#include <algorithm>
#include <fstream>
#include <iostream>
#include <random>
#include <vector>

void func(unsigned int *acc, unsigned int *prime,
          const std::vector<unsigned int> &dist, unsigned int *ret, int rank,
          int ones, int number) {
  unsigned int total = 1, phi = 1;
  for (int i = 0; i < number; i++) {
    total *= prime[i];
    phi *= prime[i] - 1;
  }
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
    std::vector<unsigned int> temp;
    std::copy(dist.begin(), dist.end(), temp);
    for (int j = 1; j < ones; j++)
      temp[j] = ((temp[j] - temp[0]) * i + temp[j]) % total;
    std::sort(temp.begin(), temp.end());
  }
}

// TODO: do permutation calcualtion and save it in 2D array
void permute() {}

int main(int argc, char *argv[]) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  int iter;
  in >> iter;
  for (int it = 0; it < iter; it++) {
    int number;
    in >> number;
    std::vector<unsigned int> prime(number);
    uint32_t total = 1;
    for (int i = 0; i < number; i++) {
      in >> prime[i];
      total *= prime[i];
    }
    int ones, rank;
    in >> ones >> rank;
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
    std::vector<std::vector<unsigned int>> shortest(
        rank, std::vector<unsigned int>(ones, 0));
    std::vector<std::vector<unsigned int>> acc(
        ones - 1, std::vector<unsigned int>(total - 1, 0));
    for (int i = 0; i < rank; i++) {
      func(&acc[0][0], &prime[0], basis[i], &shortest[i][0], rank, ones,
           number);
    }
  }
  return 0;
}
