#include <cmath>
#include <ctime>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

int main(int argc, char *argv[]) {
  struct timespec start, end;
  int n = atoi(argv[1]);
  vector<bool> p(n + 1, 0);
  p[0] = 1;
  p[1] = 1;
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
  for (int i = 4; i <= n; i += 2)
    p[i] = 1;
  int a = 3;
  int b = floor(sqrt(n));
  while (a <= b) {
    int t = a * a;
    p[t] = 1;
    t += 2 * a;
    while (t <= n) {
      p[t] = 1;
      t += 2 * a;
    }
    do {
      a += 2;
    } while (p[a]);
  }
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
  fstream out(argv[2]);
  out << 2 << ' ';
  for (int i = 3; i <= n; i += 2) {
    if (!p[i])
      out << i << ' ';
  }
  cout << (end.tv_sec - start.tv_sec) * 1e09 + end.tv_nsec - start.tv_nsec
       << '\n';
  return 0;
}
