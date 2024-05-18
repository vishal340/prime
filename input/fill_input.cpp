#include <cmath>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

int main(int argc, char **argv) {
  std::ofstream out(argv[1]);
  int iter = 1;
  std::vector<int> primes;
  std::string str;
  getline(std::cin, str);
  while (str != "") {
    primes.push_back(std::stoi(str));
    getline(std::cin, str);
  }
  for (auto p : primes) {
    iter *= p - 3;
  }
  out << iter << "\n";
  int s = primes.size();
  std::vector<int> cur(s, 2);
  while (iter--) {
    out << s << '\n';
    for (int i = 0; i < s; i++)
      out << primes[i] << ' ' << cur[i] << '\n';
    for (int i = s - 1; i >= 0; i--) {
      if (cur[i] != primes[i] - 2) {
        cur[i]++;
        for (int j = i + 1; j < s; j++)
          cur[j] = 2;
        break;
      }
    }
  }
  return 0;
}
