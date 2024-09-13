// This program is for single number and any distribution of domain
// check whether the relation of 2 ones probability translates to any k number
// of ones

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <random>

using namespace std;

vector<bool> two(vector<int> per_mod, int p, int x, int k) {
  int mod1 = 0, mod2 = 0;
  for (int i = 0; i < p; i++) {
    mod1 += (per_mod[i] * (per_mod[i] - 1)) / 2;
    for (int j = i + 1; j < p; j++)
      mod2 += per_mod[i] * per_mod[j];
  }
  vector<bool> vec(p - 1);
  int t1 = 2 * mod1 * (k * p - 1);
  int t2 = (k - 1) * x * (x - 1);
  int t3 = 2 * mod2 * (k * p - 1);
  int t4 = k * (p - 1) * x * (x - 1);
  vec[0] = (t1 <= t2);
  for (int i = 1; i < p - 1; i++) {
    vec[i] = (((i + 1) * (t1 + i * t3)) <= ((i + 1) * (t2 + i * t4)));
  }
  return vec;
}

vector<bool> three(vector<int> per_mod, int p, int x, int k) {
  int mod1 = 0, mod2 = 0, mod3 = 0;
  for (int i = 0; i < p; i++) {
    mod1 += (per_mod[i] * (per_mod[i] - 1) * (per_mod[i] - 2)) / 6;
    for (int j = i + 1; j < p; j++) {
      mod2 += (per_mod[i] * per_mod[j] * (per_mod[i] + per_mod[j] - 2)) / 2;
      for (int l = j + 1; l < p; l++) {
        mod3 += per_mod[i] * per_mod[j] * per_mod[l];
      }
    }
  }
  int64_t t1 = 6 * mod1 * (int64_t)(k * p - 1) * (k * p - 2);
  int64_t t2 = (k - 1) * (k - 2) * (int64_t)x * (x - 1) * (x - 2);
  int64_t t3 = 6 * mod2 * (int64_t)(k * p - 1) * (k * p - 2);
  int64_t t4 = 3 * k * (k - 1) * (int64_t)(p - 1) * x * (x - 1) * (x - 2);
  int64_t t5 = 6 * mod3 * (int64_t)(k * p - 1) * (k * p - 2);
  int64_t t6 = k * k * (p - 1) * (int64_t)(p - 2) * x * (x - 1) * (x - 2);
  vector<bool> vec(p - 1);
  vec[0] = (t1 <= t2);
  vec[1] = (2 * (t1 + t3) <= 2 * (t2 + t4));
  for (int i = 2; i < p - 1; i++) {
    vec[i] = (((i + 1) * (t1 + i * (t3 + (i - 1) * t5))) <=
              ((i + 1) * (t2 + i * (t4 + (i - 1) * t6))));
  }
  return vec;
}

int main(int argc, char **argv) {
  int p, x, k;
  // p is the number, k is for total size of k*p(also k>=2)
  // x is the size of random distribution of domain between 1 and k*p
  ifstream in(argv[1]);
  int iter;
  in >> iter;
  for (int it = 1; it <= iter; it++) {
    in >> p >> k >> x;
    vector<int> vec(k * p);
    auto t = vec.begin();
    for (int i = 0; i < k - 1; i++) {
      iota(t, t + p, 0);
      t += p;
    }
    iota(t, t + p, 0);
    unsigned seed = chrono::system_clock::now().time_since_epoch().count();
    shuffle(vec.begin(), vec.end(), default_random_engine(seed));
    vector<int> per_mod(p, 0);
    for (int i = 0; i < x; i++) {
      per_mod[vec[i]]++;
    }
    vector<bool> b = two(per_mod, p, x, k);
    vector<bool> b1 = three(per_mod, p, x, k);
    bool cont = true;
    for (auto i : b) {
      if (!i) {
        cont = false;
        break;
      }
    }
    if (cont) {
      for (int i = 0; i < p - 1; i++) {
        if (!b1[i]) {
          cout << it << ' ' << i + 1 << '\n';
          for (auto j : per_mod)
            cout << j << ' ';
          cout << '\n';
        }
      }
    }
  }
}
