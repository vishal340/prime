// this is for 2 coprimes
// mi>0 and mi<pi and p1<p2 and gcd(p1,p2)=1

#include <algorithm>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

long double prob_k(long int x, long int k, long int p1, long int m1,
                   long int p2, long int m2, vector<long int> &seq) {
  long int ret = 0;
  long int a1 = x % p1;
  long int a2 = x / p1;
  vector<long int> perm1(p1, 0), perm2(p2, 0);
  for (long int i = 0; i < m1; i++)
    perm1[i] = 1;
  for (long int i = 0; i < m2; i++)
    perm2[i] = 1;
  size_t comb1 = 1, comb2 = 1;
  for (size_t i = 0; i < m1; i++) {
    comb1 *= p1 - i;
    comb1 /= i + 1;
  }
  for (size_t i = 0; i < m2; i++) {
    comb2 *= p2 - i;
    comb2 /= i + 1;
  }
  for (size_t i = 0; i < comb1; i++) {
    for (size_t j = 0; j < comb2; j++) {
      vector<long int> temp(p2);
      copy(perm2.begin(), perm2.end(), temp.begin());
      long int spin = 0, acc = 0;
      for (long int i1 = 0; i1 < p1; i1++) {
        if (perm1[i1]) {
          spin = seq[i1] - spin;
          if (spin < 0) {
            spin = p2 + spin;
          }
          rotate(temp.begin(), temp.begin() + spin, temp.end());
          for (long int i2 = 0; i2 < a2; i2++)
            acc += temp[i2];
          if (i1 < a1)
            acc += temp[a2];
        }
      }
      if (acc >= k) {
        long int T = 1;
        for (long int i2 = 0; i2 < k; i2++) {
          T *= acc - i2;
          T /= i2 + 1;
        }
        ret += T;
      }
      next_permutation(perm2.begin(), perm2.end());
    }
    next_permutation(perm1.begin(), perm1.end());
  }
  long int t = 1;
  for (long int i = 0; i < k; i++) {
    t *= m1 * m1 - i;
    t /= i + 1;
  }
  long double d = (long double)ret / (long double)t;
  t = 1;
  for (long int j = 0; j < m2; j++) {
    t *= p2 - j;
    t /= j + 1;
  }
  for (long int i = 0; i < m1; i++) {
    t *= p1 - i;
    t /= i + 1;
  }
  d /= (long double)t;
  return d;
}

void setting_seq(long int p1, long int p2, vector<long int> &seq) {
  long int t = 1;
  seq[0] = 0;
  for (long int i = 1; i < p2; i++) {
    t = (t + p1) > p2 ? t + p1 - p2 : t + p1;
    if (t <= p1)
      seq[t - 1] = i;
  }
}

int main(int argc, char **argv) {
  long int p1, p2, m1, m2, k;
  ifstream in(argv[1]);
  long int n;
  in >> n;
  for (long int j = 0; j < n; j++) {
    in >> p1 >> m1 >> p2 >> m2 >> k;
    vector<long int> seq(p1);
    setting_seq(p1, p2, seq);
    long int d = min(p1 - m1, p2 - m2) + 1;
    for (long int x = p2; x < p1 * p2; x++) {
      long double t = prob_k(x, k, p1, m1, p2, m2, seq);
      for (long int i = 1; i < d; i++) {
        long double t1 = prob_k(x, k, p1, m1 + i, p2, m2 + i, seq);
        if (t1 < t) {
          cout << p1 << ' ' << m1 + i << ' ' << p2 << ' ' << m2 + i << ' ' << t
               << ' ' << t1 << ' ' << x << '\n';
        }
        t = t1;
      }
    }
  }
}
