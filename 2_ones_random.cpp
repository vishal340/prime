// This program is for single number and any distribution of domain
// check whether the relation of 2 ones probability translates to any k number
// of ones

#include <algorithm>
#include <chrono>
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
  float t1 = 2 * mod1 / (float)(p * x * (x - 1));
  float t2 = (k - 1) / (float)(p * (k * p - 1));
  float t3 = 2 * mod2 / (float)(p * (p - 1) * x * (x - 1));
  float t4 = k / (float)(p * (k * p - 1));
  vec[0] = (t1 <= t2);
  for (int i = 1; i < p - 1; i++) {
    float t5 = i * (i + 1) * t3;
    float t6 = i * (i + 1) * t4;
    vec[i] = (((i + 1) * t1 + t5) <= ((i + 1) * t2 + t6));
  }
  return vec;
}

void mod_m(vector<int> per_mod, vector<bool> b, int p, int x, int k) {}

int main(int argc, char **argv) {
  int p, x, k;
  // p is the number, k is for total size of k*p(also k>=2)
  // x is the size of random distribution of domain between 1 and k*p
  ifstream in(argv[1]);
  int iter;
  in >> iter;
  for (int it = 1; it <= iter; it++) {
    in >> p >> k >> x;
    int total = k * p;
    vector<int> vec(total);
    auto t = vec.begin();
    for (int i = 0; i < k - 1; i++) {
      iota(t, t + p, 0);
      t += p;
    }
    iota(t, t + p, 1);
    unsigned seed = chrono::system_clock::now().time_since_epoch().count();
    shuffle(vec.begin(), vec.end(), default_random_engine(seed));
    vector<int> per_mod(p, 0), false_vec(p - 1, 0);
    for (int i = 0; i < x; i++) {
      per_mod[vec[i]]++;
    }
    vector<bool> b = two(per_mod, p, x, k);
    if (equal(b.begin(), b.end(), false_vec.begin()))
      continue;
    mod_m(per_mod, b, p, x, k);
  }
}
