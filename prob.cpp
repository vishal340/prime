#include <cmath>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  int iter;
  in >> iter;
  while (iter--) {
    int number;
    in >> number;
    std::vector<int> prime(number), mod(number);
    int total = 1;
    for (int i = 0; i < number; i++) {
      in >> prime[i] >> mod[i];
      total *= prime[i];
    }
    std::vector<int64_t> acc(total, 0);
    std::vector<std::vector<std::vector<int>>> seq(number);
    int len = std::ceil(total / 32);
    for (int i = 0; i < number; i++) {
      seq[i] =
          std::vector<std::vector<int>>(prime[i], std::vector<int>(len, 0));
      int g = total / prime[i];
      for (int j = 0; j < prime[i]; j++) {
        int t = j;
        for (int k = 0; k < g; k++) {
          seq[i][j][t / 32] |= 1 << (t % 32);
          t += prime[i];
        }
      }
    }
    int64_t perm = 0;
    for (int i = 0; i < number; i++) {
      int64_t t = prime[i];
      for (int j = 1; j < mod[i]; j++) {
        t *= (int64_t)(prime[i] - j);
        t /= (int64_t)(j + 1);
      }
      perm += t;
    }
    std::vector<std::vector<int>> cur(number);
    for (int i = 0; i < number; i++) {
      cur[i] = std::vector<int>(mod[i]);
      for (int j = 0; j < mod[i]; j++)
        cur[i][j] = j;
    }
    int comp[32];
    for (int i = 0; i < 32; i++)
      comp[i] = 1 << i;
    while (perm--) {
      std::vector<int> dist(len, 0);
      for (int j = 0; j < mod[0]; j++) {
        const auto &t = seq[0][cur[0][j]];
        for (int k = 0; k < len; k++) {
          dist[k] |= t[k];
        }
      }
      for (int i = 1; i < number; i++) {
        std::vector<int> temp_dist(len, 0);
        for (int j = 0; j < mod[i]; j++) {
          const auto &t = seq[i][cur[i][j]];
          for (int k = 0; k < len; k++) {
            temp_dist[k] |= t[k];
          }
        }
        for (int k = 0; k < len; k++) {
          dist[k] &= temp_dist[k];
        }
      }
      for (int i = 0; i < len; i++) {
        if (dist[i]) {
          for (int j = 0; j < 32; j++) {
            if (dist[i] & comp[j]) {
              for (int k = 0; k <= j; k++)
                acc[i * 32 + k]++;
              break;
            }
          }
          break;
        } else {
          for (int j = i * 32; j < (i + 1) * 32; j++) {
            acc[j]++;
          }
        }
      }
      // next permutation
      int i = 0;
      while (cur[i][0] == prime[i] - mod[i]) {
        for (int j = 0; j < mod[i]; j++)
          cur[i][j] = j;
        i++;
      }
      int j = mod[i] - 1;
      while (j--) {
        if (cur[i][j] != prime[i] + j - mod[i]) {
          cur[i][j]++;
          for (int k = j + 1; k < mod[i]; k++)
            cur[i][k] = cur[i][j] + k - j;
          break;
        }
      }
    }
    out << iter + 1 << "\n";
    for (int i = 0; i < total; i++) {
      if (acc[i])
        out << i << " " << acc[i] << " ";
      else {
        out << "\n";
        break;
      }
    }
  }
  return 0;
}
