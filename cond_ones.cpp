// This is for checking cond propability of next one if it already contains k
// ones in interval x and compare the  same with full range

#include <cmath>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

int consective_zero(vector<vector<int>> &current_mod, const vector<int> &prime,
                    const vector<int> &mod, int number) {
  int n = 0;
  for (int i = 0; i < number; i++) {
    for (int j = 0; j < mod[i]; j++) {
      if (current_mod[i][2 * j] == n % prime[i]) {
        n++;
        i = -1;
        break;
      }
    }
  }

  return n;
}

void variable_loop(vector<vector<int>> &current_mod, const vector<int> &prime,
                   const vector<int> &mod, const vector<int> &total, int number,
                   int &max_zero, int decrement) {
  int temp = total[decrement];
  while (temp-- > 0) {
    if (decrement > 0)
      variable_loop(current_mod, prime, mod, total, number, max_zero,
                    decrement - 1);
    else {
      int zeros = consective_zero(current_mod, prime, mod, number);
      max_zero = zeros > max_zero ? zeros : max_zero;
    }
    if (current_mod[decrement][0] == current_mod[decrement][1]) {
      for (int j = 0; j < mod[decrement]; j++)
        current_mod[decrement][2 * j] = j;
    } else if (current_mod[decrement][2 * (mod[decrement] - 1)] !=
               current_mod[decrement][2 * mod[decrement] - 1]) {
      current_mod[decrement][2 * (mod[decrement] - 1)]++;
    } else {
      for (int i = 0; i < mod[decrement] - 1; i++) {
        if (current_mod[decrement][2 * (i + 1)] ==
            current_mod[decrement][2 * i + 3]) {
          current_mod[decrement][2 * i]++;
          for (int j = i + 1; j < mod[decrement]; j++)
            current_mod[decrement][2 * j] =
                current_mod[decrement][2 * i] + j - i;
        }
      }
    }
  }
}

int function(const vector<int> &prime, const vector<int> &mod, int number) {
  int max_zero = 0;
  vector<vector<int>> current_mod(number, vector<int>());
  for (int i = 0; i < number; i++) {
    current_mod[i].assign(2 * mod[i], 0);
    for (int j = 0; j < mod[i]; j++) {
      current_mod[i][2 * j] = j;
      current_mod[i][2 * j + 1] = j + prime[i] - mod[i];
    }
  }
  vector<int> total(number);
  for (int i = 0; i < number; i++) {
    total[i] = 1;
    for (int j = 0; j < mod[i]; j++)
      total[i] *= prime[i] - j;
    for (int j = 1; j <= mod[i]; j++)
      total[i] = (int)(total[i] / j);
  }
  variable_loop(current_mod, prime, mod, total, number, max_zero, number - 1);
  return max_zero;
}

int main(int argc, char **argv) {
  ifstream in(argv[1]);
  ofstream out(argv[2]);
  int iter;
  in >> iter;
  while (iter--) {
    int number;
    in >> number;
    vector<int> prime(number);
    vector<int> mod(number);
    for (int i = 0; i < number; i++) {
      in >> prime[i];
      in >> mod[i];
    }
    long double prob = 1.0;
    for (int i = 0; i < number; i++) {
      prob *= (prime[i] - mod[i]) / (long double)prime[i];
    }
    prob = 1.0 - prob;
    long double total = 1.0;
    for (int i = 0; i < number; i++) {
      for (int j = 0; j < mod[i]; j++)
        total *= prime[i] - j;
      for (int j = 1; j <= mod[i]; j++)
        total = total / j;
    }
    out << log(total) / log(1 / prob) << '\t';
    out << function(prime, mod, number) << '\n';
  }
  return 0;
}
