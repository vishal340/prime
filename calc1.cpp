/**
 * @file calc1.cpp
 * @brief Prime Coverage Probability Calculator
 * 
 * Tests the hypothesis that for large numbers of primes, where each zero
 * (gap) has exactly one maximum Arithmetic Progression (AP) of zeros,
 * specific probability bounds hold.
 * 
 * This program calculates and compares probability bounds based on:
 * - Modular residue distributions
 * - Chinese Remainder Theorem combinatorics
 * - Coverage gap predictions
 * 
 * Usage: ./calc1 <input_file> <output_file>
 * Input format: See README.md
 * Output: Boolean (1 or 0) for each test case
 */

#include <cmath>
#include <cstddef>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

/**
 * @brief Compare probability bounds for given prime configuration
 * 
 * Calculates two probability estimates based on modular arithmetic:
 * - x: Probability bound using combinatorial counting
 * - y: Log-scaled probability estimate
 * 
 * Then adjusts for the average expected gap factor across all moduli.
 * 
 * @param primes Vector of (prime, multiplicity) pairs
 * @return true if log estimate >= combinatorial estimate
 */
bool compare_two(const std::vector<std::pair<int, int>> &primes) {
  // Calculate x: Product of binomial coefficients
  // For each prime p with multiplicity k: C(p, k)
  double x = 1.0;
  double y = 1.0;
  
  for (int i = 0; i < primes.size(); i++) {
    // Compute binomial coefficient C(p, k)
    for (int j = 1; j <= primes[i].second; j++)
      x *= (double)(primes[i].first - j + 1) / j;
  }
  
  // Take logarithm for numerical stability
  y = std::log(x);
  
  // Calculate product of all primes (P) and multiplicities (K)
  long x1 = 1;  // Product of all primes
  long x2 = 1;  // Product of all multiplicities
  for (int i = 0; i < primes.size(); i++) {
    x1 *= primes[i].first;
    x2 *= primes[i].second;
  }
  
  // Adjust for coverage gap: x *= (P - K) / P
  // This accounts for the uncovered residue classes
  x *= (double)(x1 - x2) / (double)x1;
  
  // Normalize log estimate by the same factor
  y /= (std::log((double)x1 / (double)(x1 - x2)));
  
  // Calculate average gap factor: product of (p-1)/2 for each prime
  // This represents the expected average residue class distribution
  double x3 = 1.0;
  for (int i = 0; i < primes.size(); i++)
    x3 *= (double)(primes[i].first - 1) / 2.0;
  
  // Normalize combinatorial estimate by gap factor
  x /= x3;
  
  // Output values for analysis
  std::cout << x << ' ' << y << '\n';
  
  // Return comparison result
  return (y >= x);
}

int main(int argc, char **argv) {
  // Open input and output files
  std::ifstream in(argv[1]);
  std::ofstream out(argv[2]);
  
  int number, iter;
  in >> iter;  // Number of test cases
  
  // Process each test case
  while (iter--) {
    in >> number;  // Number of primes in this configuration
    
    // Read prime-multiplicity pairs
    std::vector<std::pair<int, int>> primes(number);
    for (int i = 0; i < number; i++) {
      in >> primes[i].first >> primes[i].second;
    }
    
    // Compare probability estimates and write result
    out << compare_two(primes) << '\n';
  }
  
  return 0;
}
