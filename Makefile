# Makefile for CRT intersection / Hardy–Littlewood research code
#
# Usage:
#   make all        - Build core programs
#   make research   - Build all standard programs
#   make proof      - Compile proof.typ → proof.pdf
#   make examples   - Smoke-test with files in examples/
#   make clean      - Remove binaries and build artifacts
#   make help       - Show targets

CXX       ?= g++
CXXFLAGS  ?= -O3 -std=c++11 -Wall -Iinclude
GMP_LIBS  ?= -lgmpxx -lgmp
TYPST     ?= typst

# Core programs (default `all`)
CORE_BINS = sieve_of_erat calc1 2_ones_random

# Additional research programs
RESEARCH_BINS = consecutive_zeros cond_ones given_prod_2 induction_on_n \
                k_ones check_on_prob large_prime_gap \
                prob/1 prob/2 prob/3 prob/4 given/1

# Optional: requires OpenMP (-fopenmp)
OPENMP_BINS = given/2

.PHONY: all research proof examples clean help \
        sieve calc1 2_ones set consecutive_zeros cond_ones given_prod_2 \
        induction_on_n k_ones check_on_prob large_prime_gap \
        prob1 prob2 prob3 prob4 given1 given2

all: $(CORE_BINS)

research: $(CORE_BINS) $(RESEARCH_BINS)

# --- Paper ---

proof: proof.typ bibliography.bib
	$(TYPST) compile proof.typ proof.pdf
	@echo "Built proof.pdf"

# --- Core ---

sieve: sieve_of_erat
sieve_of_erat: sieve_of_erat.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

calc1: calc1.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

2_ones: 2_ones_random
2_ones_random: 2_ones_random.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

set: set_approach.cpp
	$(CXX) $(CXXFLAGS) $< $(GMP_LIBS) -o set_approach
	@echo "Built set_approach (GMP)"

# --- Research programs ---

consecutive_zeros: consecutive_zeros.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

cond_ones: cond_ones.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

given_prod_2: given_prod_2.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

induction_on_n: induction_on_n.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

k_ones: k_ones.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

check_on_prob: check_on_prob.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

large_prime_gap: large_prime_gap.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

prob/1: prob/1.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

prob/2: prob/2.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

prob/3: prob/3.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

prob/4: prob/4.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

given/1: given/1.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Built $@"

given/2: given/2.cpp
	$(CXX) $(CXXFLAGS) -fopenmp $< -o $@
	@echo "Built $@ (OpenMP)"

prob1: prob/1
prob2: prob/2
prob3: prob/3
prob4: prob/4
given1: given/1
given2: given/2

# --- Examples (smoke tests) ---

examples: calc1 consecutive_zeros
	@echo "Running calc1 on examples/calc1_twin.txt ..."
	./calc1 examples/calc1_twin.txt /tmp/prime_calc1_out.txt
	@cat /tmp/prime_calc1_out.txt
	@echo "Running consecutive_zeros on examples/consecutive_zeros.txt ..."
	./consecutive_zeros examples/consecutive_zeros.txt /tmp/prime_consec_out.txt
	@head -5 /tmp/prime_consec_out.txt
	@echo "Examples OK"

# --- Clean ---

clean:
	rm -f $(CORE_BINS) set_approach $(RESEARCH_BINS) $(OPENMP_BINS)
	rm -f a.out
	@echo "Cleaned binaries"

# --- Help ---

help:
	@echo "CRT / Hardy–Littlewood Research — Build System"
	@echo "=============================================="
	@echo ""
	@echo "  make all          Core: sieve_of_erat, calc1, 2_ones_random"
	@echo "  make research     All standard programs (excl. optional OpenMP)"
	@echo "  make proof        Compile proof.typ → proof.pdf"
	@echo "  make examples     Run smoke tests from examples/"
	@echo "  make clean        Remove binaries"
	@echo ""
	@echo "Individual targets:"
	@echo "  sieve calc1 2_ones set consecutive_zeros cond_ones"
	@echo "  given_prod_2 induction_on_n k_ones check_on_prob"
	@echo "  large_prime_gap prob1 prob2 prob3 prob4 given1 given2"
	@echo ""
	@echo "See README.md for input formats and paper-to-code mapping."
