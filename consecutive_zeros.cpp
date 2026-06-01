/**
 * @file consecutive_zeros.cpp
 * @brief Consecutive Prime Gap Analysis
 * 
 * Analyzes maximum consecutive prime gaps (zeros in coverage) for given
 * modular constraints using exhaustive enumeration and probability bounds.
 * 
 * Computes:
 * - Maximum consecutive uncovered integers
 * - Expected probability bounds
 * - Coverage statistics for random distributions
 * 
 * Usage: ./consecutive_zeros <input_file> <output_file>
 */

#include <cmath>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

/**
 * @brief Calculate maximum consecutive zero (uncovered) integers
 * 
 * Iterates through candidate integers and checks if each one is covered
 * by at least one prime residue class.
 * 
 * @param current_mod 2D vector storing modular residue information
 * @param prime Vector of prime moduli
 * @param mod Vector of multiplicity for each prime
 * @param number Count of primes
 * @return Maximum n where all integers [0, n) are covered
 */
int calculate_consecutive_zero(const vector<vector<int>> &current_mod,
                                const vector<int> &prime, 
                                const vector<int> &mod,
                                int number) {
  int max_uncovered = 0;
  
  // Check each potential uncovered integer
  for (int candidate = 0; candidate < prime[0]; candidate++) {
    bool covered = false;
    
    // Check if candidate is covered by any prime's residue classes
    for (int i = 0; i < number; i++) {
      for (int j = 0; j < mod[i]; j++) {
        // current_mod[i][2*j] = lower bound of j-th residue class
        if (current_mod[i][2 * j] == candidate % prime[i]) {
          covered = true;
          break;
        }
      }
      if (covered) break;
    }
    
    if (covered) {
      max_uncovered = candidate;
    } else {
      break;  // Found first gap
    }
  }
  
  return max_uncovered;
}

/**
 * @brief Recursively enumerate all residue class configurations
 * 
 * Uses backtracking to generate all valid assignments of residue classes
 * and finds the configuration that maximizes consecutive coverage.
 * 
 * @param current_mod Mutable configuration being built
 * @param prime Vector of prime moduli
 * @param mod Vector of multiplicity for each prime
 * @param total Vector of total assignments per prime
 * @param number Count of primes
 * @param max_zero Reference to track maximum consecutive zeros
 * @param decrement Current prime being configured (decrements to 0)
 */
void enumerate_configurations(vector<vector<int>> &current_mod, 
                               const vector<int> &prime,
                               const vector<int> &mod, 
                               const vector<int> &total, 
                               int number,
                               int &max_zero, 
                               int decrement) {
  int configurations = total[decrement];
  
  while (configurations-- > 0) {
    // Recursively process remaining primes
    if (decrement > 0) {
      enumerate_configurations(current_mod, prime, mod, total, number, 
                               max_zero, decrement - 1);
    } else {
      // Base case: evaluate this complete configuration
      int zeros = calculate_consecutive_zero(current_mod, prime, mod, number);
      max_zero = max(zeros, max_zero);
    }
    
    // Generate next configuration for current prime
    // Check if we're at initial state
    if (current_mod[decrement][0] == current_mod[decrement][1]) {
      // Reset to initial configuration
      for (int j = 0; j < mod[decrement]; j++)
        current_mod[decrement][2 * j] = j;
    } 
    // Check if rightmost residue can be incremented
    else if (current_mod[decrement][2 * (mod[decrement] - 1)] !=
             current_mod[decrement][2 * mod[decrement] - 1]) {
      current_mod[decrement][2 * (mod[decrement] - 1)]++;
    } 
    // Need to "carry" - increment earlier residue
    else {
      for (int i = 0; i < mod[decrement] - 1; i++) {
        if (current_mod[decrement][2 * (i + 1)] ==
            current_mod[decrement][2 * i + 3]) {
          current_mod[decrement][2 * i]++;
          // Update dependent residues
          for (int j = i + 1; j < mod[decrement]; j++)
            current_mod[decrement][2 * j] =
                current_mod[decrement][2 * i] + j - i;
        }
      }
    }
  }
}

/**
 * @brief Main analysis function for consecutive zeros
 * 
 * Sets up residue class configurations and exhaustively searches for
 * the maximum consecutive zero length.
 * 
 * @param prime Vector of prime moduli
 * @param mod Vector of multiplicity for each prime
 * @param number Count of primes
 * @return Maximum consecutive uncovered integers
 */
int analyze_consecutive_zeros(const vector<int> &prime, 
                               const vector<int> &mod, 
                               int number) {
  int max_zero = 0;
  
  // Initialize residue class storage: [lower, upper] for each residue
  vector<vector<int>> current_mod(number);
  for (int i = 0; i < number; i++) {
    current_mod[i].assign(2 * mod[i], 0);
    for (int j = 0; j < mod[i]; j++) {
      current_mod[i][2 * j] = j;                      // Lower bound
      current_mod[i][2 * j + 1] = j + prime[i] - mod[i];  // Upper bound
    }
  }
  
  // Calculate total configurations: C(prime[i], mod[i])
  vector<int> total(number);
  for (int i = 0; i < number; i++) {
    total[i] = 1;
    for (int j = 0; j < mod[i]; j++) {
      total[i] *= prime[i] - j;
      total[i] /= (j + 1);
    }
  }
  
  // Exhaustively enumerate all configurations
  enumerate_configurations(current_mod, prime, mod, total, number, 
                          max_zero, number - 1);
  
  return max_zero;
}

int main(int argc, char **argv) {
  ifstream in(argv[1]);
  ofstream out(argv[2]);
  
  int iter;
  in >> iter;
  
  for (int it = 0; it < iter; it++) {
    int number;
    in >> number;
    
    vector<int> prime(number), mod(number);
    for (int i = 0; i < number; i++) {
      in >> prime[i] >> mod[i];
    }
    
    // Calculate probability of coverage
    long double coverage_prob = 1.0;
    for (int i = 0; i < number; i++) {
      coverage_prob *= (prime[i] - mod[i]) / (long double)prime[i];
    }
    coverage_prob = 1.0 - coverage_prob;
    
    // Calculate total combinations
    long double total_combinations = 1.0;
    for (int i = 0; i < number; i++) {
      for (int j = 0; j < mod[i]; j++)
        total_combinations *= prime[i] - j;
      for (int j = 1; j <= mod[i]; j++)
        total_combinations /= j;
    }
    
    // Expected gap size based on probability
    out << log(total_combinations) / log(1.0 / coverage_prob) << '\t';
    
    // Actual maximum consecutive gap
    int max_zero = analyze_consecutive_zeros(prime, mod, number);
    out << max_zero << '\t';
    
    // Calculate coverage statistics
    int64_t cumulative_pairs = 1;
    for (int i = 0; i < number; i++) {
      cumulative_pairs *= prime[i] * (prime[i] - 1) / 2;
    }
    
    int covered_classes = 1, total_space = 1;
    for (int i = 0; i < number; i++) {
      covered_classes *= prime[i] - mod[i];
      total_space *= prime[i];
    }
    
    int uncovered_space = total_space - max_zero;
    long double gap_ratio = 1.0;
    
    for (int i = 0; i < covered_classes; i++) {
      gap_ratio *= (total_space - i) / (long double)(uncovered_space - i);
    }
    
    // Output: cumulative pairs / gap ratio
    out << cumulative_pairs / gap_ratio << '\n';
  }
  
  return 0;
}
