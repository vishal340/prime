/**
 * @file 2_ones_random.cpp
 * @brief Two-Tuple and K-Tuple Probability Distribution Analysis
 * 
 * Tests whether the probability relationships for 2-tuples generalize to k-tuples
 * under random domain distributions.
 * 
 * For a single number (p coprimes) with k repetitions and random distribution
 * of x elements across k*p positions, this program:
 * 1. Generates random domain distributions
 * 2. Calculates modular residue counts per coprime
 * 3. Computes 2-tuple and 3-tuple probability bounds
 * 4. Reports counterexamples where bounds don't hold
 * 
 * Usage: ./2_ones_random <input_file>
 * Input format: iter, then for each iteration: p k x
 * Output: Counterexample tuples (iteration, tuple_id, distribution)
 */

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <random>

using namespace std;

/**
 * @brief Calculate 2-tuple probability bounds
 * 
 * Computes whether the 2-tuple probability hypothesis holds for given
 * distribution of modular residues.
 * 
 * For each i from 0 to p-2, returns true if the i-th inequality is satisfied.
 * 
 * Key equations:
 * - t1: Sum of C(m_j, 2) over all coprimes
 * - t2: Binomial coefficient for domain
 * - t3: Sum of products of pairs of modular residues
 * - t4: Product-based adjustment factor
 * 
 * @param per_mod Vector of modular residue counts (size p)
 * @param p Number of coprimes
 * @param x Domain size (number of elements sampled)
 * @param k Repetition factor (domain is k*p sized)
 * @return Vector<bool> where vec[i] = true if i-th inequality holds
 */
vector<bool> two(vector<int> per_mod, int p, int x, int k) {
  // Calculate mod1: sum of C(per_mod[i], 2) = per_mod[i]*(per_mod[i]-1)/2
  // This counts pairs within each modular residue class
  int mod1 = 0, mod2 = 0;
  for (int i = 0; i < p; i++) {
    mod1 += (per_mod[i] * (per_mod[i] - 1)) / 2;
    // Calculate mod2: sum of products of all pairs of residue counts
    for (int j = i + 1; j < p; j++)
      mod2 += per_mod[i] * per_mod[j];
  }
  
  vector<bool> vec(p - 1);
  
  // Calculate probability bound components
  int t1 = 2 * mod1 * (k * p - 1);      // Diagonal pairs contribution
  int t2 = (k - 1) * x * (x - 1);        // Domain-based factor
  int t3 = 2 * mod2 * (k * p - 1);       // Off-diagonal pairs contribution
  int t4 = k * (p - 1) * x * (x - 1);    // Cross-term factor
  
  // Check first inequality (i=0)
  vec[0] = (t1 <= t2);
  
  // Check remaining inequalities
  for (int i = 1; i < p - 1; i++) {
    vec[i] = (((i + 1) * (t1 + i * t3)) <= ((i + 1) * (t2 + i * t4)));
  }
  
  return vec;
}

/**
 * @brief Calculate 3-tuple probability bounds
 * 
 * Similar to two() but for 3-tuples (triples).
 * 
 * Key equations extend to:
 * - t1: Sum of C(m_j, 3)
 * - t2: Binomial for domain size with 3 elements
 * - t3: Sum of C(m_i, 2)*m_j products
 * - t4: Triple cross-term adjustment
 * - t5: Product of all three residue counts
 * - t6: Domain-based triple factor
 * 
 * @param per_mod Vector of modular residue counts (size p)
 * @param p Number of coprimes
 * @param x Domain size
 * @param k Repetition factor
 * @return Vector<bool> where vec[i] = true if i-th inequality holds
 */
