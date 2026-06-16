/**
 * @file sieve_of_erat.cpp
 * @brief Sieve of Eratosthenes - Efficient prime generation algorithm
 * 
 * Generates all prime numbers up to n using the Sieve of Eratosthenes algorithm.
 * Time Complexity: O(n log log n)
 * Space Complexity: O(n)
 * 
 * Usage: ./sieve <n> <output_file>
 * Args:
 *   n: Upper limit for prime generation
 *   output_file: File to write prime numbers to
 * 
 * Output: Space-separated primes from 2 to n
 */

#include <cmath>
#include <ctime>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

int main(int argc, char *argv[]) {
  // Performance timing structures
  struct timespec start, end;
  
  // Parse command-line argument for upper limit
  int n = atoi(argv[1]);
  
  // Boolean vector where p[i] = true means i is composite (not prime)
  // We use this inverted representation for cache efficiency
  vector<bool> p(n + 1, 0);  // 0 = prime, 1 = composite
  
  // 0 and 1 are not prime by definition
  p[0] = 1;
  p[1] = 1;
  
  // Start timing the algorithm
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
  
  // Mark all even numbers > 2 as composite
  for (int i = 4; i <= n; i += 2)
    p[i] = 1;
  
  // Sieve starting from 3, checking only odd numbers
  int a = 3;
  int b = floor(sqrt(n));  // Only need to check up to sqrt(n)
  
  while (a <= b) {
    // If a is prime, mark all multiples of a as composite
    int t = a * a;  // Start from a^2 (smaller multiples already marked)
    p[t] = 1;
    
    // Mark every 2*a-th number (skip even multiples of odd primes)
    t += 2 * a;
    while (t <= n) {
      p[t] = 1;
      t += 2 * a;
    }
    
    // Find next odd number that hasn't been marked composite
    do {
      a += 2;
    } while (p[a]);
  }
  
  // End timing
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
  
  // Open output file and write all primes
  fstream out(argv[2]);
  out << 2 << ' ';  // Write 2 explicitly
  
  // Write all odd primes
  for (int i = 3; i <= n; i += 2) {
    if (!p[i])  // If not marked as composite, it's prime
      out << i << ' ';
  }
  
  // Output execution time in nanoseconds
  cout << (end.tv_sec - start.tv_sec) * 1e09 + end.tv_nsec - start.tv_nsec
       << '\n';
  
  return 0;
}
