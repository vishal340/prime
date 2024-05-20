#include <cmath>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  int iter, i, j, k;
  in >> iter;
  out << iter << "\n";
  while (iter--) {
    int number;
    in >> number;
    std::vector<int> prime(number), mod(number);
    int total = 1;
    for (i = 0; i < number; i++) {
      in >> prime[i] >> mod[i];
      total *= prime[i];
    }
    std::vector<uint64_t> acc(total, 0);
    std::vector<std::vector<std::vector<uint32_t>>> seq(
        number, std::vector<std::vector<uint32_t>>());
    int len = std::ceil(total / 32);
    for (i = 0; i < number; i++) {
      seq[i].assign(prime[i], std::vector<uint32_t>(len, 0));
      int g = total / prime[i];
      for (j = 0; j < prime[i]; j++) {
        int t = j;
        for (k = 0; k < g; k++) {
          seq[i][j][t / 32] |= (uint32_t)(1 << (t % 32));
          t += prime[i];
        }
      }
    }
    uint64_t perm = 1;
    for (i = 0; i < number; i++) {
      uint64_t t = prime[i];
      for (j = 1; j < mod[i]; j++) {
        t *= (uint64_t)(prime[i] - j);
        t /= (uint64_t)(j + 1);
      }
      perm *= t;
    }
    out << "0 " << perm << " ";
    int **cur = new int *[number];
    for (i = 0; i < number; i++) {
      cur[i] = new int[mod[i]];
      for (j = 0; j < mod[i]; j++)
        cur[i][j] = j;
    }
    uint32_t comp[32];
    for (i = 0; i < 32; i++)
      comp[i] = (uint32_t)(1 << i);
    while (perm--) {
      std::vector<uint32_t> dist(len, 0);
      for (j = 0; j < mod[0]; j++) {
        for (k = 0; k < len; k++) {
          int t = cur[0][j];
          dist[k] |= seq[0][t][k];
        }
      }
      for (i = 1; i < number; i++) {
        std::vector<uint32_t> temp_dist(len, 0);
        for (j = 0; j < mod[i]; j++) {
          const auto &t = seq[i][cur[i][j]];
          for (k = 0; k < len; k++) {
            temp_dist[k] |= t[k];
          }
        }
        for (k = 0; k < len; k++) {
          dist[k] &= temp_dist[k];
        }
      }
      for (i = 0; i < len; i++) {
        if (dist[i]) {
          for (j = 0; j < 32; j++) {
            if (dist[i] & comp[j]) {
              for (k = 0; k < j; k++)
                acc[i * 32 + k]++;
              break;
            }
          }
          break;
        } else {
          for (j = i * 32; j < (i + 1) * 32; j++) {
            acc[j]++;
          }
        }
      }
      if (perm) {
        // next permutation
        i = 0;
        while (cur[i][0] == (prime[i] - mod[i])) {
          for (j = 0; j < mod[i]; j++)
            cur[i][j] = j;
          i++;
        }
        j = mod[i] - 1;
        while (cur[i][j] == (prime[i] + j - mod[i])) {
          j--;
        }
        int t = cur[i][j];
        for (k = j; k < mod[i]; k++) {
          cur[i][k] = t + k - j + 1;
        }
      }
    }
    for (int i = 0; i < total; i++) {
      if (acc[i])
        out << i + 1 << " " << acc[i] << " ";
      else {
        out << "\n";
        break;
      }
    }
  }
  return 0;
}
