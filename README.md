# Prime Tuples and Modulo Research

A collection of C++ programs investigating prime tuple distributions, probabilistic coverage gaps, and prime gap analysis under multiple modular constraints.

## Project Overview

This repository contains research code exploring:
- **Prime tuple hypotheses** with multiple modulo constraints
- **Probabilistic coverage** of prime tuples in the domain space
- **Prime gap analysis** using sieve-based algorithms
- **Modular arithmetic patterns** in prime number distributions

### Key Research Focus

The main investigation centers on whether probabilistic models can predict gaps in prime tuple coverage when constrained by multiple moduli. Each program tests specific hypotheses about the relationship between prime distributions and their modular residues.

## Repository Structure

```
├── README.md                  # This file
├── proof.typ                  # Typst documentation of mathematical proof
├── proof.pdf                  # Compiled proof document
├── bibliography.bib           # References
├── Makefile                   # Build configuration
├── sieve_of_erat.cpp         # Sieve of Eratosthenes implementation
├── calc1.cpp                  # Probability calculations for prime coverage
├── 2_ones_random.cpp         # Analysis of 2-tuple and k-tuple distributions
├── set_approach.cpp          # Set-based approach to coverage analysis
├── cond_ones.cpp             # Conditional tuple analysis
├── consecutive_zeros.cpp     # Analysis of consecutive prime gaps
├── given_prod_2.cpp          # Product-based probability calculations
├── induction_on_n.cpp        # Mathematical induction over n
├── k_ones.cpp                # k-tuple analysis
├── compact_n.cpp             # Compact representation methods
├── check_on_prob.cpp         # Probability verification
├── large_prime_gap.cpp       # Large gap detection
└── input/                    # Sample input files
```

## Input Format

All programs that require input follow this standardized format:

**Input File Structure:**
```
<number_of_inputs>
<input_1_line_1>
<input_1_data>
...
<input_n_line_1>
<input_n_data>
```

**Per Input Format:**
- First line: number of coprimes to follow
- Each subsequent line: `<coprime> <modulus_value>`

**Example Input:**
```
2
2
5 2
7 2
3
6 3
11 4
13 5
```

This example defines 2 inputs:
- **Input 1**: 2 coprimes (5 mod 2, 7 mod 2)
- **Input 2**: 3 coprimes (6 mod 3, 11 mod 4, 13 mod 5)

Some programs require an additional parameter `x` on the first line of input (total domain size distribution).

## Building & Running

### Prerequisites
- C++ compiler (g++ with -O3 optimization support)
- GMP library (for arbitrary precision arithmetic in `set_approach.cpp`)

### Compilation

**Simple programs:**
```bash
g++ -O3 sieve_of_erat.cpp -o sieve
./sieve <n> <output_file>
```

**With GMP library:**
```bash
g++ -O3 set_approach.cpp -lgmpxx -lgmp -o set_approach
./set_approach input.txt output.txt
```

**Using Makefile:**
```bash
make set
```

## Program Descriptions

| Program | Purpose | Input | Output |
|---------|---------|-------|--------|
| `sieve_of_erat.cpp` | Generate primes up to n using Sieve of Eratosthenes | n (limit) | Primes + timing |
| `calc1.cpp` | Calculate probability bounds for prime coverage | Configuration file | Coverage analysis |
| `2_ones_random.cpp` | Analyze 2-tuple distributions under random domain | Config + x | Probability results |
| `set_approach.cpp` | Set-based coverage analysis (requires GMP) | Config file | Detailed coverage |
| `consecutive_zeros.cpp` | Analyze consecutive prime gaps | Configuration | Gap statistics |
| `given_prod_2.cpp` | Probability via product of moduli | Configuration | Product-based analysis |
| `induction_on_n.cpp` | Inductive proofs on n values | Configuration | Induction results |
| `k_ones.cpp` | Generalize to k-tuple analysis | Configuration | k-tuple bounds |

## Mathematical Background

The research investigates whether prime tuple coverage gaps can be predicted using:
1. **Probability bounds** based on Chinese Remainder Theorem
2. **Modular residue analysis** across multiple primes
3. **Combinatorial counting** of overlapping modular constraints
4. **Inductive proofs** on increasing domain sizes

See `proof.typ` for detailed mathematical formulation.

## References

See `bibliography.bib` for academic references related to:
- Prime gap theory
- Diophantine equations and modular arithmetic
- Chinese Remainder Theorem applications
- Prime tuple conjecture research

## Output Format

Most programs write results to `output.txt` (or specified output file) with:
- Boolean verdicts (1 = hypothesis confirmed, 0 = falsified)
- Per-input analysis results
- Distribution statistics

## Future Improvements

- [ ] Add unit tests for validation
- [ ] Create visualization tools for gap analysis
- [ ] Implement parallel processing for large n
- [ ] Add command-line argument parsing
- [ ] Create detailed algorithm documentation

## Notes

- All C++ files use `-O3` optimization for performance
- Some programs use `std::vector<bool>` for memory efficiency
- Timing measurements use `clock_gettime` for precision
- GMP library required only for arbitrary precision in `set_approach.cpp`

## License

This repository contains research code. See individual files for licensing details.

## Contact

For questions about the research or code, please open an issue.
