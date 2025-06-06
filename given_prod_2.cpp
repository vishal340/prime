#include <cmath>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>

int main(int argc, char *argv[]) {
  std::ifstream in(argv[1]);
  int iter, i, j, k;
  in >> iter;
  while (iter--) {
    int number;
    in >> number;
    std::vector<int> primes(number);
    for (i = 0; i < number; i++) {
      in >> primes[i];
    }
    int total = 1, iter_mod = 1;
    for (i = 0; i < number; i++) {
      total *= primes[i];
      iter_mod *= primes[i] - 2;
    }
    uint32_t ***seq = new uint32_t **[number];
    int len = std::ceil(total / 32);
    for (i = 0; i < number; i++) {
      seq[i] = new uint32_t *[primes[i]];
      int g = total / primes[i];
      for (j = 0; j < primes[i]; j++) {
        int t = j;
        seq[i][j] = new uint32_t[len];
        for (k = 0; k < g; k++) {
          seq[i][j][t / 32] |= (uint32_t)(1 << (t % 32));
          t += primes[i];
        }
      }
    }
    for (int it = 0; it < iter_mod; it++) {
      std::vector<int> mod(number), acc1(total, 0);
      int ones = 1;
      for (i = 0; i < number; i++) {
        mod[i] = 2 + (it % (primes[i] - 2));
        ones *= mod[i];
      }
      ones--;
      double P = (double)ones / (double)(total - 1);
      uint64_t perm = 1;
      for (i = 0; i < number; i++) {
        uint64_t t = primes[i];
        for (j = 1; j < mod[i]; j++) {
          t *= (uint64_t)(primes[i] - j);
          t /= (uint64_t)(j + 1);
        }
        perm *= t;
      }
      std::vector<std::vector<int>> cur(number);
      for (i = 0; i < number; i++) {
        cur[i].assign(mod[i], 0);
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
                  acc1[i * 32 + k]++;
                break;
              }
            }
            break;
          } else {
            for (j = i * 32; j < (i + 1) * 32; j++) {
              acc1[j]++;
            }
          }
        }
        if (perm) {
          // next permutation
          i = 0;
          while (cur[i][0] == (primes[i] - mod[i])) {
            for (j = 0; j < mod[i]; j++)
              cur[i][j] = j;
            i++;
          }
          j = mod[i] - 1;
          while (cur[i][j] == (primes[i] + j - mod[i])) {
            j--;
          }
          int t = cur[i][j];
          for (k = j; k < mod[i]; k++) {
            cur[i][k] = t + k - j + 1;
          }
        }
      }
      double acc = 0;
      int max_zero = 1;
      for (i = 0; i < total; i++) {
        if (!acc1[i]) {
          max_zero = i - 1;
          break;
        }
      }
      for (i = 1; i < std::min(max_zero, total / primes[number - 1]); i++) {
        double cur1 = 1.0;
        for (j = 0; j < number; j++) {
          if (i % primes[j] != 0) {
            double t = (double)(mod[j] - 1) / (double)(primes[j] - 1);
            cur1 *= t;
          }
        }
        acc += cur1;
        if (acc / i > P) {
          std::cout << iter << ' ' << it << ' ' << i << ' ' << acc / i << ' '
                    << ' ' << P << '\n';
          break;
        }
      }
    }
    std::cout << "iteration " << iter << " done\n";
    for (i = 0; i < number; i++)
      for (j = 0; j > primes[i]; j++)
        delete[] seq[i][j];
  }
  return 0;
}
