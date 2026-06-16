CXX      ?= g++
CXXFLAGS ?= -O3 -std=c++11 -Wall -Iinclude
GMP_LIBS ?= -lgmpxx -lgmp
BINDIR   ?= bin

CORE = $(BINDIR)/sieve_of_erat $(BINDIR)/calc1 $(BINDIR)/2_ones_random

RESEARCH = $(CORE) \
	$(BINDIR)/consecutive_zeros $(BINDIR)/cond_ones $(BINDIR)/given_prod_2 \
	$(BINDIR)/induction_on_n $(BINDIR)/prob2 $(BINDIR)/prob3 $(BINDIR)/prob4 \
	$(BINDIR)/given1 $(BINDIR)/k_ones $(BINDIR)/check_on_prob \
	$(BINDIR)/large_prime_gap

.PHONY: all research proof examples clean set given2

all: $(CORE)
research: $(RESEARCH)

$(BINDIR):
	mkdir -p $(BINDIR)

proof:
	typst compile proof.typ proof.pdf

$(BINDIR)/sieve_of_erat: src/core/sieve_of_erat.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/calc1: src/core/calc1.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/2_ones_random: src/core/2_ones_random.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/set_approach: src/set/set_approach.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< $(GMP_LIBS) -o $@

$(BINDIR)/consecutive_zeros: src/gap/consecutive_zeros.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/cond_ones: src/gap/cond_ones.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/large_prime_gap: src/gap/large_prime_gap.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BINDIR)/induction_on_n: src/moments/histogram.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/prob2: src/moments/moment_budget.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/prob3: src/moments/moment_single.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/prob4: src/moments/moment_ratio.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/k_ones: src/moments/k_ones.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/check_on_prob: src/moments/check_on_prob.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@

$(BINDIR)/given1: src/given/early_one.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@
$(BINDIR)/given2: src/given/early_one_omp.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) -fopenmp $< -o $@
$(BINDIR)/given_prod_2: src/given/prod_enum.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $< -o $@

set: $(BINDIR)/set_approach
given2: $(BINDIR)/given2

examples: $(BINDIR)/calc1 $(BINDIR)/consecutive_zeros
	$(BINDIR)/calc1 examples/calc1_twin.txt /tmp/out.txt
	$(BINDIR)/consecutive_zeros examples/consecutive_zeros.txt /tmp/out2.txt

clean:
	rm -rf $(BINDIR)
