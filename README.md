# Improved CRT Intersection Methods and Qualitative Hardy–Littlewood Prime K-Tuples

C++ experiments for the paper in [`proof.typ`](proof.typ). The writeup is also in [`proof.pdf`](proof.pdf); compile with `make proof` if you change the Typst source. References live in [`bibliography.bib`](bibliography.bib); there's a short supplement in [`sec-consec-budget.typ`](sec-consec-budget.typ).

The basic setup: same residue data, two waiting-time models.

1. **First distribution (I)** — CRT intersection on a scan; positions are **ONE** or **ZERO**.
2. **Second distribution (II)** — independent geometric trials at rate \(q_i = m_i / p_i\).

The programs enumerate configurations, compare moment budgets, and run the finite sieve checks behind the combinatorial arguments in the paper. Shared logic lives in `include/prime/` (CRT bitmasks, residue enumeration, coverage bounds, input parsing).

## What maps to what

Rough guide from paper sections to code:

- **§2 (framework)** — CRT configs, ONE count \(M = \prod m_i\): `set_approach.cpp`, `induction_on_n.cpp`
- **§3 (waiting times)** — first vs second moments: `calc1.cpp`, `k_ones.cpp`, `2_ones_random.cpp`, `cond_ones.cpp`, stuff in `prob/`
- **§4 (early ONEs)** — gap budget \(L_0 \le P - M\), bad configs: `consecutive_zeros.cpp`, `given_prod_2.cpp`, `given/`
- **§5 (HL tuples)** — admissible \(\mathbf{h}\), trial division: `sieve_of_erat.cpp`, `large_prime_gap.cpp`

`check_on_prob.cpp` sanity-checks output from `prob/1.cpp`. `compact_n.cpp` is half-finished and not built by default.

## Getting started

You'll want a C++11 compiler. Typst is optional (`make proof`). GMP only for `set_approach`; OpenMP only if you build `given/2.cpp` (`make given2`).

```bash
make all          # core programs
make research     # everything except optional OpenMP
make proof        # proof.typ → proof.pdf
make examples     # quick smoke tests
make help         # full target list
```

Example run:

```bash
make calc1
./calc1 examples/calc1_twin.txt /tmp/out.txt
```

## Input format

Most programs take a config file like:

```
<number_of_test_cases>
<number_of_moduli>
<prime_1> <multiplicity_1>
<prime_2> <multiplicity_2>
...
```

Here \(m_i = |S_i|\) is how many ONEs you allow mod \(p_i\). For the twin-prime tail \(\mathbf{h} = (0,2)\) on odd primes, that's \(m_i = p_i - 2\) — see `examples/calc1_twin.txt`.

Exceptions: `2_ones_random` wants `p k x` per case; `sieve_of_erat` takes `<limit> <output_file>`; `large_prime_gap` reads primes from stdin plus a threshold arg.

## Programs

| Program | What it does |
|---------|----------------|
| `sieve_of_erat` | Primes up to \(n\) |
| `calc1` | Combinatorial vs log probability bounds → `0`/`1` per case |
| `2_ones_random` | 2/3-tuple bounds on a random domain |
| `set_approach` | Set enumeration (needs GMP) |
| `consecutive_zeros` | Longest run of ZEROs before the first ONE |
| `cond_ones` | Conditional ONE probability vs full range |
| `given_prod_2` | Product-moduli enumeration |
| `induction_on_n` | Walk configurations, count bad ones |
| `k_ones` | k-th ONE waiting time for two moduli |
| `check_on_prob` | Check `prob/` output ratios |
| `large_prime_gap` | Flag unusually large prime gaps |
| `prob/1`–`prob/4` | Moment enumeration variants |
| `given/1`, `given/2` | Fixed prime-list analysis |

Sample inputs are in `examples/`.

## Background (one paragraph)

Pairwise coprime \((p_i)\), allowed sets \(S_i\) with \(|S_i| = m_i\). The CRT intersection \(D(\mathbf{S})\) has \(M = \prod m_i\) ONEs per period \(P = \prod p_i\). For admissible Hardy–Littlewood \(\mathbf{h}\), the paper's deterministic config uses \(m_i = p_i - |F_{p_i}(\mathbf{h})|\) and proves qualitative prime \(k\)-tuples below \(p_{n+1}^2\) at enough sieve depth — not the classical singular-series density. The code pokes at gap budgets (\(L_0 \le P - M\)), moment ordering (\(E[W^{(I)}] > E[W^{(II)}]\)), and bad configs with no early ONE.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). Open an issue if something's unclear.