vector<bool> three(vector<int> per_mod, int p, int x, int k) {
  // Calculate three-way combinations
  int mod1 = 0, mod2 = 0, mod3 = 0;
  
  for (int i = 0; i < p; i++) {
    // mod1: sum of C(per_mod[i], 3) = per_mod[i]*(per_mod[i]-1)*(per_mod[i]-2)/6
    mod1 += (per_mod[i] * (per_mod[i] - 1) * (per_mod[i] - 2)) / 6;
    
    for (int j = i + 1; j < p; j++) {
      // mod2: sum of C(per_mod[i], 2)*per_mod[j] + C(per_mod[j], 2)*per_mod[i]
      mod2 += (per_mod[i] * per_mod[j] * (per_mod[i] + per_mod[j] - 2)) / 2;
      
      for (int l = j + 1; l < p; l++) {
        // mod3: sum of per_mod[i]*per_mod[j]*per_mod[l]
        mod3 += per_mod[i] * per_mod[j] * per_mod[l];
      }
    }
  }
  
  // Calculate 3-tuple probability bound components (use int64 to prevent overflow)
  int64_t t1 = 6 * mod1 * (int64_t)(k * p - 1) * (k * p - 2);
  int64_t t2 = (k - 1) * (k - 2) * (int64_t)x * (x - 1) * (x - 2);
  int64_t t3 = 6 * mod2 * (int64_t)(k * p - 1) * (k * p - 2);
  int64_t t4 = 3 * k * (k - 1) * (int64_t)(p - 1) * x * (x - 1) * (x - 2);
  int64_t t5 = 6 * mod3 * (int64_t)(k * p - 1) * (k * p - 2);
  int64_t t6 = k * k * (p - 1) * (int64_t)(p - 2) * x * (x - 1) * (x - 2);
  
  vector<bool> vec(p - 1);
  
  // Check first inequality
  vec[0] = (t1 <= t2);
  // Check second inequality
  vec[1] = (2 * (t1 + t3) <= 2 * (t2 + t4));
  
  // Check remaining inequalities
  for (int i = 2; i < p - 1; i++) {
    vec[i] = (((i + 1) * (t1 + i * (t3 + (i - 1) * t5))) <=
              ((i + 1) * (t2 + i * (t4 + (i - 1) * t6))));
  }
  
  return vec;
}

int main(int argc, char **argv) {
  int p, x, k;
  // p: number of coprimes
  // k: repetition factor (total elements = k*p)
  // x: size of random sample drawn from [0, k*p)
  
  ifstream in(argv[1]);
  int iter;
  in >> iter;  // Number of test cases
  
  for (int it = 1; it <= iter; it++) {
    in >> p >> k >> x;
    
    // Create domain vector with k repeats of [0, 1, ..., p-1]
    vector<int> vec(k * p);
    auto t = vec.begin();
    for (int i = 0; i < k - 1; i++) {
      iota(t, t + p, 0);  // Fill with 0, 1, ..., p-1
      t += p;
    }
    iota(t, t + p, 0);
    
    // Shuffle using current time as seed for randomness
    unsigned seed = chrono::system_clock::now().time_since_epoch().count();
    shuffle(vec.begin(), vec.end(), default_random_engine(seed));
    
    // Count how many times each residue class appears in first x elements
    vector<int> per_mod(p, 0);
    for (int i = 0; i < x; i++) {
      per_mod[vec[i]]++;
    }
    
    // Calculate 2-tuple and 3-tuple bounds for this distribution
    vector<bool> b = two(per_mod, p, x, k);
    vector<bool> b1 = three(per_mod, p, x, k);
    
    // Check if all 2-tuple inequalities hold
    bool cont = true;
    for (auto i : b) {
      if (!i) {
        cont = false;
        break;
      }
    }
    
    // If 2-tuple holds but 3-tuple fails, report counterexample
    if (cont) {
      for (int i = 0; i < p - 1; i++) {
        if (!b1[i]) {
          cout << it << ' ' << i + 1 << '\n';
          // Output the distribution that caused the counterexample
          for (auto j : per_mod)
            cout << j << ' ';
          cout << '\n';
        }
      }
    }
  }
  
  return 0;
}
