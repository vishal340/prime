// This is a program to check the data coming out of prob.cpp

#include <cmath>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

int main(int argc, char **argv) {
  std::ifstream in(argv[1]);
  int iter, n;
  double one, half, all, t1, t2, t3;
  uint64_t temp;
  in >> iter;
  std::string str;
  getline(in, str);
  while (iter--) {
    std::cout << iter + 1 << "\n";
    std::vector<uint64_t> arr;
    getline(in, str);
    std::istringstream ss(str);
    while (ss >> n >> temp)
      arr.push_back(temp);
    one = (double)arr[1] / (double)arr[0];
    all = one * one * one;
    for (int i = 4; i < arr.size(); i++) {
      t3 = (double)arr[i] / (double)arr[0];
      all *= one;
      if (t3 > all) {
        std::cout << "\n" << i << "all over\n";
        return 0;
      }
      if (i & 1) {
        t1 = (double)arr[i] / (double)arr[i - 1];
        t2 = (double)arr[i] / (double)arr[i / 2];
        half = (double)arr[(i + 1) / 2] / (double)arr[0];
      } else {
        t1 = (double)arr[i] / (double)arr[i - 1];
        t2 = (double)arr[i] / (double)arr[i / 2];
        half = (double)arr[i / 2] / (double)arr[0];
      }
      // std::cout << t1 << " " << half << " " << t2 << "\n";
      if (t1 > one && t2 > half) {
        std::cout << i << " ";
      }
    }
  }
  return 0;
}
