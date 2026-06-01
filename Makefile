# Makefile for Prime Tuple Research Programs
# 
# Usage:
#   make sieve      - Build Sieve of Eratosthenes
#   make calc1      - Build probability calculator
#   make set        - Build set-based approach (requires GMP)
#   make 2_ones     - Build 2-tuple analyzer
#   make all        - Build all programs
#   make clean      - Remove all compiled binaries

CXX = g++
CXXFLAGS = -O3 -std=c++11 -Wall

# Standard compilation flags
STANDARD_FLAGS = $(CXXFLAGS)

# GMP compilation flags (for arbitrary precision)
GMP_FLAGS = $(CXXFLAGS) -lgmpxx -lgmp

# Optional: Path to GMP library if installed via package manager
# GMP_PATH = -L/home/vishal340/vcpkg/packages/gmp_x64-linux/lib
GMP_LIBS = $(GMP_FLAGS) $(GMP_PATH)

# Default target
.PHONY: all clean help

all: sieve calc1 2_ones

# Sieve of Eratosthenes
sieve: sieve_of_erat.cpp
	$(CXX) $(STANDARD_FLAGS) $< -o sieve_of_erat
	@echo "Built sieve_of_erat"

# Probability Calculator
calc1: calc1.cpp
	$(CXX) $(STANDARD_FLAGS) $< -o calc1
	@echo "Built calc1"

# 2-Tuple and K-Tuple Analysis
2_ones: 2_ones_random.cpp
	$(CXX) $(STANDARD_FLAGS) $< -o 2_ones_random
	@echo "Built 2_ones_random"

# Set-based approach (requires GMP library)
set: set_approach.cpp
	$(CXX) $(GMP_LIBS) $< -o set_approach
	@echo "Built set_approach (with GMP support)"

# Additional programs
consecutive_zeros: consecutive_zeros.cpp
	$(CXX) $(STANDARD_FLAGS) $< -o consecutive_zeros
	@echo "Built consecutive_zeros"

given_prod_2: given_prod_2.cpp
	$(CXX) $(STANDARD_FLAGS) $< -o given_prod_2
	@echo "Built given_prod_2"

induction_on_n: induction_on_n.cpp
	$(CXX) $(STANDARD_FLAGS) $< -o induction_on_n
	@echo "Built induction_on_n"

k_ones: k_ones.cpp
	$(CXX) $(STANDARD_FLAGS) $< -o k_ones
	@echo "Built k_ones"

# Clean all compiled binaries
clean:
	rm -f sieve_of_erat calc1 2_ones_random set_approach
	rm -f consecutive_zeros given_prod_2 induction_on_n k_ones
	rm -f a.out
	@echo "Cleaned all binaries"

# Display help information
help:
	@echo "Prime Tuple Research - Build System"
	@echo "===================================="
	@echo ""
	@echo "Available targets:"
	@echo "  make sieve           - Build Sieve of Eratosthenes"
	@echo "  make calc1           - Build probability calculator"
	@echo "  make 2_ones          - Build 2-tuple analyzer"
	@echo "  make set             - Build set-based approach (requires GMP)"
	@echo "  make all             - Build all standard programs"
	@echo "  make clean           - Remove all compiled binaries"
	@echo "  make help            - Display this help message"
	@echo ""
	@echo "Example usage:"
	@echo "  make sieve"
	@echo "  ./sieve_of_erat 1000 output.txt"
	@echo ""
	@echo "For GMP library installation, see README.md"
