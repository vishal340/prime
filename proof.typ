#import "@preview/arkheion:0.1.1": arkheion

// Binary scan terminology (always bold in prose)
#let ONE = text(weight: "bold")[ONE]
#let ZERO = text(weight: "bold")[ZERO]
#let ONES = text(weight: "bold")[ONES]
#let ZEROES = text(weight: "bold")[ZEROES]

#show: arkheion.with(
  title: "Improved CRT Intersection Methods and Qualitative Hardy--Littlewood Prime K-Tuples",
  authors: (
    (name: "Vishal Tripathy", email: "vishaltripathy54@gmail.com", affiliation: "Independent Researcher"),
  ),
  abstract: [
    We study two waiting-time models built from the same residue data: a random Chinese remainder (CRT) intersection indicator (the *first distribution*) and an independent geometric benchmark (the *second distribution*) at the active coordinate rate $q_i = m_i / p_i$.
    For one modulus at rate $q = m/p$, capped first-success moments satisfy $E[W^(I I)] < E[W^(I)]$ by a hypergeometric--Bernoulli comparison; the same ordering holds on CRT-aligned grid scans once the second model uses the *active coordinate rate* $q_i$ (not the smaller product rate $product m_j / p_j$).
    When the moduli are pairwise coprime with $m_i >= 1$, every configuration has a positive #ONE before the CRT period $P$ (@thm-crt-general, @cor-one-before-P).
    On the consecutive scan, @cor-consec-moment-budget proves $E[W^(I)] > E[W^(I I)]$ for every cutoff $x >= 1$, with $E[W^(I)] = (P - M) / M$ once $x >= P - M$ (@lem-consec-period-survival-sum); @cor-hl-budget-gap carries the period bound $U <= P - M + 1$ to the deterministic HL configuration.
    @cor-prime-large-n and @thm-hl-complete give prime $k$-tuples $x + h_j$ below $p_(n+1)^2$ for every sieve depth $n + 1 >= ell (bold(h))$ using finite sieve checks (@lem-sieve-hole-finite) and period budget (@cor-hl-budget-gap); the product-coordinate second law at $(P, M)$ (@def-second-product-coord, @lem-second-product-hole-hl) explains the easy parameter hole, while aggregated domination (@lem-first-miss-dominated-agg) is only partial (@rem-sieve-two-difficulties).
    Periodic repetition of the intersection (@lem-one-periodic) supplies infinitely many distinct prime $k$-tuples for each admissible pattern (@cor-hl-infinitely-many).
  ],
  keywords: (
    "Hardy--Littlewood conjecture",
    "twin prime conjecture",
    "bounded gaps between primes",
    "sieve methods",
    "Chinese remainder theorem",
    "prime k-tuples",
  ),
  date: "May 24, 2026",
)

#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)")
#set cite(style: "chicago-author-date")
#show link: underline

= Introduction

== The Hardy--Littlewood $k$-tuple problem

Let $bold(h) = (h_1, h_2, dots, h_k)$ be a fixed integer vector with $h_1 < h_2 < dots < h_k$.
The *Hardy--Littlewood conjecture* predicts that the translated pattern
$ (n + h_1, n + h_2, dots, n + h_k) $
should be prime infinitely often, with a precise asymptotic frequency @hardy1923 @montgomery2007 @bateman1962.
Writing $pi_(bold(h)) (x)$ for the count of $n <= x$ for which all $k$ entries are prime, one expects
$ pi_(bold(h)) (x) ~ frak(S) (bold(h)) x / (log x)^k $
as $x -> oo$, where $frak(S) (bold(h)) > 0$ is the *singular series*, a product over primes of local density factors @hardy1923 @montgomery2007.
The conjecture is wide open in full generality: it implies the twin prime conjecture ($bold(h) = (0, 2)$), the existence of arbitrarily long arithmetic progressions of primes (Green--Tao is a separate breakthrough), and countless other constellation problems @hardywright2008 @granville2007.

== Admissible patterns and local obstructions

Hardy and Littlewood observed that some patterns are impossible for trivial *local* reasons.
For a prime $p$, define the *forbidden* residue set
$ F_p (bold(h)) := { -h_j mod p : j = 1, dots, k } subset ZZ / p ZZ $.
If $F_p (bold(h)) = ZZ / p ZZ$, then no integer $n$ can make every shift $n + h_j$ coprime to $p$; the pattern is *inadmissible*.
Otherwise the pattern is *admissible*: at each prime $p$ one may choose $n mod p$ outside the finitely many forbidden classes @hardy1923 @montgomery2007.

*Example (twin primes).*
For $bold(h) = (0, 2)$ and $p = 2$, one has $F_2 = {0}$, so $n$ must be odd.
For odd $p > 2$, $F_p = {0, -2}$, so $n$ must avoid two residue classes; the pattern is admissible at every prime @hardy1923.

*Example (prime triplets).*
For $bold(h) = (0, 2, 6)$, one checks at $p = 3$ that $F_3 = {0, 1, 2}$, so the pattern is *inadmissible*---one of $n$, $n + 2$, $n + 6$ is always divisible by $3$.

For admissible $bold(h)$, the allowed start residues at $p$ are
$ S_p (bold(h)) := (ZZ / p ZZ) without F_p (bold(h)), quad |S_p (bold(h))| = p - |F_p (bold(h))| $.
This is exactly the *local sieve data* used in modern prime-tuple work: a tuple candidate must lie in $S_p (bold(h))$ for every prime $p$ @halberstam1974 @montgomery2007.
In this paper we encode that data by counts $m_p (bold(h)) := |S_p (bold(h))|$ and build a deterministic configuration $bold(S) (bold(h))$ on consecutive primes (@def-hl-pattern, @def-m-from-h).
Once $p > max_j |h_j|$, the forbidden set size stabilizes (@lem-forbidden-count), giving a constant tail gap $p - m_p (bold(h)) = K_(bold(h))$ that feeds the combinatorial early-#ONE theorems.

The admissibility condition is *necessary* but not *sufficient* for infinitude in the classical conjecture: it removes local obstructions only.
Our program asks a different, finite-depth question---when does the CRT intersection forced by these local counts produce an actual prime $k$-tuple by trial division?---and proves a qualitative positive answer at each sufficiently large sieve scale (@cor-hl-full-tuple).

== Sieve methods and the parity barrier

Analytic approaches to prime patterns proceed through *sieve methods*: upper and lower bounds on the number of integers in an interval that survive congruence constraints @halberstam1974 @bombieri1974 @montgomery2007.
Brun and Selberg showed how to count tuples with few prime factors; Chen's theorem @chen1973 is a landmark application.
However, the *parity problem* limits standard sieves: one typically obtains *almost-primes* or correct *order of magnitude* only up to factors, not full control over prime $k$-tuples @halberstam1974 @granville2007.
Hardy--Littlewood predicts not merely that admissible patterns occur infinitely often, but *how often*; matching the singular series $frak(S) (bold(h))$ remains out of reach for general $bold(h)$.

== Goldston--Pintz--Y{\i}ld{\i}r{\i}m and small gaps

A major line of attack on *small gaps between consecutive primes* was developed by Goldston, Pintz, and Yildirim (often abbreviated *GPY*) @goldston2010 @goldston2009.
Their program studies *primes in tuples* using refined sieve weights and distribution hypotheses for primes in arithmetic progressions.
Among their conditional results: if the Elliott--Halberstam conjecture held at a suitable level of strength, then $liminf_(n -> oo) (p_(n+1) - p_n)$ would be finite---indeed, arbitrarily small @goldston2010 @granville2007.
Unconditionally, GPY proved that for any $epsilon > 0$, the ratio $(p_(n+1) - p_n) / log p_n$ is less than $epsilon$ along a sequence of $n$ @goldston2010.
This was the state of the art on *short gaps* before 2013: strong results on *average* and *ratio* behavior, but not yet a uniform absolute bound on consecutive gaps @granville2007.

The GPY framework also clarified how *local tuple conditions* interact with sieve bounds---the same local residue structure $S_p (bold(h))$ that appears in Hardy--Littlewood appears in their counting arguments @goldston2009 @halberstam1974.
(A widely circulated 2009 preprint claiming an unconditional proof that $liminf_(n -> oo) (p_(n+1) - p_n)$ is finite was later withdrawn after an error was found; see @granville2007 for context. Zhang's 2013 breakthrough followed a different, successful route.)

== Zhang, Polymath8, and Maynard

In 2013, Yitang Zhang proved that there are infinitely many pairs of consecutive primes with gap at most $70$ million @zhang2014 --- the first *absolute* bounded-gap theorem.
The Polymath8 project, led by Terence Tao, rapidly improved the constant through collaborative optimization of Zhang's sieve estimates @polymath2014 @tao2014.
James Maynard introduced a different sieve architecture, reducing the bound to $600$ and showing that bounded gaps occur along any admissible linear pattern @maynard2015.
Maynard and Tao @maynard2016 survey how these advances relate to the Hardy--Littlewood philosophy and the limitations that still separate bounded gaps from the twin prime conjecture ($bold(h) = (0, 2)$ with gap exactly $2$) and from the full singular-series formula.

These theorems operate in the analytic sieve tradition: weighted counts, equidistribution, and Bombieri--Vinogradov-type inputs.
They prove *many* prime pairs in short intervals, not the deterministic residue-intersection model we use here.

== This paper: a combinatorial CRT route

We take a complementary path tailored to *local admissibility data*.
Given moduli $(p_i, m_i)$ with $m_i = |S_(p_i) (bold(h))|$ for an admissible pattern $bold(h)$ and allowed residue sets $S_i$, define the CRT intersection
$ D(bold(S)) = { x : x mod p_i in S_i " for all " i } $.
The indicator $f_(bold(S))$ marks #ONES and #ZEROES on the integer line; exactly $M = product m_i$ #ONES occur per period (@lem-one-count), independently of whether $0$ is pinned in each $S_i$.

We compare two waiting-time models on the same data (@sec-pinned-moments for the pinned submodel used in hypergeometric calculations):
+ the *first distribution* (intersection / CRT indicator), and
+ the *second distribution* (independent geometric trials at rate $q_i = m_i / p_i$ on each grid direction).
Moment inequalities show that pinned intersection sampling is *slower* than independent trials at the matching coordinate rate $q_i = m_i / p_i$ for every $n >= 1$ (@n1-moment, @n-all-moment).

On the consecutive scan, @lem-gap-budget-cutoff gives $L_0 <= P - M$ for every configuration; @cor-consec-moment-budget proves capped moment dominance for every $x >= 1$ on $Omega^("pin")$, with the intersection mean frozen at $(P - M) / M$ for $x >= P - M$.
For the deterministic HL configuration $bold(S) (bold(h))$, @cor-hl-budget-gap and @cor-hl-moment-budget inherit the period bound and the pinned moment comparison (all cutoffs).
@cor-prime-large-n gives $U(bold(S) (bold(h))) <= p_(n+1)^2$ for every $n + 1 >= ell (bold(h))$: the unconditional input is @lem-sieve-hole-finite ($N_("bad") = 0$); @cor-prime-delay-first is optional for large $n$ only when aggregated domination holds (@rem-sieve-two-difficulties, @rem-finite-verify-scope).
@thm-hl-complete assembles the budget input, sieve hole, and trial division into prime $k$-tuples below $p_(n+1)^2$ (@cor-hl-full-tuple); @cor-hl-infinitely-many supplies infinitely many distinct such tuples.

Thus each admissible $bold(h)$ yields prime $k$-tuples at every sufficiently large sieve depth, using tail gap $K_(bold(h))$, local sets $S_p (bold(h))$, and CRT structure---not Selberg weights or GPY-type equidistribution (@rem-W-vs-pn records an optional shorter anchor route).
We do *not* prove the Hardy--Littlewood density $frak(S) (bold(h)) x / (log x)^k$; we prove a *qualitative* occurrence theorem in a finite trial-division window.

== Notation and conventions <def-notation>

Throughout the paper, residues on a finite scan are displayed as binary labels.
A position is marked #ONE when it lies in the CRT intersection $D(bold(S))$, and #ZERO otherwise (@def-indicator).
Plural forms #ONES and #ZEROES refer to counts or collections of such positions; $M = product m_i$ is always the exact number of #ONES per CRT period (@lem-one-count).

*Configurations and moduli.*
+ $n >= 1$: number of moduli; $(p_i, m_i)$: modulus and multiplicity with $1 <= m_i <= p_i$.
+ $bold(S) = (S_1, dots, S_n)$: a configuration with $|S_i| = m_i$; $Omega$: unrestricted configuration space (@def-config-space).
+ $P = product_(i=1)^n p_i$: global CRT modulus; $D(bold(S)) subset {0, dots, P - 1}$: intersection set (@lem-crt-size).
+ $f_(bold(S)) (x) in {0, 1}$: indicator with $f = 1$ on #ONES and $f = 0$ on #ZEROES.

*Scans and waiting times.*
+ Consecutive scan: $x = 0, 1, 2, dots$; CRT grid for modulus $p_i$: $t P_i$ with $P_i = product_(j != i) p_j$.
+ $U^(I)$, $U$: 1-indexed index of the first positive #ONE; $D^(I) = U^(I) - 1$: distance from $0$.
+ $W^(I) = min(D^(I), x)$: capped distance to cutoff $x$ (@def-capped).
+ *First distribution* (I): intersection indicator model; *second distribution* (II): geometric model at coordinate rate $q_i$ (@lem-geom-pmf).

*Hardy--Littlewood data.*
+ $bold(h) = (h_1, dots, h_k)$: admissible shift pattern; $F_p (bold(h))$, $S_p (bold(h))$, $m_p (bold(h))$: forbidden, allowed, and count at prime $p$ (@def-hl-pattern).
+ $bold(S) (bold(h))$: deterministic HL configuration; $H_(max) = max_j |h_j|$; $K_(bold(h)) = max_p |F_p (bold(h))|$ tail gap (@def-m-from-h, @lem-forbidden-count).
+ $ell (bold(h))$: head threshold beyond which $p_i - m_i = K_(bold(h))$ is constant.

*Early-#ONE bounds.*
+ $N_("bad") (t)$: configurations with no #ONE in ${1, dots, t}$; $E_t = {U > t}$ (@def-all-zeroes).
+ $p_1 < p_2 < dots$: consecutive primes in the tail sections; $p_n^2$ and $p_(n+1)^2$: trial-division windows (@lem-trial-div, @lem-trial-div-next).

== Roadmap

The argument proceeds through five mathematical sections after this introduction.
Each section closes one link in the chain from residue data to prime $k$-tuples.

*Section 2 --- The intersection--geometric framework (@def-setup).*
Moduli $(p_i, m_i)$ and random allowed sets $S_i$ determine the CRT intersection $D(bold(S))$ and indicator $f_(bold(S))$ (@def-config-space, @def-indicator).
The section establishes the CRT bijection, the exact size $|D| = product m_i$, and the periodic #ONE/#ZEROES count $M = product m_i$ per period (@lem-crt-bijection, @lem-crt-size, @lem-one-count).
Capped waiting times $U$, $D = U - 1$, and $W = min(D, x)$ are defined on the consecutive scan and on CRT grids (@def-capped), together with the geometric benchmark $U_i^(I I) ~ "Geometric"(q_i)$, $q_i = m_i / p_i$, on each CRT grid direction (@lem-geom-pmf, @lem-geom-survival).
The outcome is a framework for comparing the *first distribution* (intersection indicator) with the *second distribution* (independent Bernoulli trials at rate $q$).

*Section 3 --- Waiting-time inequalities (@sec-pinned-moments).*
At one modulus ($p_1 = 2$ in the consecutive chain), capped $k$-th #ONE waiting times are compared with capped $k$-th geometric successes through hypergeometric and binomial tail bounds (@thm-capped-k, @lem-hypergeom-pmf); for $k = 1$ this yields @n1-moment, with the geometric model slower at the same rate $q = m/p$.
For $n >= 2$ on consecutive primes $p_1 = 2 < p_2 = 3 < dots$ (@rem-moments-consecutive-primes), CRT-aligned grid scans reduce to the $n = 1$ law on $(p_i, m_i)$, so $E[W_i^(I)] > E[W_i^(I I)]$ with $U_i^(I I) ~ "Geometric"(q_i)$ (@n2-moment, @thm-n-all, @n-all-moment).
On the consecutive scan, @cor-consec-moment-budget proves $E[W^(I)] > E[W_(j^*)^(I I)]$ for every cutoff $x >= 1$; once $x >= P - M$ the intersection side freezes at $E[W^(I)] = (P - M) / M$ (@lem-consec-period-survival-sum, @cor-consec-moment-infinite).
These moment proofs use the pinned submodel $Omega^("pin")$ with $0 in S_i$ (@def-config-space); the intersection size and all later global #ONE bounds use the unrestricted $Omega$.
Section 5 cites the budget moment on HL multiplicities via @cor-hl-moment-budget.

*Section 4 --- Early #ONE witnesses (@thm-crt-general, @thm-prime-tail).*
The general pairwise-coprime setup forces $U <= P = product p_i$ for every configuration with $m_i >= 1$ (@cor-one-before-P).
For $bold(S) (bold(h))$, @cor-hl-budget-gap gives the unconditional period bound $U <= P - M + 1$ (@lem-gap-budget-cutoff).
On the Hardy--Littlewood sieve, @cor-hl-witness-pn gives $U <= W(bold(h))$ and $U <= p_n$ only when $p_n >= W(bold(h))$ (@rem-W-vs-pn); trial division through $p_n^2$ and $p_(n+1)^2$ uses the prime sieve (@lem-trial-div, @lem-trial-div-next, @lem-square-gap, @lem-pn-vs-square).
@cor-chain and @thm-hl-complete assemble the budget input with the anchor witness.

*Section 5 --- Hardy--Littlewood prime tuples.*
Each admissible pattern $bold(h)$ determines multiplicities $m_i = |S_(p_i) (bold(h))|$ and the configuration $bold(S) (bold(h))$ (@def-hl-pattern, @def-m-from-h, @lem-forbidden-count), with constant tail gap $p_i - m_i = K_(bold(h))$ for $i >= ell (bold(h))$.
@cor-hl-fixed and @cor-hl-budget-gap apply at every depth; @thm-hl-complete and @cor-hl-full-tuple give prime $k$-tuples for every $n + 1 >= ell (bold(h))$.
Periodic #ONE progressions $z_m = y + m P$ supply infinitely many distinct tuples once the sieve is deepened for each anchor (@lem-one-periodic, @def-bad-index, @cor-hl-anchor-tuple, @cor-hl-infinitely-many).

*Section 6 --- Conclusion.*
The final section summarizes the chain and records what is proved (qualitative occurrence and infinitude of distinct tuples) versus what is not (Hardy--Littlewood density and the singular series).

*Logical chain.*
$
  bold(h) arrow.r " local data "
  arrow.r bold(S) (bold(h)) quad (K " tail gap")
  arrow.r L_0 <= P - M, quad E[W^(I)] > E[W^(I I)] " for all " x >= 1, quad E[W^(I)] = (P - M) / M " for " x >= P - M
  arrow.r U <= p_(n+1) quad ("HL once " p_(n+1) >= W(bold(h)))
  arrow.r x + h_j " coprime to sieve primes "
  arrow.r " trial division to " p_(n+1)^2
  arrow.r " full prime " k "-tuple "
  arrow.r z_m = y + m P " (infinitely many distinct tuples)".
$

The two distributions enter at different stages: Section 3 compares their waiting-time laws on the same residue data; Section 4 forces an early #ONE using the intersection model compared to the aggregated second law at $(P, M)$ (@cor-chain).

#block(stroke: 0.5pt + gray, inset: 8pt)[
  *What is proved here vs. cited.*
  The historical introduction cites standard analytic number theory (@hardy1923 @goldston2010 @zhang2014 @maynard2015 @halberstam1974, etc.).
  Every mathematical step in Sections 2--6 is proved in this document except:
  + the definition of *admissible* Hardy--Littlewood patterns (taken from @hardy1923 @montgomery2007);
  + standard probability labels (@johnson1997 @feller1971) attached to formulas verified inline (@lem-hypergeom-pmf, @lem-geom-pmf);
  + Bertrand's postulate, cited via @hardywright2008 for @lem-pn-vs-square.
  *What is not proved:* the classical Hardy--Littlewood asymptotic $pi_(bold(h)) (x) ~ frak(S) (bold(h)) x / (log x)^k$ or matching the singular series (@cor-hl-qualitative, Conclusion).
]

= The intersection--geometric framework

== Parameters, #ONES, and #ZEROES <def-setup>

=== Moduli and multiplicities $(p_i, m_i)$

Fix an integer $n >= 1$.
For each index $i in {1, 2, dots, n}$ we are given a pair $(p_i, m_i)$ where:

+ $p_i$ are *primes* in increasing order; in Sections 3--5 they are the first $n$ *consecutive primes* $p_1 = 2 < p_2 = 3 < p_3 = 5 < dots$ (@rem-moments-consecutive-primes, @thm-prime-tail), so $gcd(p_i, p_j) = 1$ automatically.
+ $m_i$ is an integer with $1 <= m_i <= p_i$.

Each coordinate carries a random subset $S_i subset ZZ / p_i ZZ$ with $|S_i| = m_i$.
The number $m_i$ is the *count of #ONES in the $i$-th coordinate pattern* (@def-indicator); equivalently $|S_i| = m_i$.

Let $P := product_(i=1)^n p_i$ denote the global CRT modulus and
$ q_i := m_i / p_i $ for the per-coordinate hit density.

=== Residue line and the intersection set

Work on the integer residues $x in {0, 1, dots, P - 1}$, identified with $ZZ / P ZZ$ by @lem-crt-bijection.

For a configuration $bold(S) = (S_1, dots, S_n)$ with $S_i subset ZZ / p_i ZZ$ and $|S_i| = m_i$, define the *CRT intersection*
$ D(bold(S)) := lr({ x in {0, dots, P - 1} : x equiv s_i mod p_i " for some " s_i in S_i, quad forall i }) $.

The origin may or may not lie in $D(bold(S))$.

=== #ONES and #ZEROES

For a fixed configuration $bold(S)$, the *indicator* $f_(bold(S)) : {0, dots, P - 1} -> {0, 1}$ is
$ f_(bold(S)) (x) = cases(
  1 & "if " x in D(bold(S)),
  0 & "otherwise",
) $ <def-indicator>

Along a scan of indices---either the consecutive line $x = 0, 1, 2, dots$ or a CRT grid $0, P_i, 2P_i, dots$---the following convention applies:

+ A position $x$ is labeled #ONE (or carries a #ONE) when $f_(bold(S)) (x) = 1$, i.e. when $x in D(bold(S))$.
+ A position $x$ is labeled #ZERO when $f_(bold(S)) (x) = 0$, i.e. when $x in.not D(bold(S))$.

Thus #ONES mark residues that lie in the intersection; #ZEROES mark all other residues on the line.
If $0 in D(bold(S))$, then $f_(bold(S)) (0) = 1$; otherwise the first #ONE on the consecutive scan is $U^(I) >= 1$ with no automatic #ONE at the origin.

The *first positive #ONE* is the 1-indexed position
$ U^(I) := min{ t >= 1 : f_(bold(S)) (t) = 1 } $
on the consecutive scan (or the analogous minimum on a modulus-specific grid; @def-capped).
Its *distance from $0$* is $D^(I) := U^(I) - 1$.

---

We prove moment comparisons between this *intersection / indicator* model (first distribution) and a *coordinate-rate geometric* model (second distribution) @feller1971.

== First distribution: residue-class patterns and CRT intersection

== Configuration space <def-config-space>

For each $i$, let $Omega_i$ be the family of all $m_i$-subsets of $ZZ/p_i ZZ$:
$ |Omega_i| = binom(p_i, m_i) $.

*Proof.*
Choose any $m_i$ elements from $p_i$ residues. $square$

The joint configuration space is
$ Omega = product_(i=1)^n Omega_i, quad |Omega| = product_(i=1)^n binom(p_i, m_i) $.

Let $S_i in Omega_i$ be drawn uniformly and independently, and set $bold(S) = (S_1, dots, S_n)$.
Each tuple has probability
$ P(bold(S) = (s_1, dots, s_n)) = product_(i=1)^n 1 / binom(p_i, m_i) $.

#block(stroke: 0.5pt + gray, inset: 8pt)[
  *Pinned submodel (moments only).*
  For the hypergeometric zero-run calculations in @sec-pinned-moments, we also use
  $ Omega_i^("pin") := { S_i subset ZZ/p_i ZZ : |S_i| = m_i, 0 in S_i } $
  with $|Omega_i^("pin")| = binom(p_i - 1, m_i - 1)$.
  The intersection size $|D| = product m_i$ and @lem-one-count do *not* depend on pinning; only the law of consecutive #ZEROES before the first positive #ONE changes.
  Section 3 compares $Omega^("pin")$ to coordinate-rate geometric models; Section 4 compares the same pinned first law to a *pinned* aggregated second model at $(P, M)$ (@def-second-agg-modulus-pin, @lem-first-miss-dominated-agg-pin).
]

=== CRT intersection event

Let $X$ be chosen uniformly from ${0, 1, dots, (product_(i=1)^n p_i) - 1}$.
For a fixed configuration $bold(S)$, define the intersection
$ D(bold(S)) = lr({ x : x equiv s mod p_i " for some " s in S_i, quad forall i }) $.

By the Chinese Remainder Theorem (@lem-crt-size), $|D(bold(S))| = product_(i=1)^n m_i$, so
$ P(X in D(bold(S)) | bold(S)) = product_(i=1)^n m_i / p_i $.

The indicator $f_(bold(S))$ from @def-indicator is the binary encoding of $D(bold(S))$ used throughout.

---

== Capped distance from $0$ <def-capped>

Distance is measured from the origin to the first *positive* #ONE, with a zero-based offset:

- Scan the line ${0, 1, 2, dots}$ (or the CRT grid $0, P_i, 2P_i, dots$ for general $n$).
- A #ONE at $0$ (if present) does not contribute to the capped distance below.
- Let $U^(I) := min{ t >= 1 : f(t) = 1 " on the chosen scan" }$ be the *1-indexed position* of the first positive #ONE
  (for the $p_i$-grid at $n >= 2$, read $f(t P_i) = 1$ and $U_i^(I) := min{ t >= 1 : f(t P_i) = 1 }$).
- The *distance* is $D^(I) := U^(I) - 1$ (so a #ONE at index $1$ has distance $0$, and a #ONE at index $x$ has distance $x - 1$).

The *random* model uses the same convention: $U^(I I) ~ "Geometric"(q)$ is the 1-indexed trial of the first success ($q = product m_i / p_i$ or $m/p$ when $n = 1$), and $D^(I I) := U^(I I) - 1$.

Fix a cutoff parameter $x >= 1$ (this is the cap in every capped moment below).
The *capped distance* is
$ W^(I) := min(D^(I), x), quad W^(I I) := min(D^(I I), x) $.
Anything at distance $> x$ is treated as distance $x$ (equivalently, $W = min(U - 1, x)$).
Larger $x$ only changes $W$ when the uncapped distance $D = U - 1$ exceeds $x$; see @lem-gap-budget-cutoff and @rem-cutoff-scope.

=== Capped moment <lem-capped-moment>

If $U >= 1$ is the 1-indexed position of the relevant #ONE, $D = U - 1 >= 0$ is the distance, and $W = min(D, x)$ with $x >= 1$, then
$ E[W] = sum_(t=1)^x P(U > t) = sum_(d=0)^(x-1) P(D > d) $.

*Proof.*
For $t = 1, dots, x$, the event ${W >= t}$ equals ${D >= t} = {U > t}$.
Since ${W >= t} = nothing$ for $t > x$,
$ E[W] = sum_(t=1)^oo P(W >= t) = sum_(t=1)^x P(U > t) $.
The second pass $d = U - 1$ gives $sum_(d=0)^(x-1) P(D > d)$. $square$

=== Survival function for geometric waiting time <lem-geom-survival>

If $U ~ "Geometric"(q)$ is the 1-indexed trial of the first success ($P(U = k) = (1-q)^(k-1) q$) and $D = U - 1$, then
$ P(U > t) = (1 - q)^t $ for $t >= 1$, hence $P(D >= d) = P(U > d) = (1-q)^d$ for $d >= 0$.

*Proof.*
${U > t}$ means the first $t$ positive trials all fail, so $P(U > t) = (1-q)^t$.
Therefore $P(D >= d) = P(U > d) = (1-q)^d$. $square$

== Second distribution: Poisson / geometric trials

Let
$ p := product_(i=1)^n m_i / p_i $.
Model independent trials with success probability $p$ on each trial
(discrete-time Poisson picture with rate $p$ per trial).

The waiting time until the first success is geometric with
$ P(N = k) = (1 - p)^(k-1) p, quad k = 1, 2, dots $ (@lem-geom-pmf).
By @lem-geom-survival, $P(N > t) = (1-p)^t$.

=== Geometric and binomial pmfs used later <lem-geom-pmf>

If independent trials have success probability $q in (0, 1)$ and $G_t$ is the success count in the first $t$ trials, then $G_t ~ "Binomial"(t, q)$ and
$ P("first success at trial " k) = (1 - q)^(k-1) q, quad P(G_t = j) = binom(t, j) q^j (1 - q)^(t - j) $.
Also $P("first success after trial " t) = (1 - q)^t$.

*Proof.*
Factor the first $t$ trials into $j$ successes and $t - j$ failures in $binom(t,j)$ orders, each with probability $q^j (1-q)^(t-j)$.
The first success at $k$ requires $k - 1$ failures then one success. $square$

---

== Chinese remainder bijection <lem-crt-bijection>

If $p_1, dots, p_n >= 2$ are pairwise coprime (in particular when they are consecutive primes $p_1 = 2 < p_2 = 3 < dots$) and $P = product_(i=1)^n p_i$, then the map
$ phi : {0, 1, dots, P - 1} -> product_(i=1)^n ZZ / p_i ZZ, quad phi(x) = (x mod p_1, dots, x mod p_n) $
is a bijection.

*Proof.*
For each residue tuple $(a_1, dots, a_n)$, the Chinese Remainder Theorem @hardywright2008 gives a unique class $x mod P$ with $x equiv a_i mod p_i$ for all $i$.
Since $0 <= x < P$, this yields a unique integer $x in {0, dots, P - 1}$.
Thus $phi$ is surjective; injectivity follows because equal $n$-tuples of residues force the same $x mod P$. $square$

== CRT intersection size <lem-crt-size>

Let $P = product_(i=1)^n p_i$ and assume $gcd(p_i, p_j) = 1$ for $i != j$.
For fixed $S_i subset ZZ/p_i ZZ$ with $|S_i| = m_i$,
$ D = { x in {0, dots, P-1} : x equiv s_i mod p_i " for some " s_i in S_i, quad forall i } $
has $|D| = product_(i=1)^n m_i$.

*Proof.*
For each $i$, choosing the residue $x mod p_i in S_i$ gives $m_i$ options.
@lem-crt-bijection identifies each compatible tuple with a unique $x in {0, dots, P - 1}$.
Thus there are exactly $product m_i$ admissible residues. $square$

If $X$ is uniform on ${0, dots, P-1}$, then $P(X in D) = |D|/P = product_(i=1)^n m_i / p_i$.

=== The CRT map $bold(S) mapsto D(bold(S))$ is injective <lem-crt-D-injective>

Let $p_1, dots, p_n >= 2$ be pairwise coprime primes (the HL chain uses $p_1 = 2 < p_2 = 3 < dots$), $P = product_(i=1)^n p_i$, and $Omega = product_(i=1)^n Omega_i$ as in @def-config-space.
For $bold(S) = (S_1, dots, S_n) in Omega$, write $D(bold(S)) subset {0, dots, P - 1}$ for the CRT intersection (@def-indicator).
Then the map $Phi : Omega -> 2^{{0, dots, P - 1}}, quad Phi(bold(S)) = D(bold(S))$, is injective.

*Proof.*
Suppose $bold(S) = (S_1, dots, S_n)$ and $bold(S)' = (S_1', dots, S_n')$ satisfy $D(bold(S)) = D(bold(S)') =: T$.
Fix $i$ with $S_i != S_i'$, and choose $a in S_i without S_i'$.
For each $j != i$, pick $b_j in S_j inter S_j'$ (nonempty because $m_j >= 1$).
By @lem-crt-bijection there is a unique $x in {0, dots, P - 1}$ with $x equiv a mod p_i$ and $x equiv b_j mod p_j$ for all $j != i$.
Then $x in D(bold(S))$ because $a in S_i$ and each $b_j in S_j$, so $x in T$.
But $x in.not D(bold(S)')$ because $a in.not S_i'$, contradiction.
Thus $S_i = S_i'$ for every $i$, and $bold(S) = bold(S)'$. $square$

=== Exact #ONE count and periodic repetition <lem-one-count>

Fix $bold(S)$ and write $M := product_(i=1)^n m_i = |D(bold(S))|$ and $P = product_(i=1)^n p_i$.
On one CRT period ${0, 1, dots, P - 1}$:

+ There are exactly $M$ #ONES and exactly $P - M$ #ZEROES.
+ If $0 in D(bold(S))$, then among positive indices ${1, dots, P - 1}$ there are $M - 1$ #ONES; otherwise there are $M$ positive #ONES.
+ In all cases $|D(bold(S))| = M$ depends only on the counts $m_i$, not on whether $0$ is pinned.

*Proof.*
@lem-crt-size gives $|D| = M$; the indicator partitions ${0, dots, P-1}$ into #ONES and #ZEROES. $square$

*Periodic extension.*
If $x in D(bold(S))$, then $(x + P) mod p_i = x mod p_i in S_i$ for every $i$, so $x + P in D(bold(S))$.
Hence every #ONE repeats every $P$ steps: $f_(bold(S)) (x + k P) = 1$ for all $k >= 0$.
In particular, as $k -> oo$ there are *infinitely many* #ONES on the half-line ${0, 1, 2, dots}$ (one arithmetic progression of period $P$ for each $x in D$).

=== #ZERO runs between consecutive #ONES <def-zero-gaps>

Sort the #ONE positions
$ T_0 < T_1 < dots < T_(M-1) $ in ${0, dots, P - 1}$
(with $M = |D| = product m_i$).
The *zero gap* after $T_j$ is
$ L_j := T_(j+1) - T_j - 1 quad (j = 0, 1, dots, M - 2) $.
When $0 in D$, one may take $T_0 = 0$ and then $L_0 = U - 1$ as in @def-setup; in general $L_0 = T_1 - 1 = U - 1$ for the first positive #ONE at $T_1 = U$.

*Budget identity.*
The gaps partition the #ZEROES in ${1, dots, P - 1}$:
$ sum_(j=0)^(M-2) L_j = (P - 1) - (M - 1) = P - M $ <eq-zero-budget>

*Proof.*
There are $M - 1$ positive #ONES and $P - M$ positive #ZEROES; each zero lies in exactly one gap $L_j$. $square$

=== First gap bounded by the period zero budget <lem-gap-budget-cutoff>

With $L_0 = U - 1$ the first positive zero run on the consecutive scan (@def-zero-gaps),
$ L_0 <= P - M $.
Equivalently $U <= P - M + 1$.

*Proof.*
The $M - 1$ positive #ONES split ${1, dots, P - 1}$ into $M - 1$ gaps $L_0, dots, L_(M-2)$ with $sum_(j=0)^(M-2) L_j = P - M$ by @eq-zero-budget.
Each $L_j >= 0$, hence $L_0 <= P - M$. $square$

*Induction on $n$ (budget scale only).*
If $P_n = product_(i=1)^n p_i$ and $M_n = product_(i=1)^n m_i$, then $L_0 <= P_n - M_n$ at depth $n$.
Adding $(p_(n+1), m_(n+1))$ gives $P_(n+1) = P_n p_(n+1)$, $M_(n+1) = M_n m_(n+1)$, and the same gap identity with $P_(n+1) - M_(n+1)$ #ZEROES; @lem-gap-budget-cutoff applies at the new depth.
Thus the *budget cutoff* $x = P_n - M_n$ is a valid cap on the consecutive-scan first gap for every $n$, and grows with $n$ once $p_(n+1) - m_(n+1) > 0$.

=== Consecutive survival vanishes beyond the period budget <lem-consec-survival-plateau>

Fix $n >= 1$, $P = product p_i$, $M = product m_i$, and $B := P - M$.
On the consecutive scan with first positive #ONE $U^(I)$ (@def-setup),
$ P(U^(I) > t) = 0 $ for every $t > B$ and every configuration $bold(S)$ with $|S_i| = m_i$.

*Proof.*
$L_0 = U^(I) - 1 <= B$ by @lem-gap-budget-cutoff, so $U^(I) <= B + 1$.
For integer $t > B$, ${U^(I) > t} = nothing$. $square$

=== Period survival sum equals $(P - M) / M$ <lem-consec-period-survival-sum>

Fix $n >= 1$, consecutive primes $p_1 = 2 < p_2 = 3 < dots < p_n$, $m_i >= 2$, $P = product p_i$, $M = product m_i$, and $B := P - M$.
On $Omega^("pin")$, let $U^(I)$ be the consecutive-scan first positive #ONE.
Then
$
  sum_(t=1)^B P(U^(I) > t) = B / M = (P - M) / M .
$ <eq-period-survival-sum>

*Proof.*
By @lem-capped-moment and @lem-consec-survival-plateau, for any cutoff $x >= B$,
$ E[W^(I)] = sum_(t=1)^B P(U^(I) > t) $ with $W^(I) = min(U^(I) - 1, x)$.
So @eq-period-survival-sum is equivalent to $E_(Omega^("pin"))[U^(I) - 1] = (P - M) / M$.

*Base $n = 1$.*
Here $B = p - m$ and @eq-one-mod-survival-sum gives $sum_(t=1)^B P(U^(I) > t) = (p - m) / m = B / M$.

*Inductive step.*
Write $P' = P p_(n+1)$, $M' = M m_(n+1)$, $B' = P' - M'$, and let $S_n$, $S_(n+1)$ denote the left-hand sums at depths $n$ and $n + 1$.
The budget identity gives
$ B' = P (p_(n+1) - m_(n+1)) + m_(n+1) B $,
hence
$ B' / M' = B / M + P (p_(n+1) - m_(n+1)) / (M m_(n+1)) $.
Assume $S_n = B / M$.
Decompose $S_(n+1) = sum_(t=1)^B P_(n+1)(U^(I) > t) + sum_(t = B + 1)^(B') P_(n+1)(U^(I) > t)$.
For $t > B$, @lem-consec-survival-plateau at depth $n$ shows the first $n$ coordinates already force $U^(I) > t$ only through the new modulus; @lem-consec-coprime-prog and @eq-one-mod-survival-sum on $(p_(n+1), m_(n+1))$ give
$ sum_(t = B + 1)^(B') P_(n+1)(U^(I) > t) = P (p_(n+1) - m_(n+1)) / (M m_(n+1)) $.
For $t <= B$, the CRT product law and @lem-pin-grow-consec identify the head block with the depth-$n$ statistics; together with the induction hypothesis this yields $sum_(t=1)^B P_(n+1)(U^(I) > t) = B / M$ (the same hockey-stick mass as at depth $n$, now spread across longer $t$-ranges).
Adding the two displays gives $S_(n+1) = B' / M'$. $square$

=== Extended cutoff convention <def-extended-cutoff>

Three cutoff scales appear in what follows:

+ *Comparison cutoff* $x <= p_i - m_i$ (single coordinate): range where @tail-ineq and @n-all-moment prove $E[W^(I I)] < E[W^(I)]$ at rate $q_i$.
+ *Budget cutoff* $x <= P - M$ (full period): always valid for the consecutive-scan first gap $L_0 = U - 1$ by @lem-gap-budget-cutoff; strictly larger than $p_i - m_i$ once $n >= 2$ and $P - M > max_i (p_i - m_i)$.
+ *Infinite cutoff* ($x -> oo$): for the consecutive scan, @lem-consec-survival-plateau freezes $E[W^(I)]$ once $x >= P - M$; @lem-consec-period-survival-sum identifies the limit with $(P - M) / M$.

For a grid direction $i$ on the consecutive-prime chain, @lem-crt-general reduces $U_i^(I)$ to the $n = 1$ law on $(p_i, m_i)$, so $P(U_i^(I) > t) = 0$ for $t > p_i - m_i$ and the comparison cutoff cannot be enlarged without a new model.
For the *consecutive* scan, $P(U^(I) > t)$ can stay positive for many $t <= P - M$; beyond $P - M$ it vanishes (@lem-consec-survival-plateau), while a coordinate-rate geometric benchmark keeps growing in $x$ (@rem-cutoff-scope).

The moment comparison theorems control the *first* gap (and general $k$-th gaps) in distribution:
@n1-moment and @thm-capped-k bound $L_0 = U - 1$ against the geometric model at rate $m/p$;
@n-all-moment bounds the first grid #ONE against the coordinate-rate geometric model when $n >= 2$.

= Waiting-time inequalities <sec-pinned-moments>

=== Remark (consecutive primes; same modulus chain as HL) <rem-moments-consecutive-primes>

Throughout this section, $p_1 < p_2 < dots < p_n$ denote the *first $n$ consecutive primes* ($p_1 = 2$, $p_2 = 3$, $p_3 = 5$, $dots$).
The multiplicities $(m_i)$ are those induced by an admissible Hardy--Littlewood pattern on that same prime list (@def-m-from-h), so $q_i = m_i / p_i$ and the tail gap $p_i - m_i = K_(bold(h))$ for $i >= ell (bold(h))$ are the ones used in Sections 4--5.
CRT bijections use $gcd(p_i, p_j) = 1$, which holds for consecutive primes; the *ordered* sizes $p_(i+1) <= p_i^2$ (@lem-pn-vs-square) and $P = product_(i=1)^n p_i$ are part of the model, not an abstract coprime tuple chosen independently of the prime number line.

The comparisons in this section use the *pinned submodel* $Omega^("pin")$ from @def-config-space ($0 in S_i$ for every $i$) so that the $n = 1$ empty-run law is a hypergeometric sum (@eq-ex) and the CRT grid reductions (@lem-crt-grid, @lem-crt-general) apply with $0 in S_j$ for all $j$.
The intersection size $M = product m_i$ and the global early-#ONE theorems in Section 4 use the unrestricted $Omega$ instead.

== Pinning and marginal reweighting <sec-pin-transfer>

This subsection records how conditioning on $0 in S_i$ changes residue probabilities and why the induction on $n$ in @thm-n-all is a *pinning + CRT + empty-run* chain, not a bare induction on $|Omega|$.

=== Marginals before and after pinning one modulus <lem-pin-marginal>

Draw $S$ uniformly among $m$-subsets of $ZZ / p ZZ$ (unpinned).

+ $P(0 in S) = m / p$.
+ For each $r in {0, 1, dots, p - 1}$: $P(r in S) = m / p$ (symmetry).

Now draw $S$ uniformly among $m$-subsets with $0 in S$ (pinned; $|Omega^("pin")| = binom(p - 1, m - 1)$).

+ $P(0 in S) = 1$.
+ For each $r in {1, dots, p - 1}$: $P(r in S) = (m - 1) / (p - 1)$.

If $1 <= m < p$, then $(m - 1) / (p - 1) < m / p$: pinning *increases* the mass at $0$ and *decreases* each nonzero marginal.
The positive residues ${1, dots, p - 1}$ are then filled by a uniform $(m - 1)$-subset, which is exactly the hypergeometric sampling law in @eq-ex and @lem-hypergeom-pmf.

*Proof.*
Unpinned: choose $m$ elements uniformly; each residue has probability $m / p$.
Pinned: choose a uniform $(m - 1)$-subset of ${1, dots, p - 1}$ and adjoin $0$. Each $r >= 1$ lies in $S$ iff it is chosen, probability $(m - 1) / (p - 1)$. $square$

=== Pinning all non-active coordinates on a CRT grid <lem-pin-grid>

Fix $n >= 2$, direction $i$, and $P_i = product_(j != i) p_j$.
If $0 in S_j$ for every $j != i$, then for every scan index $t >= 1$,
$ t P_i in D(S_1, dots, S_n) quad <=> quad (t P_i) mod p_i in S_i $.

*Proof.*
For $j != i$, $P_i equiv 0 mod p_j$, so $(t P_i) mod p_j = 0 in S_j$ because $0 in S_j$.
Thus $t P_i in D$ iff the $p_i$-coordinate lies in $S_i$.
@lem-crt-general is the $n$-coordinate form of the same fact. $square$

So pinning every *inactive* modulus replaces an intersection event over all $n$ coordinates by a *single-coordinate* hypergeometric problem on $(p_i, m_i)$ along the permuted scan $t = 1, 2, dots$.

=== Pinning one head coordinate shrinks grid empty runs ($n = 2$) <lem-pin-shrink-grid>

Take consecutive primes $p_1 = 2$, $p_2 = 3$, multiplicities $m_1, m_2$ with $m_2 >= 2$, and the $p_1$-grid $U_2^(I) = min{ t >= 1 : t p_1 in D }$.
Let $U_2^(I,"pin")$ be the same statistic under $0 in S_1$ (and $S_2$ still uniform with $|S_2| = m_2$), and let $U_2^(I,"un")$ be the statistic under independent uniform $S_1$, $S_2$ (unpinned).

For every $1 <= t <= p_2 - m_2$,
$ P(U_2^(I,"un") > t) >= P(U_2^(I,"pin") > t) $.

*Proof.*
For fixed $S_2$, write $A_s := {s p_1 in D}$.
If $0 in S_1$, then $(s p_1) mod p_1 = 0 in S_1$ for every $s$, so $A_s = {(s p_1) mod p_2 in S_2}$.
If $0 in.not S_1$, then $A_s$ also requires $(s p_1) mod p_1 in S_1$, so for each fixed $S_2$ and each $s$,
$ P(A_s^c | S_2, 0 in.not S_1) >= P(A_s^c | S_2, 0 in S_1) = P((s p_1) mod p_2 in.not S_2) $.
The miss events for $s = 1, dots, t$ are nested in the same configuration, hence
$ P(U_2^(I,"pin") > t | S_2) = P(inter_(s=1)^t A_s^c | 0 in S_1, S_2)
  <= P(inter_(s=1)^t A_s^c | 0 in.not S_1, S_2) $.
Averaging over $S_2$ and decomposing $S_1$ into the branches ${0 in S_1}$ and ${0 in.not S_1}$ (law of total probability) gives $P(U_2^(I,"un") > t) >= P(U_2^(I,"pin") > t)$. $square$

=== From pinned grid runs to the coordinate geometric rate <lem-pin-to-geom>

Under $Omega^("pin")$ with $m_i >= 2$, @lem-crt-general identifies $U_i^(I)$ with the pinned $n = 1$ waiting time on $(p_i, m_i)$.
Comparing against $U_i^(I I) ~ "Geometric"(q_i)$ at the *same* rate $q_i = m_i / p_i$, @n1-moment gives
$ P(U_i^(I) > t) > P(U_i^(I I) > t) $ and hence $E[W_i^(I)] > E[W_i^(I I)]$ (@n-all-moment).

*Two-step comparison (conceptual).*
For $n = 2$ on the $p_1$-grid:
$
  P(U_2^(I,"un") > t)
  >= P(U_2^(I,"pin") > t)
  > (1 - q_2)^t = P(U_2^(I I) > t).
$
The first inequality is @lem-pin-shrink-grid; the strict middle inequality is @n1-moment after @lem-crt-grid.

=== Remark (product rate gives the opposite order) <rem-prod-rate>

If one instead benchmarks against $U^(I I) ~ "Geometric"(q)$ with $q = product_(j=1)^n m_j / p_j$, then $q < q_i$ and $(1 - q)^t > (1 - q_i)^t$, so the *product-rate* geometric model is much slower and the capped moment inequality *reverses* ($E[W_i^(I)] < E[W^(I I)]$).
That comparison is a different question; @n-all-moment uses the coordinate rate $q_i$ so the ordering matches @n1-moment for every $n$.

=== Induction on $n$ revisited <rem-pin-induct>

@thm-n-all is proved by induction on $n$, but the analytic step is *not* a comparison of unpinned laws on $Omega$.
Each inductive step (@step-induct) does the following:

+ *Pinning hypothesis:* $0 in S_j$ for every $j$ (so @lem-pin-grid applies).
+ *CRT reduction:* $U_i^(I)$ is an $n = 1$ pinned waiting time on $(p_i, m_i)$.
+ *Same-rate comparison:* @n1-moment at rate $q_i$ gives $E[W_i^(I)] > E[W_i^(I I)]$.

So for *every* integer $1 <= m_i <= p_i$ with $m_i >= 2$, @n-all-moment holds in $Omega^("pin")$ without extra hypotheses.
Pinning explains *why* the reduction is valid; the strict inequality is the same hypergeometric--Bernoulli gap as in @thm-capped-k.

*What pinning alone does not prove.*
+ On the full unpinned space $Omega$, the grid inequality need not hold without pinning; @lem-pin-shrink-grid only compares unpinned vs.\ pinned *before* the coordinate-rate geometric comparison.

=== Coprime progression carries residue information <lem-consec-coprime-prog>

Let $p_a < p_b$ be distinct primes from the consecutive chain (@rem-moments-consecutive-primes) and fix $0 in S_a$ with $|S_a| = m_a$.
For integers $t = k p_b$ ($k = 1, 2, dots$),
$ t in D(S_a, S_b) quad <=> quad 0 in S_b quad "and" quad (k p_b) mod p_a in S_a $.
If $0 in S_b$, then on the progression ${p_b, 2p_b, 3p_b, dots}$ membership in $D$ is determined by the sequence $k mapsto (k p_b) mod p_a$, which is periodic in $k$ with period $p_a$.

*Proof.*
$t = k p_b$ gives $t mod p_b = 0 in S_b$ when $0 in S_b$.
Since $gcd(p_b, p_a) = 1$, $k mapsto (k p_b) mod p_a$ is a bijection on $ZZ / p_a ZZ$, so as $k$ runs through any complete residue system mod $p_a$, $(k p_b) mod p_a$ hits every class mod $p_a$ exactly once.
This is the mechanism behind ``use moment information on $1, 2, dots$ along the subsequence $p_j, 2p_j, dots$ when $p_j$ is not yet pinned'': the unpinned modulus is read on an arithmetic progression while pinned moduli cycle through all residues. $square$

=== One-coordinate relaxation dominates the full intersection <lem-consec-one-coord-dominates>

Fix $n >= 1$, $j in {1, dots, n}$, and independent random $bold(S) = (S_1, dots, S_n)$ with $|S_i| = m_i$ and $0 in S_i$ (pinned).
For $t >= 1$, write
$ E_t^(I) := {1, 2, dots, t} inter D(bold(S)) = nothing} $
for the consecutive scan (all coordinates), and
$ E_t^(j) := {s in {1, dots, t} : s mod p_j in.not S_j} $.
Then $E_t^(I) subset E_t^(j)$ as events, hence
$ P_(Omega^("pin"))(U^(I) > t) = P(E_t^(I)) >= P(E_t^(j)) $.

*Proof.*
If every $s in {1, dots, t}$ avoids $D$, then in particular each such $s$ fails coordinate $j$, so $s mod p_j in.not S_j$ and $E_t^(I) subset E_t^(j)$.
Taking probabilities gives the inequality. $square$

=== Pinned one-coordinate tail dominates the geometric benchmark <lem-consec-one-coord-tail>

Fix $(p, m)$ with $1 <= m < p$, $0 in S$, $|S| = m$, and $q = m / p$.
For $1 <= t <= p - m$,
$ P(min{ s >= 1 : s mod p in S } > t) > (1 - q)^t $,
where the left side is the pinned consecutive scan on $(p, m)$ and the right is $P(U^(I I) > t)$ for $U^(I I) ~ "Geometric"(q)$.

*Proof.*
This is exactly @tail-ineq / @n1-moment: the left event is ${1, dots, t} inter S = nothing}$ on positive residues, i.e.\ $T_1^(I) > t$. $square$

=== Consecutive scan: pinning *lengthens* empty runs <lem-pin-grow-consec>

*Convention.* On the consecutive scan $U^(I) = min{ t >= 1 : t in D(bold(S)) }$, write $Omega^((k))$ for independent uniform $S_1, dots, S_k$ with $|S_i| = m_i$ and *pinned* $0 in S_(k+1), dots, 0 in S_n$ (if $k < n$); $Omega^((0))$ is fully unpinned and $Omega^((n))$ is fully pinned.

For fixed $t >= 1$ and $k in {0, dots, n - 1}$,
$ P_(Omega^((k)))(U^(I) > t) <= P_(Omega^((k+1)))(U^(I) > t) $,
where the probability is over the random $bold(S)$ in $Omega^((k))$ / $Omega^((k+1))$.

*Proof.*
Fix all coordinates except $S_(k+1)$ and write $E_t := {1, dots, t} inter D = nothing}$.
Let $A := {0 in S_(k+1)}$ and compare the laws of $S_(k+1)$:
+ *Unpinned:* uniform $m_(k+1)$-subset of $ZZ / p_(k+1) ZZ$;
+ *Pinned:* uniform $m_(k+1)$-subset with $0 in S_(k+1)$.

Decompose $P(E_t) = P(A) P(E_t | A) + P(A^c) P(E_t | A^c)$ under the unpinned law.
Under the pinned law, $P(E_t) = P(E_t | A)$.

For fixed other coordinates, if $0 in S_(k+1)$ then every $s equiv 0 mod p_(k+1)$ passes coordinate $k+1$, so it is *easier* for some $s in {1, dots, t}$ to lie in $D$ and therefore *harder* for all of ${1, dots, t}$ to miss $D$:
$ P(E_t | A) <= P(E_t | A^c) $.
Indeed, when $0 in.not S_(k+1)$, every $s equiv 0 mod p_(k+1)$ automatically fails coordinate $k+1$, which shrinks the set of $s$ that can lie in $D$.

Thus
$ P_("un")(E_t) = P(A) P(E_t | A) + P(A^c) P(E_t | A^c)
  >= P(A) P(E_t | A) + P(A^c) P(E_t | A)
  >= P(E_t | A) = P_("pin")(E_t) $,
because $P(E_t | A^c) >= P(E_t | A)$ and $P(A) + P(A^c) = 1$.
Integrating over the other independent coordinates gives the same inequality for the full product law $Omega^((k))$ and $Omega^((k+1))$. $square$

=== Telescoping capped moments under incremental pinning <lem-pin-telescope>

For any cutoff $x >= 1$ and any law $bold(S) mapsto U^(I)$ on the consecutive scan,
$ E[W^(I)] = sum_(t=1)^x P(U^(I) > t) $ (@lem-capped-moment).
For the pinning chain $Omega^((0)), dots, Omega^((n))$,
$
  E_(Omega^((n)))[W^(I)]
  = E_(Omega^((0)))[W^(I)]
    + sum_(k=0)^(n-1) ( E_(Omega^((k+1)))[W^(I)] - E_(Omega^((k)))[W^(I)] )
$.
Each summand equals $sum_(t=1)^x ( P_(Omega^((k+1)))(U^(I) > t) - P_(Omega^((k)))(U^(I) > t) )$.
By @lem-pin-grow-consec, every term in the $t$-sum is $>= 0$, hence
$ E_(Omega^((n)))[W^(I)] >= E_(Omega^((0)))[W^(I)] $.

*Using this to handle non-monotone $t$-terms.*
@tail-ineq need not hold termwise for every $t <= x$ when $x$ is large (@rem-cutoff-scope).
The telescoping identity separates
$
  E_(Omega^((n)))[W^(I)] - E[W^(I I)]
  = sum_(t=1)^x ( P_(Omega^((n)))(U^(I) > t) - P(U^(I I) > t) )
$
into (i) the fully pinned comparison at $t <= p_i - m_i$ (@n1-moment after @lem-crt-general on grids, or directly on the line at $n = 1$), plus (ii) finitely many increments from $Omega^((0))$ to $Omega^((n))$, plus (iii) possibly negative terms $(P_(Omega^((n)))(U^(I) > t) - P(U^(I I) > t))$ for $t > p_i - m_i$.
The pin steps (ii) add a nonnegative buffer $sum_(k,t) ( P_(Omega^((k+1)))(U^(I) > t) - P_(Omega^((k)))(U^(I) > t) )$; for the budget cutoff $x <= P - M$, @cor-consec-moment-budget uses @lem-consec-head-beats-tail (@lem-consec-head-exact) rather than this cancellation.

=== Pinned consecutive tail beats the geometric rate (all $n$) <lem-consec-pinned-tail>

Fix $n >= 1$, consecutive primes $p_1 = 2 < dots < p_n$, $m_i >= 2$, and $q_i = m_i / p_i$.
On $Omega^("pin")$ with $0 in S_i$ for every $i$, let $U^(I)$ be the consecutive-scan first #ONE.
For each $j in {1, dots, n}$ and each $1 <= t <= p_j - m_j$,
$ P(U^(I) > t) > (1 - q_j)^t $.

*Proof by induction on $n$.*

*Base $n = 1$.* @lem-consec-one-coord-tail.

*Inductive step $n => n + 1$.*
Write $P_(n+1)$ for the law with $n + 1$ pinned coordinates and $P_n$ for the law with the first $n$ pinned (coordinate $n + 1$ still unpinned in $P_n$).
@lem-pin-grow-consec gives $P_(n+1)(U^(I) > t) >= P_n(U^(I) > t)$ for every $t >= 1$.

Fix $j <= n$. By the induction hypothesis, for $1 <= t <= p_j - m_j$,
$ P_n(U^(I) > t) > (1 - q_j)^t $, hence the same holds for $P_(n+1)$.

For $j = n + 1$ and $1 <= t <= p_(n+1) - m_(n+1)$, @lem-consec-one-coord-dominates gives
$ P_(n+1)(U^(I) > t) >= P(min{ s >= 1 : s mod p_(n+1) in S_(n+1) } > t) $
with $0 in S_(n+1)$ pinned.
The right-hand side is the pinned $n = 1$ consecutive scan on $(p_(n+1), m_(n+1))$, so @lem-consec-one-coord-tail yields
$ P_(n+1)(U^(I) > t) > (1 - q_(n+1))^t $.

Thus the tail inequality holds for every coordinate at depth $n + 1$. $square$

=== Consecutive survival is non-increasing <lem-consec-survival>

For the consecutive-scan first #ONE $U^(I) = min{ t >= 1 : t in D }$ and any $t >= 1$,
$ {U^(I) > t + 1} subset {U^(I) > t} $, hence $P(U^(I) > t + 1) <= P(U^(I) > t)$.

*Proof.*
${U^(I) > t + 1}$ means ${1, dots, t + 1} inter D = nothing}$, which implies ${1, dots, t} inter D = nothing}$, i.e.\ $U^(I) > t$. $square$

=== Early consecutive tails (comparison range) <lem-consec-comparison-tail>

Fix $n >= 1$, consecutive primes $p_1 = 2 < dots < p_n$, $m_i >= 2$, and $j in {1, dots, n}$.
On $Omega^("pin")$, for each $1 <= t <= p_j - m_j$,
$ P(U^(I) > t) > (1 - q_j)^t $.
This is @lem-consec-pinned-tail; recorded here for the split at $T = p_(j^*) - m_(j^*)$. $square$

=== Remark (late-$t$ termwise comparison can fail) <rem-late-termwise-fail>

Let $j^*$ maximize $p_(j^*) - m_(j^*)$, $T := p_(j^*) - m_(j^*)$, and $q_(j^*) := m_(j^*) / p_(j^*)$.
@lem-consec-pinned-tail gives $P(U^(I) > t) > (1 - q_(j^*))^t$ for $1 <= t <= T$.
For $t > T$, @lem-consec-survival gives $P(U^(I) > t) <= P(U^(I) > T)$, not $>=$: longer prefixes are *harder* to avoid entirely.
So one cannot extend the termwise inequality to every $t <= P - M$ by monotonicity alone.
  Example on consecutive primes $p_1 = 2$, $p_2 = 3$, $p_3 = 5$ with $(m_1, m_2, m_3) = (1, 1, 3)$: $T = 2$, $P - M = 27$, and $P(U^(I) > 20) = 0 < (1 - q_(j^*))^20$ while $E[W^(I)] > E[W_(j^*)^(I I)]$ still holds at $x = P - M$.

=== Pinned one-modulus survival sums to $(p - m) / m$ <lem-consec-one-mod-survival-sum>

Fix $(p, m)$ with $2 <= m < p$, $N := p - 1$, $K := m - 1$, and $T := p - m = N - K$.
On $Omega^("pin")$ for this modulus, with $U^(I) = min{ s >= 1 : s mod p in S }$,
$
  P(U^(I) > t) = binom(N - t, K) / binom(N, K)
$
for $1 <= t <= T$ (@eq-ex), and $P(U^(I) > t) = 0$ for $t > T$.
Then
$
  sum_(t=1)^T P(U^(I) > t) = (p - m) / m .
$ <eq-one-mod-survival-sum>

*Proof.*
For $1 <= t <= T$ one has $N - t >= K$, so every term is nonzero.
With $j := N - t$,
$
  sum_(t=1)^T binom(N - t, K)
  = sum_(j=K)^(N-1) binom(j, K)
  = binom(N, K + 1)
$
by the hockey-stick identity $sum_(j=0)^M binom(j, K) = binom(M + 1, K + 1)$ (here $M = N - 1$ and $binom(j, K) = 0$ for $j < K$).
Dividing by $binom(N, K)$ gives
$
  binom(N, K + 1) / binom(N, K) = (N - K) / (K + 1) = (p - m) / m .
$ $square$

=== Exact pinned head sum at $T = p - m$ <lem-consec-head-exact>

Fix $(p, m)$ with $2 <= m < p$, $q := m / p$, and $T := p - m$.
On $Omega^("pin")$ for this modulus,
$
  sum_(t=1)^T ( P(U^(I) > t) - (1 - q)^t )
  = (1 - q)^(T + 1) / q .
$ <eq-head-exact>

*Proof.*
@eq-one-mod-survival-sum gives $sum_(t=1)^T P(U^(I) > t) = (p - m) / m$.
@lem-geom-survival gives $sum_(t=1)^T (1 - q)^t = (1 - q)(1 - (1 - q)^T) / q$.
Since $1 - q = (p - m) / p$,
$
  (p - m) / m - (1 - q)(1 - (1 - q)^T) / q
  = (p - m) / m (1 - (1 - q)^T)
  = (1 - q)^T (p - m) / m
  = (1 - q)^(T + 1) / q .
$ $square$

=== Intersection head dominates the best coordinate head <lem-consec-inter-head-dominates>

Fix $n >= 1$, consecutive primes $p_1 = 2 < dots < p_n$, $m_i >= 2$, and $j^* in {1, dots, n}$.
Let $U^(I)$ be the consecutive-scan first #ONE on the full CRT intersection and $U_(j^*)^(I)$ the pinned one-modulus statistic on $(p_(j^*), m_(j^*))$.
On $Omega^("pin")$, for every $t >= 1$,
$ P(U^(I) > t) >= P(U_(j^*)^(I) > t) $,
hence
$
  sum_(t=1)^T ( P(U^(I) > t) - (1 - q_(j^*))^t )
  >= sum_(t=1)^T ( P(U_(j^*)^(I) > t) - (1 - q_(j^*))^t )
$
for $T := p_(j^*) - m_(j^*)$ and $q_(j^*) := m_(j^*) / p_(j^*)$.

*Proof.*
@lem-consec-one-coord-dominates gives $P(U^(I) > t) >= P(U_(j^*)^(I) > t)$ for each $t$.
Subtract the same geometric terms and sum over $t = 1, dots, T$. $square$

=== Budget cutoff exceeds the comparison range for $n >= 2$ <lem-consec-budget-gt-T>

Fix $n >= 2$, consecutive primes $p_1 = 2 < dots < p_n$, $m_i >= 2$, $P = product p_i$, $M = product m_i$, and $T := max_j (p_j - m_j)$.
Then $P - M > T$.

*Proof.*
Each factor $p_j - m_j >= 1$, and for $n >= 2$ at least two moduli contribute, so
$
  P - M = sum_(j=1)^n (product_(i != j) p_i)(p_j - m_j) >= p_(j^*) - m_(j^*) + (n - 1) = T + (n - 1) > T .
$ $square$

=== Head sum dominates the late geometric tail <lem-consec-head-beats-tail>

Fix $n >= 2$, consecutive primes $p_1 = 2 < dots < p_n$, $m_i >= 2$, $P = product p_i$, $M = product m_i$, and $j^*$ with
$ T := p_(j^*) - m_(j^*) = max_j (p_j - m_j) $, $q_(j^*) := m_(j^*) / p_(j^*)$.
For every $x$ with $T < x <= P - M$ on $Omega^("pin")$,
$
  sum_(t=1)^T ( P(U^(I) > t) - (1 - q_(j^*))^t )
  > sum_(t = T + 1)^x (1 - q_(j^*))^t .
$ <eq-head-beats-tail>

*Proof.*
Write $H_(j^*) := sum_(t=1)^T ( P(U_(j^*)^(I) > t) - (1 - q_(j^*))^t )$.
@lem-consec-head-exact at $(p_(j^*), m_(j^*))$ gives $H_(j^*) = (1 - q_(j^*))^(T + 1) / q_(j^*)$.
@lem-consec-inter-head-dominates gives
$
  sum_(t=1)^T ( P(U^(I) > t) - (1 - q_(j^*))^t ) >= H_(j^*) .
$
For the geometric tail, @lem-geom-survival yields
$
  sum_(t = T + 1)^x (1 - q_(j^*))^t
  = (1 - q_(j^*))^(T + 1) / q_(j^*) dot (1 - (1 - q_(j^*))^(x - T))
  < (1 - q_(j^*))^(T + 1) / q_(j^*) = H_(j^*)
$
because $0 < 1 - q_(j^*) < 1$ and $x > T$.
Combining the two displays gives @eq-head-beats-tail. $square$

=== Extended consecutive capped moment <thm-consec-moment-pin>

Fix $n >= 2$, consecutive primes $p_1 = 2 < dots < p_n$, $m_i >= 2$, $P = product p_i$, $M = product m_i$, and a cutoff $x >= 1$.
On $Omega^("pin")$, let $U^(I)$ be the consecutive-scan first #ONE and $W^(I) = min(U^(I) - 1, x)$.
For each $j in {1, dots, n}$, let $U_j^(I I) ~ "Geometric"(q_j)$ with $q_j = m_j / p_j$ and $W_j^(I I) = min(U_j^(I I) - 1, x)$.

+ *Comparison cutoff.* If $1 <= x <= p_j - m_j$, then
  $ E[W^(I)] > E[W_j^(I I)] $
  by @lem-capped-moment and @lem-consec-pinned-tail (termwise $P(U^(I) > t) > P(U_j^(I I) > t)$).

+ *Budget cutoff.* If $1 <= x <= P - M$, then $L_0 = U^(I) - 1 <= P - M$ (@lem-gap-budget-cutoff).
  Choose $j^*$ with $p_(j^*) - m_(j^*) = max_j (p_j - m_j)$.
  @cor-consec-moment-budget gives $E[W^(I)] > E[W_(j^*)^(I I)]$ (@lem-consec-head-beats-tail; @rem-late-termwise-fail).
+ *Infinite cutoff.* For every $x >= P - M$, $E[W^(I)] = (P - M) / M$ (@lem-consec-survival-plateau, @lem-consec-period-survival-sum) and $E[W^(I)] > E[W_(j^*)^(I I)]$ (@cor-consec-moment-budget).

*Coprime progression input.*
When coordinate $j$ is not in the pinned block ${1, dots, k}$, @lem-consec-coprime-prog explains how information on the line scan $1, 2, dots$ is transported along $p_j, 2p_j, dots$ while the other moduli (already pinned) cycle through all residue classes.

*Contrast with the grid.*
On a CRT *grid*, unpinned empty runs are *longer* than pinned (@lem-pin-shrink-grid), so the telescoping inequality reverses ($E[W^("un")] >= E[W^("pin")]$ there).
The consecutive line uses the opposite monotonicity (@lem-pin-grow-consec).

=== Corollary (budget cutoff with best comparison coordinate) <cor-consec-moment-budget>

Fix $n >= 2$, consecutive primes $p_1 = 2 < dots < p_n$, $m_i >= 2$, $P = product p_i$, $M = product m_i$, and choose $j^*$ with
$ p_(j^*) - m_(j^*) = max_j (p_j - m_j) $.
Let $U^(I)$ be the consecutive-scan first #ONE on $Omega^("pin")$, $W^(I) = min(U^(I) - 1, x)$, and $W_(j^*)^(I I) = min(U_(j^*)^(I I) - 1, x)$ for $U_(j^*)^(I I) ~ "Geometric"(q_(j^*))$ with $q_(j^*) = m_(j^*) / p_(j^*)$.

For every $x >= 1$,
$ E[W^(I)] > E[W_(j^*)^(I I)] $.

*Proof.*
Write $T := p_(j^*) - m_(j^*)$ and $B := P - M$.
By @lem-capped-moment and @lem-geom-survival,
$
  E[W^(I)] - E[W_(j^*)^(I I)]
  = sum_(t=1)^x ( P(U^(I) > t) - (1 - q_(j^*))^t )
  = sum_(t=1)^min(x, B) P(U^(I) > t) - sum_(t=1)^x (1 - q_(j^*))^t
$
using @lem-consec-survival-plateau for $t > B$.
If $x <= T$, the first block alone yields the strict inequality (@lem-consec-comparison-tail).
If $T < x <= B$, @lem-consec-head-beats-tail gives
$
  sum_(t=1)^T ( P(U^(I) > t) - (1 - q_(j^*))^t )
  > sum_(t = T + 1)^x (1 - q_(j^*))^t
$,
and adding $sum_(t = T + 1)^x P(U^(I) > t) >= 0$ gives $E[W^(I)] - E[W_(j^*)^(I I)] > 0$.
If $x > B$, @lem-consec-survival-plateau gives $E[W^(I)] = B / M$ (@lem-consec-period-survival-sum), while $E[W_(j^*)^(I I)]$ is nondecreasing in $x$ and strictly exceeds its value at $x = B$.
The case $x = B$ is the budget cutoff already treated; for $x > B$, $E[W^(I)] = E[W^(I)]$ at $x = B > E[W_(j^*)^(I I)]$ at $x = B <= E[W_(j^*)^(I I)]$ at $x$. $square$

=== Corollary (infinite cutoff) <cor-consec-moment-infinite>

Under the hypotheses of @cor-consec-moment-budget, for every $x >= 1$,
$
  E[W^(I)] > E[W_(j^*)^(I I)] .
$
Once $x >= P - M$, $E[W^(I)] = (P - M) / M$ and is constant in $x$; the coordinate-rate geometric side satisfies
$ lim_(x -> oo) E[W_(j^*)^(I I)] = (p_(j^*) - m_(j^*)) / m_(j^*) $.

*Proof.*
@cor-consec-moment-budget. The plateau and @lem-consec-period-survival-sum give the limit of $E[W^(I)]$; @lem-geom-survival gives the geometric limit. $square$

=== Remark (product rate at infinite cutoff) <rem-infinite-product-rate>

Let $q_"prod" := M / P = product_(i=1)^n m_i / p_i$.
The *uncapped* product-rate geometric mean is
$ lim_(x -> oo) E[min(U^(I I) - 1, x)] = (1 - q_"prod") / q_"prod" = (P - M) / M $
(@lem-geom-survival).
On the consecutive scan, @lem-consec-period-survival-sum gives the *same* value for the intersection model:
$ lim_(x -> oo) E[W^(I)] = (P - M) / M $.
Thus the infinite-cutoff first distribution matches the product-rate geometric benchmark *exactly*, while it strictly dominates the faster coordinate-rate model at $j^*$ (@cor-consec-moment-infinite).
This is not a contradiction with @rem-prod-rate: there the grid comparison at rate $q_"prod"$ reverses because $U_i^(I)$ has finite support $p_i - m_i$ per coordinate, whereas the consecutive scan exploits the full period budget $B = P - M$ before survival vanishes.

== Case $n = 1$: capped distance from $0$

We specialize to $(p, m)$ in place of $(p_1, m_1)$ with $1 <= m <= p$ and cutoff $x >= 1$.
Work in $Omega^("pin")$: $0 in S$ and the first positive #ONE is $U^(I) = min{ t >= 1 : t in S }$ along $1, 2, dots$, with distance $D^(I) = U^(I) - 1$ and $W^(I) = min(D^(I), x)$.

=== First model: run of zeros before the first positive #ONE

Equivalently, ${U^(I) > x} = {1, 2, dots, x} inter S = nothing}$ among positive residues.
With $T = S without {0}$ uniform among $(m-1)$-subsets of ${1, dots, p-1}$,
$ P(U^(I) > x) = binom(p - 1 - x, m - 1) / binom(p - 1, m - 1) $
whenever $m - 1 <= p - 1 - x$ (otherwise $P(U^(I) > x) = 0$).

When $m - 1 <= p - 1 - x$,
$
  P(U^(I) > x) = product_(j=0)^(m-2) (p - 1 - x - j) / (p - 1 - j)
$ <eq-ex>

=== Second model

Let $q := m / p$.
Let $U^(I I) ~ "Geometric"(q)$, $D^(I I) = U^(I I) - 1$, and $W^(I I) := min(D^(I I), x)$.

=== Target ($n = 1$, same rate $q = m/p$)

For $1 <= x <= p - m$,
$
  E[W^(I I)] < E[W^(I)]
$ <n1-moment>
i.e. $sum_(t=1)^x P(U^(I I) > t) < sum_(t=1)^x P(U^(I) > t)$ by @lem-capped-moment.
Equivalently, $P(U^(I I) > t) < P(U^(I) > t)$ for each $1 <= t <= p - m$ (@tail-ineq with $k = 1$).

=== Proof of @n1-moment

For $k = 1$, @thm-capped-k gives @tail-ineq, and the corollary there yields $E[W^(I I)] < E[W^(I)]$ for $1 <= x <= p - m$ via @lem-capped-moment. $square$

This compares both models at the *same* rate $q = m/p$.
For $n >= 2$ on the consecutive-prime chain, @lem-crt-general reduces each grid direction to the $n = 1$ problem on $(p_i, m_i)$, and @n-all-moment compares against $U_i^(I I) ~ "Geometric"(q_i)$ at the coordinate rate $q_i$.

---

== Case $n = 2$: CRT-aligned scan indices

Take consecutive primes $p_1 = 2$, $p_2 = 3$ and multiplicities $(m_1, m_2)$ on that pair (@rem-moments-consecutive-primes).
Work on the CRT line ${0, 1, dots, p_1 p_2 - 1}$ with indicator $f$ from the first distribution (@eq-ex style, now joint over $(S_1, S_2)$).

The $n = 1$ scan used consecutive integers $1, 2, dots, x$.
For $n = 2$, *which* indices matter depends on which modulus is in focus.
In general (@thm-n-all), modulus $p_i$ uses the grid $P_i, 2P_i, dots$ with $P_i = product_(j != i) p_j$; for $n = 2$ this gives $p_1, 2p_1, dots$ and $p_2, 2p_2, dots$.

#block(stroke: 0.5pt + gray, inset: 8pt)[
  *Remark (CRT grid vs.\ consecutive scan).*
  The full indicator $f$ is defined on every integer: $1, 2, 3, 4, dots$ all carry #ONE or #ZERO labels, and Section 4 uses this consecutive scan for the early-#ONE theorems (@cor-hl-witness-pn).

  The $n = 2$ moment comparison (@thm-n2, @n2-moment) uses only the CRT-aligned subsequence
  $ p_1, 2p_1, 3p_1, dots quad "or, symmetrically," quad p_2, 2p_2, 3p_2, dots $
  attached to one modulus.
  Integers strictly between grid points---such as $2, 3, 4$ when $p_1 = 3$---are not omitted from $D$; they are simply excluded from the waiting-time statistic of Section 3.

  *Grid reduction.*
  With pinning ($0 in S_1$), every multiple $t p_1$ is already compatible mod $p_1$; only the coordinate mod $p_2$ varies.
  Because $gcd(p_1, p_2) = 1$, the map $t arrow.r.long t p_1 mod p_2$ is a bijection on $ZZ / p_2 ZZ$ (@lem-crt-grid), so scanning $t = 1, 2, dots$ on the $p_1$-grid is equivalent to scanning all residue classes mod $p_2$ in a permuted order---the same $n = 1$ waiting-time problem on $(p_2, m_2)$.

  *Example ($p_1 = 2$, $p_2 = 3$, $P = 6$).*
  The $p_2$-aligned grid is $2, 4, 6, 8, dots$.
  The consecutive scan also visits $1, 3, 5, 7, dots$; any of these can be #ONES if they lie in $D$.
  Section 3 compares the first grid hit $min{ t >= 1 : t dot 2 in D }$ with the first consecutive hit $min{ x >= 1 : x in D }$ on the same set $D$.
]

---

== Single modulus: capped $k$-th #ONE vs. capped $k$-th success

*Scope.* One pair $(p, m)$ only; no CRT intersection yet.
Use @def-capped on the scan $t = 1, 2, dots$ (the #ONE at $0$ is automatic).
Assume $1 <= k <= m - 1$ and cutoff $x >= 1$.

=== First model (random subset, indicator #ONES)

Draw $T = S without {0}$ uniformly among $(m-1)$-subsets of ${1, dots, p - 1}$.
Set $f(t) = 1$ if $t in T$ and $0$ for $t >= 1$ with $t in.not T$; always $f(0) = 1$.
Let $T_k^(I)$ be the 1-indexed position of the $k$-th positive #ONE along ${1, 2, dots}$:
$ T_k^(I) = min{ t >= 1 : |{1, dots, t} inter S| = k } $.
For $k = 1$ this is $T_1^(I) = min{ t >= 1 : t in S }$.
The distance to the $k$-th positive #ONE is $D_k^(I) := T_k^(I) - 1$, and $W_k^(I) := min(D_k^(I), x)$.

Let $H_t = |T inter {1, dots, t}|$.
Then $H_t$ follows the hypergeometric law (@lem-hypergeom-pmf):
$ P(H_t = j) = binom(t, j) binom(p - 1 - t, m - 1 - j) / binom(p - 1, m - 1) $ for $0 <= j <= min(t, m - 1)$,
and $P(T_k^(I) > t) = P(H_t <= k - 1) = sum_(j=0)^(k-1) P(H_t = j)$.

=== Hypergeometric count for pinned sampling without replacement <lem-hypergeom-pmf>

Draw $T$ uniformly among $(m-1)$-subsets of ${1, dots, p - 1}$ (the pinned model with $0 in S$).
For $0 <= t <= p - 1$ and $0 <= j <= min(t, m - 1)$,
$ P(|T inter {1, dots, t}| = j) = binom(t, j) binom(p - 1 - t, m - 1 - j) / binom(p - 1, m - 1) $.

*Proof.*
Choose a subset of size $m - 1$ from $p - 1$ elements by first choosing $j$ elements inside ${1, dots, t}$ and $m - 1 - j$ outside.
There are $binom(t,j) binom(p - 1 - t, m - 1 - j)$ favorable choices out of $binom(p - 1, m - 1)$ total. $square$

=== Second model (independent trials)

Let $q := m / p$.
Run independent Bernoulli$(q)$ trials (@lem-geom-pmf) and let $T_k^(I I)$ be the 1-indexed trial of the $k$-th success.
Define $D_k^(I I) := T_k^(I I) - 1$ and $W_k^(I I) := min(D_k^(I I), x)$.
Let $G_t$ be the number of successes in the first $t$ trials; $G_t ~ "Binomial"(t, q)$.
Then $P(T_k^(I I) > t) = P(G_t <= k - 1) = sum_(j=0)^(k-1) binom(t, j) q^j (1 - q)^(t - j)$.

=== Target inequality

For $1 <= t <= p - m$ and $1 <= k <= m - 1$,
$
  P(T_k^(I I) > t) < P(T_k^(I) > t)
$ <tail-ineq>

For any cutoff $x >= 1$, @lem-capped-moment gives
$ E[W_k^(I I)] = sum_(t=1)^x P(T_k^(I I) > t) $ and $E[W_k^(I)] = sum_(t=1)^x P(T_k^(I) > t) $.
For $1 <= x <= p - m$ (*comparison cutoff*),
$
  E[W_k^(I I)] < E[W_k^(I)]
$,
using @tail-ineq termwise.

At $k = 1$ (first positive #ONE), @tail-ineq gives @n1-moment.

---

== Proof of the capped $k$-th comparison (single modulus) <thm-capped-k>

Write $N = p - 1$, $K = m - 1$, and $q = m/p$.
For $0 <= ell <= K$ and $t >= 0$, define
$
  F(t, ell) := sum_(j=0)^ell binom(t, j) binom(N - t, K - j) / binom(N, K), quad
  G(t, ell) := sum_(j=0)^ell binom(t, j) q^j (1 - q)^(t - j)
$
(so $P(T_k^(I) > t) = F(t, k-1)$ and $P(T_k^(I I) > t) = G(t, k-1)$).
We prove $F(t, ell) > G(t, ell)$ whenever $1 <= t <= N - K$ ($t <= p - m$) and $0 <= ell <= K - 1$.

=== Lemma (empty run) <lem-run>

If $1 <= s <= N - K$, then
$ binom(N - s, K) / binom(N, K) > (1 - q)^s = ((p - m) / p)^s $.

*Proof.*
Induct on $s$.
For $s = 1$, both sides equal $(N - K)/N = (p - m)/(p - 1) > (p - m)/p$.
If $1 < s <= N - K$, then
$ binom(N - s, K) / binom(N, K)
  = binom(N - s + 1, K) / binom(N, K) dot (N - s - K + 1) / (N - s + 1) $.
By induction the first factor exceeds $((N-K)/N)^(s-1)$, and for $s >= 2$ one has
$ (N - s - K + 1) / (N - s + 1) > (N - K) / N $
because $N(N - s - K + 1) - (N - K)(N - s + 1) = K(s - 1) > 0$.
Multiplying gives the claim. $square$

=== Lemma (hypergeometric is stochastically smaller) <lem-sd>

For $1 <= t <= N - K$ and $0 <= ell <= K$,
$ F(t, ell) = P(H_t <= ell) > P(G_t <= ell) = G(t, ell) $.

*Proof.*
Because $K/N = (m-1)/(p-1) < m/p = q$, each hypergeometric draw has a smaller per-step hit rate than Bernoulli sampling once hits are present.
Formally, induct on $t$.

$t = 1$: $F(1,0) = (N-K)/N > 1 - q = G(1,0)$ and $F(1,ell) = 1 = G(1,ell)$ for $ell >= 1$.

Assume $F(t-1, ell) >= G(t-1, ell)$ for all $ell$.
When passing from $t-1$ to $t$, the hypergeometric update adds a hit with conditional probability $(K - j)/(N - t + 1)$ if $H_(t-1) = j$, whereas the binomial update uses $q$.
For $0 <= j <= min(t-1, K)$ and $t <= N - K$,
$ (K - j)/(N - t + 1) <= K/(N - t + 1) <= K/N < q $.
So each transition pushes less mass upward than the Bernoulli transition.

Writing the standard recursions
$
  P(H_t = j) = P(H_(t-1) = j) (N - K - j)/(N - t + 1) + P(H_(t-1) = j-1) (K - j + 1)/(N - t + 1),
$
$
  P(G_t = j) = P(G_(t-1) = j) (1 - q) + P(G_(t-1) = j-1) q,
$
and summing $j = 0, dots, ell$, the induction hypothesis gives $F(t,ell) > G(t,ell)$ for $ell = 0$ by @lem-run, and for $ell >= 1$ the same recursions increase $F(t,ell) - G(t,ell)$ strictly once $F(t-1,ell-1) > G(t-1,ell-1)$.
In particular $F(t, k-1) > G(t, k-1)$ for $1 <= k <= K$. $square$

=== Theorem

For $1 <= t <= p - m$ and $1 <= k <= m - 1$,
@tail-ineq holds.

*Proof.*
$P(T_k^(I) > t) = F(t, k-1)$ and $P(T_k^(I I) > t) = G(t, k-1)$.
Apply @lem-sd. $square$

=== Corollary (capped moments)

If $1 <= x <= p - m$, then $E[W_k^(I I)] < E[W_k^(I)]$.

*Proof.*
By @lem-capped-moment,
$ E[W_k^(I I)] = sum_(t=1)^x P(T_k^(I I) > t) $ and $E[W_k^(I)] = sum_(t=1)^x P(T_k^(I) > t)$.
For $1 <= t <= x <= p - m$, @tail-ineq gives $P(T_k^(I I) > t) < P(T_k^(I) > t)$.
Summing over $t = 1, dots, x$ yields the claim. $square$

#block(stroke: 0.5pt + gray, inset: 8pt)[
  *Range of $t$ and $x$.*
  The hypothesis $t <= p - m$ matches $m - 1 <= p - 1 - t$, i.e. the hypergeometric model still has room for a length-$t$ run of zeros.
  For $t > p - m$, one has $P(T_k^(I) > t) = 0$ while $P(T_k^(I I) > t) > 0$ may hold, so the tail inequality is stated only in the range where both models are comparable.
]

---

== Case $n = 2$: first intersection #ONE vs.\ coordinate-rate geometric <thm-n2>

Take consecutive primes $p_1 = 2$, $p_2 = 3$ with $1 <= m_i <= p_i$ and $0 in S_1, 0 in S_2$ (pinned on both coordinates, as in $Omega^("pin")$; @rem-moments-consecutive-primes).
Let $q_i := m_i / p_i$.
Draw $(S_1, S_2)$ with $0 in S_i$ and $|S_i| = m_i$; let $f$ be the intersection indicator on ${0, dots, p_1 p_2 - 1}$.

=== Scan model (the $p_2$-aligned grid)

Use @def-capped on the grid $t p_1$ for $t = 1, 2, dots$.
Because $0 in S_1$, every grid point $t p_1$ is automatically in $D$ modulo $p_1$; the first positive-grid #ONE is
$ U_2^(I) := min{ t >= 1 : t p_1 in D(S_1, S_2) } $,
with distance $D_2^(I) = U_2^(I) - 1$ and $W_2^(I) := min(D_2^(I), x)$.

=== Random model (coordinate rate)

Let $U_2^(I I) ~ "Geometric"(q_2)$, $D_2^(I I) = U_2^(I I) - 1$, and $W_2^(I I) := min(D_2^(I I), x)$ as in @def-capped.

=== Target (first positive-grid #ONE, same rate $q_2$)

Fix a cutoff $x >= 1$ with $1 <= x <= p_2 - m_2$ (in particular whenever $m_2 >= 2$),
$
  E[W_2^(I I)] < E[W_2^(I)]
$ <n2-moment>
equivalently $E[W_2^(I)] > E[W_2^(I I)]$: the capped first intersection #ONE on the $p_2$-grid is *slower on average* than the capped first success at rate $q_2 = m_2 / p_2$.

*Edge case $m_2 = 1$.*
Then only $0 in S_2$, the grid scan hits only when $t p_1 equiv 0 mod p_2$, i.e.\ at $t = p_2, 2p_2, dots$, so the first-#ONE problem degenerates and is excluded.

---

== Proof of @n2-moment

=== Step 1: CRT reduction to $n = 1$ on $(p_2, m_2)$ <lem-crt-grid>

By @lem-pin-grid (with $i = 2$ and $0 in S_1$) and $gcd(p_1, p_2) = 1$, for every $t >= 1$
$ t p_1 in D(S_1, S_2) quad <=> quad t p_1 equiv s mod p_2 " for some " s in S_2 $.
The map $t arrow.r.long t p_1 mod p_2$ is a bijection on $ZZ/p_2 ZZ$, so $U_2^(I)$ has the same law as the $n = 1$ positive-distance waiting time for $(p_2, m_2)$ (with $0 in S_2$ fixed).

*Proof.*
If $t p_1 in D$, then $(t p_1) mod p_1 = 0 in S_1$ automatically and $(t p_1) mod p_2 in S_2$.
Conversely, if $(t p_1) mod p_2 in S_2$, then $t p_1 in D$.
The bijection $t arrow.r.long t p_1 mod p_2$ preserves the order of scan indices, so the first hitting index $t$ matches the $n = 1$ problem on modulus $p_2$. $square$

=== Step 2: apply @n1-moment

On $(p_2, m_2)$ with $0 in S_2$ and rate $q_2 = m_2 / p_2$, @n1-moment gives
$ E[W_2^(I I)] < E[W_2^(I)] $ for $1 <= x <= p_2 - m_2$, which is @n2-moment. $square$

The symmetric $p_1$-grid ($t p_2$, benchmark $U_1^(I I) ~ "Geometric"(q_1)$) follows by swapping indices.

---

== General $n >= 2$: induction on the number of moduli <thm-n-all>

Fix $n >= 2$, consecutive primes $p_1 = 2 < p_2 = 3 < dots < p_n$, and multiplicities $m_i$ with $1 <= m_i <= p_i$ (@rem-moments-consecutive-primes).
Write
$ q_i := m_i / p_i, quad q := product_(i=1)^n q_i $.
For each index $i in {1, dots, n}$, define the *CRT step size*
$ P_i := product_(j = 1, j != i)^n p_j $.

=== Grid scan attached to modulus $p_i$

Use @def-capped on the grid $t P_i$ for $t = 1, 2, dots$.
The first positive-grid #ONE in direction $i$ is
$ U_i^(I) := min{ t >= 1 : t P_i in D(S_1, dots, S_n) } $,
with distance $D_i^(I) = U_i^(I) - 1$ and $W_i^(I) := min(D_i^(I), x)$.
For each direction $i$, let $U_i^(I I) ~ "Geometric"(q_i)$, $D_i^(I I) = U_i^(I I) - 1$, and $W_i^(I I) := min(D_i^(I I), x)$.

=== Target ($n >= 2$, coordinate rate $q_i$)

Fix a cutoff $x >= 1$.
For each $i$ with $m_i >= 2$ and $1 <= x <= p_i - m_i$ (*comparison cutoff*; see @def-extended-cutoff),
$
  E[W_i^(I I)] < E[W_i^(I)]
$ <n-all-moment>
equivalently $E[W_i^(I)] > E[W_i^(I I)]$, the same ordering as @n1-moment on the reduced coordinate $(p_i, m_i)$.
If $x > p_i - m_i$, the grid-side first distribution contributes no further terms to $E[W_i^(I)]$ while $E[W_i^(I I)]$ can still increase.

The $n = 1$ case is @n1-moment (@thm-capped-k) at $p_1 = 2$; @lem-crt-general extends it to every CRT grid direction on the consecutive-prime chain once all coordinates are pinned.

=== Remark (comparison cutoff vs.\ budget cutoff) <rem-cutoff-scope>

*Yes: $x$ is the cutoff* in $W = min(D, x)$ (@def-capped).
The theorems below use two different upper limits on that parameter:

+ *Comparison cutoff* ($1 <= x <= p_i - m_i$): where $E[W_i^(I I)] < E[W_i^(I)]$ is proved (@n-all-moment).
+ *Budget cutoff* ($1 <= x <= P - M$): where the consecutive-scan first gap satisfies $L_0 = U - 1 <= P - M$ (@lem-gap-budget-cutoff), so the cap is not below the true zero run in the period budget sense.
+ *Infinite cutoff* ($x -> oo$): $E[W^(I)]$ is constant for $x >= P - M$ and equals $(P - M) / M$ (@lem-consec-period-survival-sum); the coordinate-rate geometric benchmark keeps growing to $(p_(j^*) - m_(j^*)) / m_(j^*)$, while the product-rate geometric benchmark matches $(P - M) / M$ (@rem-infinite-product-rate).

*Grid / reduced law (sharp comparison range).*
After @lem-crt-general, $U_i^(I)$ is the pinned $n = 1$ statistic on $(p_i, m_i)$.
For $t > p_i - m_i$, $P(U_i^(I) > t) = 0$ but $P(U_i^(I I) > t) = (1 - q_i)^t > 0$, so @tail-ineq fails and $E[W_i^(I)]$ stops growing in $x$ while $E[W_i^(I I)]$ keeps growing.
Induction on $n$ does *not* widen this comparison range for grid $U_i^(I)$.

*Consecutive scan (budget cutoff extends).*
On $t = 1, 2, dots$, more moduli increase $P - M$ (@lem-gap-budget-cutoff), so one may take cutoff $x <= P - M$ without contradicting the gap identity.
For $x > p_i - m_i$, $P(U^(I) > t)$ can stay positive on the line scan while the *grid-reduced* law at coordinate $i$ has $P(U_i^(I) > t) = 0$ for $t > p_i - m_i$.
Comparing against $U_i^(I I) ~ "Geometric"(q_i)$ at a fixed coordinate $i$ need not be termwise monotone when $x > p_i - m_i$; use $j^*$ with $p_(j^*) - m_(j^*) = max_j (p_j - m_j)$ instead (@cor-consec-moment-budget, @rem-late-termwise-fail).

*Status (consecutive scan, pinned).*
+ Comparison cutoff $1 <= x <= p_i - m_i$: @thm-consec-moment-pin, @lem-consec-pinned-tail (termwise).
+ Budget cutoff $1 <= x <= P - M$: @cor-consec-moment-budget (@lem-consec-head-beats-tail, @lem-consec-head-exact, @eq-one-mod-survival-sum).
+ Infinite cutoff $x >= P - M$: $E[W^(I)] = (P - M) / M$ (@lem-consec-period-survival-sum, @cor-consec-moment-infinite); matches product-rate geometric, dominates coordinate-rate geometric (@rem-infinite-product-rate).
+ Coprime progression (@lem-consec-coprime-prog) transports line-scan information to $p_j, 2p_j, dots$ when $p_j$ is the active modulus.
+ Grid: unpinned $>=$ pinned (@lem-pin-shrink-grid); consecutive: pinned $>=$ unpinned (@lem-pin-grow-consec).

---

== Proof of @thm-n-all by induction on $n$

We prove @n-all-moment by induction on $n >= 2$.
The base case $n = 2$ is @n2-moment.
For the inductive step, adjoining the next consecutive prime $p_(a+1)$ repeats the same pinning + CRT reduction and empty-run comparison (@rem-pin-induct); the induction hypothesis is not used in the analytic part.

=== Base case $n = 2$

This is @n2-moment (proved above).

=== Inductive step: $n = a => n = a + 1$ ($a >= 2$) <step-induct>

Fix $a >= 2$ and adjoin the next consecutive prime $(p_(a+1), m_(a+1))$ in the chain $2, 3, 5, dots$ with $0 in S_(a+1)$.
We prove @n-all-moment for the enlarged family; it suffices to check one direction $i$ (the others are identical).

*Case $i = a + 1$.*
Here $P_(a+1) = product_(j=1)^a p_j$.
By @lem-crt-general, $U_(a+1)^(I)$ has the same law as the $n = 1$ positive-distance waiting time on $(p_(a+1), m_(a+1))$.
With $U_(a+1)^(I I) ~ "Geometric"(q_(a+1))$, @n1-moment gives $E[W_(a+1)^(I I)] < E[W_(a+1)^(I)]$ for $1 <= x <= p_(a+1) - m_(a+1)$.

*Case $i <= a$.*
Here $P_i = p_(a+1) product_(j != i, j <= a) p_j$.
Again @lem-crt-general reduces $U_i^(I)$ to the $n = 1$ waiting time on $(p_i, m_i)$; @n1-moment at rate $q_i$ gives $E[W_i^(I I)] < E[W_i^(I)]$.

Thus @n-all-moment holds for $n = a + 1$. $square$

=== CRT grid reduction (all $n$) <lem-crt-general>

Fix $i in {1, dots, n}$ and $P_i = product_(j != i) p_j$.
Because $0 in S_j$ for every $j$ and $gcd(P_i, p_i) = 1$ on the consecutive-prime chain (@rem-moments-consecutive-primes),
$ t P_i in D(S_1, dots, S_n) quad <=> quad t P_i equiv s mod p_i " for some " s in S_i $.
The map $t arrow.r.long t P_i mod p_i$ is a bijection on $ZZ/p_i ZZ$, so $U_i^(I)$ has the same law as the $n = 1$ waiting time $min{ t >= 1 : t in S_i }$ on $(p_i, m_i)$.

*Proof.*
For $j != i$, $P_i equiv 0 mod p_j$, so $(t P_i) mod p_j = 0 in S_j$.
Thus $t P_i in D$ <=> $(t P_i) mod p_i in S_i$.
Since $gcd(P_i, p_i) = 1$, $t arrow.r.long t P_i mod p_i$ is bijective and order-preserving on scan indices. $square$

=== Corollary

If every $m_i >= 2$, then @n-all-moment holds for every $n >= 2$ and every modulus direction $i$ in $Omega^("pin")$.
For $n = 1$, use @n1-moment (@thm-capped-k) instead.
If some $m_i = 1$, direction $i$ degenerates (grid hits only at multiples of $p_i$). $square$

---

= Early #ONE witnesses

Section 4 has two layers: a *general* CRT bound $U <= P$ (@thm-crt-general), and a *prime-sieve / Hardy--Littlewood* bound $U(bold(S) (bold(h))) <= p_n$ once $p_n >= W(bold(h))$ (@cor-hl-witness-pn).
The universal claim $U <= p_n$ for *every* $bold(S) in Omega$ is false (@rem-not-universal).

== General case: pairwise coprime moduli <thm-crt-general>

Fix $n >= 1$ and moduli $p_1, dots, p_n >= 2$ with $gcd(p_i, p_j) = 1$ for $i != j$.
Fix multiplicities $1 <= m_i <= p_i$ and the configuration space $Omega$ from @def-config-space.
Let $P = product_(i=1)^n p_i$, $D(bold(S))$ the CRT intersection, and $U(bold(S)) = min{ t >= 1 : t in D(bold(S)) }$ on the consecutive scan.

=== Witness before the period <lem-crt-witness-period>

If $m_i >= 1$ for every $i$, then for every $bold(S) in Omega$ there exists $x in {1, dots, P}$ with $x in D(bold(S))$.

*Proof.*
Fix $bold(S)$. If some coordinate has $0 in.not S_j$, pick $s_j in S_j without {0}$ for that $j$ and arbitrary $s_i in S_i$ elsewhere.
@lem-crt-bijection gives $x in {0, dots, P - 1}$ with $x equiv s_i mod p_i$ for all $i$.
Then $x equiv.not 0 mod p_j$, so $x != 0$; hence $1 <= x <= P - 1$.

If $0 in S_i$ for every $i$, choose $s_i = 0$ for all $i$; then $0 in D(bold(S))$.
Also $P equiv 0 mod p_i$ and $0 in S_i$ for each $i$, so $P in D(bold(S))$.
For $n = 1$ one has $P = p_1 >= 2$; for $n >= 2$, $P >= 2 p_n >= 2$.
Thus $P in {1, dots, P}$ in both cases. $square$

=== Corollary (first #ONE before $P$) <cor-one-before-P>

Under the hypotheses of @thm-crt-general, for every $bold(S) in Omega$,
$ U(bold(S)) <= P $.

*Proof.*
@lem-crt-witness-period gives $x in {1, dots, P} inter D(bold(S))$, so the first positive #ONE is at most $P$. $square$

=== Empty runs longer than the period <lem-bad-count-general>

For $t >= 1$, let $N_("bad") (t)$ count $bold(S) in Omega$ with ${1, dots, t} inter D(bold(S)) = nothing$.
If $t >= P$, then $N_("bad") (t) = 0$.

*Proof.*
@cor-one-before-P shows every configuration has $U <= P$, so each has a #ONE in ${1, dots, P} subset {1, dots, t}$ when $t >= P$. $square$

=== Probability form on the general model <cor-crt-delay-P>

For $t >= P$,
$ P(E_t) = 0 $ and @prime-delay-bound holds with $t$ in place of $p_n^2$.

*Proof.*
$P(E_t) = N_("bad") (t) / |Omega| = 0$ by @lem-bad-count-general. $square$

---

== Prime sieve: consecutive primes and uniform tail gap <thm-prime-tail>

This subsection specializes to consecutive primes $p_1 = 2 < p_2 = 3 < dots$ and the uniform tail gap $p_i - m_i = K$ for $i >= ell$.
The intersection model is unchanged; the improvement over @cor-one-before-P is proved only for the Hardy--Littlewood configuration $bold(S) (bold(h))$ (@cor-hl-witness-pn), not for all of $Omega$.

=== Parameters

Let $p_1 < p_2 < dots < p_n$ be the first $n$ *consecutive primes* ($p_1 = 2$, $p_2 = 3$, $p_3 = 5$, $dots$).
Fix a natural number $ell >= 1$ and admissible multiplicities
$ 0 <= m_i <= p_i $ for $i = 1, dots, ell - 1 $.
Fix an integer $K >= 0$ and impose a *uniform tail gap* for $i >= ell$:
$ p_i - m_i = K $ (equivalently $m_i = p_i - K$).
Then $0 <= m_i <= p_i$ holds automatically; we need $m_i >= 1$ on the tail, i.e. $K <= p_i - 1$ (true for every tail prime once $K$ is fixed).

Draw $bold(S) = (S_1, dots, S_n)$ independently with $S_i in Omega_i$ as in @def-config-space (each $S_i$ is any $m_i$-subset of $ZZ / p_i ZZ$; *no pinning*).
Let $P = product_(i=1)^n p_i$, $D(bold(S)) subset {0, dots, P - 1}$ be the CRT intersection, and $f_(bold(S))$ the indicator from @def-indicator.
On the *consecutive* scan $1, 2, 3, dots$, define the first positive #ONE
$ U := min{ t >= 1 : f_(bold(S)) (t) = 1 } $.
(Equivalently, $U$ is the 1-indexed first success time; the distance from $0$ is $U - 1$ as in @def-capped.)

The joint configuration space has
$ |Omega| = product_(i=1)^n binom(p_i, m_i) $,
and a fixed deterministic tuple such as the Hardy--Littlewood pattern $bold(S) (bold(h))$ from @def-m-from-h lies in $Omega$ as soon as $|S_i| = m_i$ for every $i$.

=== All-#ZEROES before $p_n^2$ <def-all-zeroes>

For $t >= 1$, let
$ E_t := {U > t} = { f_(bold(S)) (x) = 0 " for every " x in {1, 2, dots, t} } $
be the event that the first $t$ positive positions are all #ZEROES (no #ONE yet).
Equivalently, ${1, dots, t} inter D(bold(S)) = nothing$.

The probability is a *rational* with denominator $|Omega|$:
$ P(E_t) = N_("bad") (t) / |Omega| $
where $N_("bad") (t) in {0, 1, 2, dots}$ counts bad configurations (@lem-bad-count-general).

=== Configuration count (not $binom(P, M)$) <rem-config-count>

The configuration space is
$ Omega = product_(i=1)^n Omega_i, quad |Omega| = product_(i=1)^n binom(p_i, m_i) $ (@def-config-space).
Each *full pattern* $bold(S) = (s_1, dots, s_n)$ has probability
$ P(bold(S)) = 1 / |Omega| = 1 / product_(i=1)^n binom(p_i, m_i) $.

This is *not* the same as
$ binom(P, M) = binom(product p_i, product m_i) $,
which counts $M$-subsets of $ZZ / P ZZ$ *without* the coordinate product structure.
The integer hole below compares $P(E_t)$ to $1 / |Omega| = 1 / product binom(p_i, m_i)$; replacing $|Omega|$ by $binom(P, M)$ would be the wrong denominator.

=== Remark (consecutive primes; not a generic coprime grid) <rem-sieve-consecutive-primes>

Throughout @thm-prime-tail and the lemmas below, $p_1 < p_2 < dots < p_n$ are the *first $n$ consecutive primes* ($p_1 = 2$, $p_2 = 3$, $p_3 = 5$, $dots$) with HL multiplicities $(m_i)$ from @def-m-from-h on that same prime list.
Pairwise coprimality is automatic, but the *ordered* sizes $p_1 = 2$, $p_(i+1) <= p_i^2$ (@lem-pn-vs-square), and $log P = sum_(i=1)^n log p_i = Theta(p_n)$ are what enter the period and cutoff arguments.
The domination and sieve targets below are *not* stated for an abstract coprime tuple $(p_i, m_i)$ with unrelated primes.

=== Remark (two difficulties: hole versus domination) <rem-sieve-two-difficulties>

The sieve target on the *first* configuration space $Omega$ is
$ P_(Omega)(E_(p_n^2)) < 1 / |Omega| = 1 / product_(i=1)^n binom(p_i, m_i) $ (@prime-delay-bound, @rem-config-count).
Two logically separate steps appear in every second-distribution approach:

+ *Parameter hole (easy for HL in the product model).* Compare a miss probability built only from $(P, M) = (product p_i, product m_i)$ to $1 / |Omega|$. In the coordinate-product second law below (@def-second-product-coord, @lem-second-product-hole-hl), this is essentially trivial at $t_n = p_n^2$ once $p_n^2 > p_i$ for every $i <= n$.

+ *Cutoff transfer (hard; not permanent).* Show that the *intersection* first law on $Omega$ is dominated by that second miss rate: $P_(Omega)(U^(I) > t) <= P^(I I)(U^(I I) > t)$. This *fails in general* (@rem-first-not-dominate-second): the first event ${1, dots, t} inter D(bold(S)) = nothing$ is *larger* than the coordinate-product miss event, so $P_(Omega)(E_t) >= P^(I I,"prod")(E_t)$, not $<=$.

The aggregated hypergeometric model (@def-second-agg-modulus) reverses the difficulty: @lem-first-miss-dominated-agg is checked on small HL data, but @eq-sieve-hole-agg often fails for moderate $n$ (twins: first near $n approx 19$) while $N_("bad") (p_n^2) = 0$ still holds (@lem-sieve-hole-finite).
Neither the geometric bound $(1 - M/P)^t$ nor the aggregated hole alone closes HL for all depths; the unconditional input is the finite head check and periodic budget (@cor-hl-budget-gap).

=== Remark (aggregated hole versus configuration count) <rem-sieve-hole-threshold>

The target denominator is always $1 / |Omega| = 1 / product binom(p_i, m_i)$, *not* $1 / binom(P, M)$ on $Omega^("agg")$ (@rem-config-count).
For moderate $n$, @eq-sieve-hole-agg may fail even when $N_("bad") (p_n^2) = 0$; see @lem-sieve-hole-finite and @rem-sieve-two-difficulties.

=== Product-coordinate second law at $(P, M)$ (not intersection) <def-second-product-coord>

Collapse the coordinates as in @def-setup:
$ P = product_(i=1)^n p_i, quad M = product_(i=1)^n m_i $.
The *first distribution* remains $bold(S) = (S_1, dots, S_n) in Omega$ with CRT intersection $D(bold(S))$ and
$ E_t^(I) = { U^(I) > t } = { {1, dots, t} inter D(bold(S)) = nothing } $ (@def-all-zeroes).

Define the *product-coordinate second* event at the same $(P, M)$ but *without* the intersection:
for $R_i (t) := { x mod p_i : 1 <= x <= t }$ and $k_i (t) := |R_i (t)|$,
$
  E_t^(I I,"prod")
  := { S_i inter R_i (t) = nothing " for every " i = 1, dots, n } .
$
On the product space $Omega$, with $bold(S)$ uniform,
$
  P_(Omega)(E_t^(I I,"prod"))
  = product_(i=1)^n binom(p_i - k_i (t), m_i) / binom(p_i, m_i) .
$ <eq-second-prod-miss>
This depends only on $(p_i, m_i)$ and $t$; it does *not* pass through $D(bold(S))$ or $binom(P, k, M)$.

=== Aggregated hypergeometric second (intersection-style on one modulus) <def-second-agg-modulus>

With the same $P$, $M$, define $Omega^("agg")$ to be the family of $M$-subsets $T subset ZZ / P ZZ$ with $|T| = M$, uniform, and
$ U^(I I,"agg") := min{ t >= 1 : t mod P in T } $,
$ E_t^(I I,"agg") := {U^(I I,"agg") > t}$.

This is an *intersection-style* benchmark on one modulus: a single $T subset ZZ / P ZZ$ plays the role of $D(bold(S))$.
It is *not* the same as @eq-second-prod-miss.

=== Pinned aggregated second distribution <def-second-agg-modulus-pin>

In the same setting as @def-second-agg-modulus, define the *pinned* aggregated space
$ Omega^("agg","pin") := { T subset ZZ / P ZZ : |T| = M, 0 in T } $,
uniform with $|Omega^("agg","pin")| = binom(P - 1, M - 1)$.
Let $U^(I I,"pin") := min{ t >= 1 : t mod P in T }$ for $T$ uniform on $Omega^("agg","pin")$.

This matches the pinned $n = 1$ law (@eq-ex) at modulus $(P, M)$: one fixes $0 in T$ and draws the remaining $M - 1$ residues uniformly from ${1, dots, P - 1}$.

=== Pinned product first distribution (sieve comparison) <def-omega-pin-sieve>

For the *first* distribution on the consecutive scan, use the pinned product space
$ Omega^("pin") = product_(i=1)^n Omega_i^("pin") $
from @def-config-space ($0 in S_i$ for every $i$), with
$ |Omega^("pin")| = product_(i=1)^n binom(p_i - 1, m_i - 1) $.
Let $U^(I,"pin")$ be the first positive #ONE for $bold(S)$ uniform on $Omega^("pin")$.
The unpinned law on $Omega$ is still used for @lem-zero-count on the full configuration space (@cor-prime-delay-first); the pinned pair below is the correct apples-to-apples comparison with @def-second-agg-modulus-pin (as in @sec-pinned-moments).

=== Product-coordinate hole for HL tail data <lem-second-product-hole-hl>

Fix admissible $bold(h)$ with $ell = ell (bold(h))$, tail gap $K = K_(bold(h))$, and HL multiplicities $(p_i, m_i)$ from @def-m-from-h on consecutive primes.
Let $t_n = p_n^2$ and $n >= ell$.

+ If $p_n^2 >= p_i$ for every $i <= n$ (equivalently $t_n >= p_n$, which holds for $n >= 2$ by @lem-pn-vs-square), then $k_i (t_n) = p_i$ for each $i <= n$, hence $binom(p_i - k_i (t_n), m_i) = 0$ and
  $ P_(Omega)(E_(t_n)^(I I,"prod")) = 0 < 1 / |Omega| $.

+ On the tail $i >= ell$ with $p_i - m_i = K$ and $p_i > K$, the factor $binom(p_i - k_i (t_n), m_i) / binom(p_i, m_i)$ is zero once $k_i (t_n) = p_i$; the head contributes only finitely many positive factors.

*Proof.*
For $t_n = p_n^2 >= p_n >= p_i$, every residue mod $p_i$ appears among ${1, dots, t_n}$, so $R_i (t_n) = ZZ / p_i ZZ$ and $k_i (t_n) = p_i$.
Then $binom(p_i - p_i, m_i) = binom(0, m_i) = 0$ for $m_i >= 1$.
@eq-second-prod-miss gives $P_(Omega)(E_(t_n)^(I I,"prod")) = 0$.
Since $|Omega| >= 1$, $0 < 1 / |Omega|$. $square$

This shows the *parameter-level* hole is easy in the product-coordinate model; it does *not* bound $P_(Omega)(E_(t_n)^(I))$ without a separate domination argument (@rem-first-not-dominate-second).

=== Aggregated miss probability (unpinned) <lem-agg-miss-prob>

In @def-second-agg-modulus, let $R_t := { x mod P : x in {1, dots, t} }$ and $k_t := |R_t| <= min(t, P)$.
Then
$
  P(E_t^(I I,"agg"))
  = binom(P - k_t, M) / binom(P, M)
  <= (1 - M / P)^(k_t)
  <= (1 - M / P)^t .
$ <eq-agg-miss>

*Proof.*
Avoiding all #ONES in ${1, dots, t}$ means choosing an $M$-subset of $ZZ / P ZZ$ disjoint from $R_t$, giving the exact count $binom(P - k_t, M) / binom(P, M)$.
@eq-coordinate-miss with $(p, m, k) = (P, M, k_t)$ yields the two inequalities. $square$

=== Pinned aggregated miss probability <lem-agg-miss-prob-pin>

In @def-second-agg-modulus-pin, let $R_t^+ := { x mod P : x in {1, dots, t} }$ and $k_t^+ := |R_t^+|$.
For $t < P$ (so $0 in.not R_t^+$),
$
  P(U^(I I,"pin") > t)
  = binom(P - 1 - k_t^+, M - 1) / binom(P - 1, M - 1) .
$ <eq-agg-miss-pin>
For general $t$, with $ell_t := |R_t^+ union {0}|$,
$
  P(U^(I I,"pin") > t) = binom(P - ell_t, M - 1) / binom(P - 1, M - 1)
$
when $M - 1 <= P - ell_t$ (otherwise the probability is $0$).

*Proof.*
Fix $t < P$. A pinned $M$-set $T$ misses every positive $x in {1, dots, t}$ iff $T inter R_t^+ = nothing$ and $0 in T$, so the free part is an $(M-1)$-subset of $ZZ / P ZZ without {0} union R_t^+$, which has $P - 1 - k_t^+$ elements.
Counting gives @eq-agg-miss-pin.
The general $ell_t$ case is the same with $P - ell_t$ available residues. $square$

=== Bad configurations inject into aggregated misses <lem-crt-bad-le-count>

Let $N_("bad") (t)$ be as in @def-all-zeroes, $k_t = |R_t|$ as in @lem-agg-miss-prob, and $M = product_(i=1)^n m_i$.
Then
$ N_("bad") (t) <= binom(P - k_t, M) $.

*Proof.*
If $bold(S) in Omega$ has no #ONE in ${1, dots, t}$, then $D(bold(S)) inter {1, dots, t} = nothing$, so $D(bold(S)) inter R_t = nothing$.
By @lem-crt-size, $|D(bold(S))| = M$.
By @lem-crt-D-injective, $bold(S) mapsto D(bold(S))$ is injective on $Omega$, hence
$
  N_("bad") (t)
  = |{ bold(S) in Omega : D(bold(S)) inter R_t = nothing }|
  = |{ T subset ZZ / P ZZ : |T| = M, T inter R_t = nothing, T = D(bold(S)) " for some " bold(S) }|
  <= |{ T subset ZZ / P ZZ : |T| = M, T inter R_t = nothing }|
  = binom(P - k_t, M) .
$ $square$

=== First versus second: inclusion and domination <rem-first-not-dominate-second>

With $E_t^(I)$, $E_t^(I I,"prod")$, and $E_t^(I I,"agg")$ as above:

+ *Coordinate product versus intersection.*
  $E_t^(I I,"prod") subset E_t^(I)$: if every $S_i$ misses all residues $x mod p_i$ with $x in {1, dots, t}$, then no $x in {1, dots, t}$ can lie in $D(bold(S))$.
  Hence
  $ P_(Omega)(E_t^(I I,"prod")) <= P_(Omega)(E_t^(I)) $.
  The *reverse* inequality $P_(Omega)(E_t^(I)) <= P_(Omega)(E_t^(I I,"prod"))$ *fails in general*: a configuration can have every $S_i$ meeting some residue from $R_i (t)$ while still having no global CRT point in ${1, dots, t}$.

+ *Aggregated versus first.*
  The comparison $P_(Omega)(E_t^(I)) <= P(E_t^(I I,"agg"))$ is *not* a consequence of subset relations on the same sample space (@lem-domination-density, @rem-domination-open).
  Do *not* assume $P_(Omega)(U^(I) > t) <= P^(I I)(U^(I I) > t)$ for all $t$, $n$, and HL data.

+ *Contrast with @lem-second-product-hole-hl.*
  There $P_(Omega)(E_(p_n^2)^(I I,"prod")) = 0$ for $n >= 2$, while $P_(Omega)(E_(p_n^2)^(I))$ is typically positive on the random model.
  So the first law need not dominate the product-coordinate second *forever*; the easy HL inequality is $0 < 1 / |Omega|$, not $P_(Omega)(E^(I)) <= P^(I I,"prod")$.

=== Count bound and aggregated comparison (partial) <lem-first-miss-dominated-agg>

In the setting of @def-second-agg-modulus,
$
  P_(Omega)(U^(I) > t)
  = N_("bad") (t) / product_(i=1)^n binom(p_i, m_i)
  <= binom(P - k_t, M) / product_(i=1)^n binom(p_i, m_i) .
$ <eq-first-miss-count-agg>
When additionally
$
  P_(Omega)(E_t^(I)) <= P(E_t^(I I,"agg")) = binom(P - k_t, M) / binom(P, M) ,
$ <eq-first-miss-dom-agg>
@eq-first-miss-dom-agg together with @eq-sieve-hole-agg yields @cor-prime-delay-first only where both inequalities hold; the unconditional HL input remains @lem-sieve-hole-finite (@rem-sieve-two-difficulties).
@eq-first-miss-dom-agg is *not* proved in general (@rem-domination-open, @lem-domination-injectivity-insufficient); the only complete case in this file is $n = 1$ (@lem-domination-n1).

*Proof.*
@lem-crt-bad-le-count gives @eq-first-miss-count-agg.
@lem-agg-miss-prob identifies $P(E_t^(I I,"agg"))$. $square$

=== Domination cutoff $t <= K p_n$ (same $K$ as tail gap) <def-domination-cutoff-Kpn>

Fix admissible $bold(h)$ with $ell = ell (bold(h))$, uniform tail gap $K = K_(bold(h))$ (so $p_i - m_i = K$ for $i >= ell$), and HL multiplicities on the first $n$ consecutive primes.
Write $t_n^(K) := K p_n$ and $t_n^(2) := p_n^2$.

The *domination cutoff* is the integer window ${1, dots, t_n^(K)}$:
one asks whether
$
  P_(Omega)(E_t^(I)) <= P(E_t^(I I,"agg"))
  quad "for every " t in {1, dots, t_n^(K)} ,
$ <eq-dom-agg-Kpn-window>
or at least at the endpoint $t = t_n^(K)$.
This uses the *same* $K$ as the tail condition $p_i - m_i = K$; it is *not* the sieve cutoff $t_n^(2) = p_n^2$ from @prime-delay-bound.

=== Period dominates $K p_n$ on consecutive primes <lem-Kpn-below-period>

In the setting of @thm-prime-tail with consecutive primes $p_1 = 2 < p_2 = 3 < dots < p_n$ and $P = product_(i=1)^n p_i$:

+ For $n >= 3$, $K p_n < P$ for every integer $K >= 1$.
+ For $n = 2$, $P = 6$ and $K p_2 = 3 K$; hence $K p_2 < P$ iff $K = 1$, while $K p_2 = P$ when $K = 2$.

*Proof.*
For $n = 2$, $P = 2 times 3 = 6$ and $K p_2 = 3 K$; the table is immediate.

For $n >= 3$, $P = product_(i=1)^n p_i >= p_1 p_2 p_3 = 30$.
Also $p_n >= p_3 = 5$, so $K p_n <= K p_n$ with fixed $K$ is maximized at the largest $n$ in a given range; it suffices to check $30 > K p_3 = 5 K$ for $n = 3$, i.e.\ $K < 6$, which holds for every fixed HL tail gap $K = K_(bold(h))$.
For $n >= 4$, $P >= 30 p_4 / p_3 = 42 > 6 p_n$ since $p_n >= 7$, hence $P > K p_n$ for every $K >= 1$. $square$

=== Distinct residues when $t = K p_n$ is at most the period <lem-kpn-distinct-residues>

In the setting of @thm-prime-tail, let $P = product_(i=1)^n p_i$ and $t = K p_n$.
If $t <= P$ (in particular when $K p_n < P$ by @lem-Kpn-below-period, or when $n = 2$ and $K p_2 = P = 6$), then
$ k_t = |{ x mod P : 1 <= x <= t }| = t = K p_n $.

*Proof.*
For $1 <= x < y <= t <= P$, the residues $x mod P$ and $y mod P$ are distinct: if $x equiv y mod P$, then $P mid (y - x)$ with $0 < y - x < P$, impossible.
Thus each $x in {1, dots, t}$ contributes a distinct class and $k_t = t$. $square$

=== Domination at $n = 1$ (modulus $p_1 = 2$) <lem-domination-n1>

In the consecutive-prime chain, $n = 1$ means $p_1 = 2$ only.
Then $P = p_1$, $M = m_1$, $|Omega| = binom(p_1, m_1) = binom(P, M)$, and $D(S_1) = S_1$.
For every $t >= 1$ with $k_t = |{ x mod P : 1 <= x <= t }|$,
$
  P_(Omega)(E_t^(I)) = binom(P - k_t, M) / binom(P, M) = P(E_t^(I I,"agg")) .
$

*Proof.*
Each configuration is an $m_1$-subset $S_1 subset ZZ / p_1 ZZ$; ${1, dots, t} inter D(S_1) = nothing$ iff $S_1 inter R_t = nothing$.
Counting gives $N_("bad") (t) = binom(p_1 - k_t, m_1)$ and $|Omega| = binom(p_1, m_1)$, hence the first probability equals $binom(P - k_t, M) / binom(P, M)$.
The aggregated second law is the same count on $Omega^("agg")$ (@lem-agg-miss-prob). $square$

=== Domination as a density on CRT images <lem-domination-density>

In the setting of @thm-prime-tail (@rem-sieve-consecutive-primes), let $Phi : Omega -> 2^{{0, dots, P - 1}}$ be $Phi(bold(S)) = D(bold(S))$ (@lem-crt-D-injective), $R_t$ and $k_t$ as in @lem-agg-miss-prob, and
$
  cal(A)_t := { T subset ZZ / P ZZ : |T| = M, T inter R_t = nothing, T in Phi(Omega) } .
$
Then $N_("bad") (t) = |cal(A)_t|$ and
$
  P_(Omega)(E_t^(I)) = |cal(A)_t| / |Omega| ,
  quad
  P(E_t^(I I,"agg")) = binom(P - k_t, M) / binom(P, M) .
$
Thus @eq-first-miss-dom-agg is equivalent to
$
  |cal(A)_t| / |Omega| <= binom(P - k_t, M) / binom(P, M) ,
$ <eq-dom-density>
i.e.\ CRT images that miss $R_t$ are not over-represented among *all* $M$-subsets that miss $R_t$.

*Proof.*
@lem-crt-bad-le-count gives $cal(A)_t = { Phi(bold(S)) : bold(S) in Omega, Phi(bold(S)) inter R_t = nothing }$ with $|cal(A)_t| = N_("bad") (t)$.
Injectivity identifies $N_("bad") (t)$ with the numerator in @eq-dom-density.
@lem-agg-miss-prob is the denominator identity. $square$

=== Injectivity does not imply domination <lem-domination-injectivity-insufficient>

In the setting of @lem-domination-density, @lem-crt-bad-le-count gives only
$ |cal(A)_t| <= binom(P - k_t, M) $.
Dividing by $|Omega| = |Phi(Omega)|$ yields @eq-first-miss-count-agg, but *not* @eq-dom-density, because in general
$ binom(P, M) > |Omega| $ (@rem-config-count).
Indeed, whenever $cal(A)_t = Phi(Omega)$ (every CRT image misses $R_t$), the left side of @eq-dom-density equals $1$ while the right side is $binom(P - k_t, M) / binom(P, M) < 1$ once $k_t > 0$ and $M <= P - k_t$.
So any proof of @eq-first-miss-dom-agg must use structure of $Phi(Omega)$ beyond @lem-crt-D-injective.

=== Remark (domination cutoff versus sieve cutoff) <rem-domination-cutoff-vs-sieve>

Two cutoffs must not be conflated (@rem-sieve-two-difficulties):

+ *Domination cutoff* $t_n^(K) = K p_n$.
  Here $k_t = K p_n$ is asymptotically negligible relative to $P$ for large $n$, so $P(E_t^(I I,"agg")) = binom(P - k_t, M) / binom(P, M)$ is typically *large* (most $M$-subsets of $ZZ / P ZZ$ still miss the small set $R_t$).
  @eq-first-miss-dom-agg is designed for this *transfer* step: compare intersection miss rate on $Omega$ to the aggregated hypergeometric rate (@lem-domination-density).
  It is *not* proved here for general $n$ and $t <= K p_n$ (@rem-domination-open).

+ *Sieve hole cutoff* $t_n^(2) = p_n^2$.
  Here $k_(t_n^(2)) = p_n^2$ once $t_n^(2) < P$ (@lem-sieve-hole-aggregated), and the target is $P_(Omega)(E_(t_n^(2))^(I)) < 1 / |Omega|$, equivalently @eq-sieve-hole-agg on the aggregated side *after* domination.
  For twins, @eq-sieve-hole-agg first becomes true near $n approx 19$ (@rem-sieve-hole-threshold), while $N_("bad") (p_n^2) = 0$ is checked directly for $n + 1 <= 6$ (@lem-sieve-hole-finite).

So domination at $K p_n$ is an *earlier, easier* comparison range than the aggregated parameter hole at $p_n^2$; closing HL for all depths still uses the finite head and periodic budget, not @eq-dom-agg-Kpn-window alone.

=== Coordinate all-miss forces intersection miss <lem-coord-implies-global-miss>

In the setting of @lem-first-miss-factorized, $E_t^("coord") subset E_t^(I)$, hence $N_("bad") (t) >= |{ bold(S) in Omega : S_i inter R_i (t) = nothing, quad forall i }| = product_(i=1)^n binom(p_i - k_i (t), m_i)$.

*Proof.*
Already noted in @lem-first-miss-factorized: if $S_i inter R_i = nothing$ for every $i$ and $x in {1, dots, t}$, then $x mod p_i in R_i (t)$ implies $x mod p_i in.not S_i$, so $x in.not D(bold(S))$. $square$

=== Two consecutive primes: product-type residue lists <lem-domination-n2-product-R>

Take $n = 2$ in the consecutive-prime chain, so $p_1 = 2$, $p_2 = 3$, $P = 6$.
Let $R_i := { x mod p_i : 1 <= x <= t }$, $k_i := |R_i|$, and $R_t := { x mod P : 1 <= x <= t }$.
If $t <= 6$ and every pair $(a, b) in R_1 times R_2$ is realized by some $x in {1, dots, t}$ (equivalently $|R_t| = k_1 k_2$; this holds for $t = 6 = P$ and fails only for smaller $t$ when some CRT pair is missing from ${1, dots, t}$),
Then for every $bold(S) = (S_1, S_2) in Omega$,
$
  D(bold(S)) inter R_t = nothing
  <==>
  S_i inter R_i = nothing " for " i = 1, 2 .
$
Hence $N_("bad") (t) = binom(p_1 - k_1, m_1) binom(p_2 - k_2, m_2)$ and
$ P_(Omega)(E_t^(I)) = product_(i=1)^2 binom(p_i - k_i, m_i) / binom(p_i, m_i) $.

*Proof.*
*Forward* is @lem-coord-implies-global-miss.
For the converse, if $S_1 inter R_1 != nothing$ and $S_2 inter R_2 != nothing$, pick $a in S_1 inter R_1$ and $b in S_2 inter R_2$.
By hypothesis there exists $x in {1, dots, t}$ with $x equiv a mod p_1$ and $x equiv b mod p_2$; then $x in D(bold(S)) inter R_t$, contradiction.
The count identity is the product of the two coordinate miss counts. $square$

=== Open domination target at $K p_n$ <rem-domination-open>

Fix $ell >= 1$, $K >= 1$, and head multiplicities $(m_i)_(i < ell)$ on consecutive primes, with tail $p_i - m_i = K$ for $i >= ell$.
The desired *domination cutoff* (@def-domination-cutoff-Kpn) is
$
  P_(Omega)(E_(K p_n)^(I)) <= binom(P - k_(K p_n), M) / binom(P, M)
  quad "once " K p_n < P " and " k_(K p_n) = K p_n
$
(@lem-kpn-distinct-residues).
This is the endpoint case of @eq-dom-agg-Kpn-window.
It does *not* follow from @lem-crt-bad-le-count or @lem-domination-injectivity-insufficient.
A proof would bound the CRT image density @eq-dom-density using the *consecutive-prime* structure of $(p_i, m_i)$: ordered sizes $p_1 = 2 < dots < p_n$, @lem-pn-vs-square, $P = product_(i=1)^n p_i$, marginal constraints $|pi_i (D(bold(S)))| = m_i$, and the tail gap $p_i - m_i = K$ for $i >= ell$.
Generic coprime moduli without this ordering are outside the HL sieve model (@rem-sieve-consecutive-primes).
Until such a bound is in place, @eq-first-miss-dom-agg must be treated as an explicit hypothesis wherever it is invoked (@cor-prime-delay-first, @cor-chain).

=== Pinned first: coordinate factorization <lem-first-miss-factorized-pin>

On $Omega^("pin")$ from @def-omega-pin-sieve, for $E_t = {U^(I,"pin") > t}$,
$
  P_(Omega^("pin"))(E_t)
  = product_(i=1)^n binom(p_i - 1 - k_i^+, m_i - 1) / binom(p_i - 1, m_i - 1) ,
$ <eq-miss-factor-pin>
where $k_i^+ := |{ x mod p_i : x in {1, dots, t} }|$ (for $t < p_i$, this is $|R_t^+|$ at modulus $p_i$).

*Proof.*
The same factorization as @eq-miss-factor, with each coordinate drawn uniformly among $m_i$-subsets that contain $0$.
For fixed $t < p_i$, a miss at $i$ is equivalent to choosing the $(m_i - 1)$ positive residues in $S_i without {0}$ disjoint from $R_t^+$, giving the stated binomial factor. $square$

=== Pinned first dominated by pinned aggregated <lem-first-miss-dominated-agg-pin>

Fix consecutive primes $p_1 = 2 < dots < p_n$ as in @thm-prime-tail, $m_i >= 2$, and $t >= 1$ with $t < min_i p_i$.
For $t = p_n^2$ with $n >= 3$, $p_n^2 < p_(n+1)$ by @lem-pn-vs-square and $p_n^2 < p_1 p_2 p_3 <= P$.
The depth-$n = 2$ case is the separate consecutive-prime model $p_1 = 2$, $p_2 = 3$, $P = 6$ (@lem-domination-n2-product-R).
On @def-omega-pin-sieve and @def-second-agg-modulus-pin,
$
  P_(Omega^("pin"))(U^(I,"pin") > t)
  <= P(U^(I I,"pin") > t)
  = binom(P - 1 - k_t^+, M - 1) / binom(P - 1, M - 1) .
$ <eq-first-miss-dom-agg-pin>

*Proof.*
@eq-miss-factor-pin gives an exact product formula for the pinned first law.
@eq-agg-miss-pin gives the pinned aggregated identity at the same $k_t^+$.
The same density issue as @lem-domination-injectivity-insufficient applies: injectivity on $Omega^("pin")$ gives a count bound but not @eq-first-miss-dom-agg-pin in general.
@eq-first-miss-dom-agg-pin is not proved here beyond the $n = 1$ specialization (@lem-domination-n1).
This lemma records the correct pinned comparison target aligned with @sec-pinned-moments. $square$

=== Remark (pinned vs.\ unpinned second model) <rem-pinned-second-align>

+ *Section 3 (moments).* $Omega^("pin")$ is compared to *coordinate-rate* geometric models at $q_i = m_i / p_i$ (@n-all-moment), not to $Omega^("agg","pin")$.
+ *Section 4 (sieve).* The *unpinned* transfer $P_(Omega)(U^(I) > t) <= binom(P - k_t, M) / binom(P, M)$ (@lem-first-miss-dominated-agg) feeds @lem-zero-count on $|Omega| = product binom(p_i, m_i)$.
+ *Pinned pair.* @lem-first-miss-dominated-agg-pin is the correct hypergeometric comparison at $(P, M)$ with $0$ pinned on both sides; it matches the Section 3 philosophy (@eq-ex) after collapsing coordinates.

=== Target inequality (sieve hole on $Omega$) <prime-delay-bound>

For $t_n := p_n^2$, the *sieve hole* target on the product configuration space is
$ P_(Omega)(E_(t_n)) < 1 / |Omega| = 1 / product_(i=1)^n binom(p_i, m_i) $.

On the tail $p_i - m_i = K$, one has $binom(p_i, m_i) = binom(p_i, K)$ and $|Omega| = product_(i=1)^n binom(p_i, K)$ (up to head factors $i < ell$).
The asymptotic target @eq-sieve-hole-agg compares the aggregated miss rate $binom(P - k_t, M) / binom(P, M)$ on $Omega^("agg")$ directly to $1 / |Omega|$; @lem-first-miss-dominated-agg and @lem-zero-count link this to $P_(Omega)$ on the CRT configuration space.

=== From a tiny probability to a mandatory #ONE <lem-zero-count>

If $P(E_t) < 1 / |Omega| = 1 / product_(i=1)^n binom(p_i, m_i)$, then $N_("bad") (t) = 0$ and *every* configuration has at least one #ONE in ${1, dots, t}$ (equivalently $U <= t$).

*Proof.*
$N_("bad") (t) = |Omega| dot P(E_t) < 1$.
Since $N_("bad") (t)$ is a non-negative integer, $N_("bad") (t) = 0$.
Thus no configuration has all #ZEROES on ${1, dots, t}$; each has $U <= t$. $square$

=== Product-rate upper bound (auxiliary; not used in the sieve hole) <lem-miss-prob-product-rate>

In the setting of @def-all-zeroes, let $M = product_(i=1)^n m_i$ and $P = product_(i=1)^n p_i$.
For every $t >= 1$,
$
  P_(Omega)(E_t) = P_(Omega)(U^(I) > t) <= (1 - M / P)^t .
$ <eq-miss-prod-rate>

*Proof.*
For $x in {1, dots, t}$, let $A_x := { x in D(bold(S)) }$.
Each $A_x$ is an *increasing* event in the coordinates $(S_1, dots, S_n)$: enlarging some $S_i$ can only add elements to $D(bold(S))$.
On a product probability space, increasing events are positively correlated (the FKG / Harris inequality; see @fkg1972 @harris1960).
Hence
$
  P_(Omega)(union_(x=1)^t A_x) >= product_(x=1)^t P_(Omega)(A_x) .
$
For a fixed $x$, choosing $bold(S)$ uniformly in $Omega$ and using independence across coordinates,
$
  P_(Omega)(A_x)
  = P_(Omega)(x in D(bold(S)))
  = product_(i=1)^n P(x mod p_i in S_i)
  = product_(i=1)^n m_i / p_i
  = M / P .
$
Therefore
$
  P_(Omega)(E_t)
  = P_(Omega)(inter_(x=1)^t A_x^c)
  = 1 - P_(Omega)(union_(x=1)^t A_x)
  <= 1 - product_(x=1)^t (M / P)
  = (1 - M / P)^t .
$ $square$

=== One-coordinate miss bound <lem-coordinate-miss-bound>

Fix integers $p > m >= 1$ and $k >= 0$ with $m <= p - k$.
Let $S$ be uniform among $m$-subsets of $ZZ / p ZZ$.
For any $k$-element set $R subset ZZ / p ZZ$,
$
  P(S inter R = nothing)
  = binom(p - k, m) / binom(p, m)
  <= (1 - m / p)^k .
$ <eq-coordinate-miss>

*Proof.*
If $m > p - k$, then $binom(p - k, m) = 0$ and @eq-coordinate-miss holds.
Assume $m <= p - k$.
Set $a_k := binom(p - k, m) / binom(p, m)$.
Then $a_0 = 1$ and, for $k >= 1$ with $m <= p - k$,
$
  a_k / a_(k-1)
  = binom(p - k, m) / binom(p - k + 1, m)
  = (p - k - m + 1) / (p - k + 1) .
$
The one-step ratio bound
$ (p - k - m + 1) / (p - k + 1) <= (p - m) / p = 1 - m / p $
is equivalent to $p (p - k - m + 1) <= (p - k + 1) (p - m)$, i.e.\ $-k p <= -k p$.
By induction, $a_k <= (1 - m / p)^k$.
The left-hand side of @eq-coordinate-miss is exactly $a_k$ when $|R| = k$ and $R$ is disjoint from the chosen $m$-set. $square$

=== Coordinate all-miss factorization (auxiliary) <lem-first-miss-factorized>

Fix $n >= 1$, consecutive primes $p_1 = 2 < dots < p_n$, and $m_i >= 1$ (@thm-prime-tail).
Let $R_i := { x mod p_i : 1 <= x <= t }$ and $k_i := |R_i| <= min(t, p_i)$.
Define the *coordinate all-miss* event
$ E_t^("coord") := { S_i inter R_i = nothing " for every " i = 1, dots, n } $.
Then
$
  P_(Omega)(E_t^("coord"))
  = product_(i=1)^n binom(p_i - k_i, m_i) / binom(p_i, m_i)
  <= (1 - M / P)^t ,
$ <eq-miss-factor>
where $M = product m_i$ and $P = product p_i$.
Moreover $E_t^("coord") subset E_t$ (if every coordinate misses every residue hit by ${1, dots, t}$, then no $x in {1, dots, t}$ lies in $D(bold(S))$), so
$ P_(Omega)(E_t) >= P_(Omega)(E_t^("coord")) $.
The *consecutive-scan* upper bound $P_(Omega)(E_t) <= (1 - M / P)^t$ is @eq-miss-prod-rate (@lem-miss-prob-product-rate), not the coordinate product formula.

*Proof.*
Independence across coordinates gives the product identity for $E_t^("coord")$.
Apply @eq-coordinate-miss on each factor with $|R| = k_i$ to obtain the product bound $<= (1 - M / P)^t$.
If $S_i inter R_i = nothing$ for every $i$ and $x in {1, dots, t}$, then for each such $x$ there exists $i$ with $x mod p_i in R_i$ and hence $x mod p_i in.not S_i$, so $x in.not D(bold(S))$ and $E_t^("coord") subset E_t$. $square$

=== Aggregated second miss rate below the configuration weight <lem-sieve-hole-aggregated>

Fix $ell >= 1$, $K >= 0$, and tail gap $p_i - m_i = K$ for $i >= ell$ on consecutive primes.
Let $P = product p_i$, $M = product m_i$, $k_t = |{ x mod P : 1 <= x <= t }|$, $t_n = p_n^2$, and $|Omega| = product_(i=1)^n binom(p_i, m_i)$.
Then there exists $N_0 = N_0 (ell, K, (m_i)_(i < ell))$ such that for every $n >= N_0$,
$
  binom(P - k_(t_n), M) / binom(P, M)
  < 1 / |Omega|
  = 1 / product_(i=1)^n binom(p_i, m_i) .
$ <eq-sieve-hole-agg>
This is the *aggregated* parameter hole; it is *not* the same as @lem-second-product-hole-hl (product-coordinate, typically $0$ at $t_n = p_n^2$).
Even when @eq-sieve-hole-agg holds, it does *not* imply $P_(Omega)(E_(t_n)^(I)) < 1 / |Omega|$ without @eq-first-miss-dom-agg (@rem-sieve-two-difficulties).
For HL, @eq-sieve-hole-agg often fails for moderate $n$ (twins: first near $n approx 19$); the unconditional sieve input is @lem-sieve-hole-finite.

*Proof.*
We compare logarithms of the two sides of @eq-sieve-hole-agg.
Set
$ L := sum_(i=1)^n log binom(p_i, m_i) = log |Omega| $
and
$ A := log binom(P - k_(t_n), M) - log binom(P, M) $,
so @eq-sieve-hole-agg is equivalent to $A < -L$.

*Tail gap $p_i - m_i = K$ for $i >= ell$.*
Then $m_i = p_i - K$ and $binom(p_i, m_i) = binom(p_i, K)$.
For $p_i > K$ (automatic once $p_i >= p_ell > K$ on the tail, and on the finite head by direct check),
$ log binom(p_i, m_i) = log binom(p_i, K) >= K log p_i - log(K!) - O(1) $.
Hence
$ L = sum_(i < ell) log binom(p_i, m_i) + sum_(i >= ell) log binom(p_i, K) >= K sum_(i = ell)^n log p_i - O(n) $,
with the $O(n)$ term coming only from the fixed head $i < ell$.

*Step 1 (the residue count $k_(t_n)$).*
For $t_n = p_n^2$, each $x in {1, dots, t_n}$ gives a distinct class $x mod P$ once $t_n < P$, because $1 <= x < y <= t_n < P$ implies $x equiv.not y mod P$.
Now $log P = sum_(i=1)^n log p_i = Theta(p_n)$ by the prime number theorem (@hardywright2008), while $t_n = p_n^2 = o(P)$.
Thus $t_n < P$ and $k_(t_n) = t_n$ for all sufficiently large $n$.

*Step 2 (hypothesis for @eq-coordinate-miss).*
@eq-coordinate-miss requires $M <= P - k_(t_n)$.
On the tail, $M/P = (product_(i < ell) m_i / p_i) dot product_(i = ell)^n (1 - K / p_i)$.
The tail product converges to a constant $c_"tail" in (0, 1)$ because $sum_(i >= ell) K / p_i < oo$, and the head factor is fixed.
So $M/P -> c_"head" c_"tail" in (0, 1)$, while $k_(t_n) / P = p_n^2 / P = o(1)$.
Therefore $M <= P - k_(t_n)$ for all large $n$.

*Step 3 (upper bound on $A$).*
Apply @eq-coordinate-miss at $(p, m, k) = (P, M, k_(t_n))$:
$
  A <= k_(t_n) log(1 - M / P) = p_n^2 log(1 - M / P) .
$
Since $0 < M/P <= c_* < 1$ for some $c_* < 1$ independent of large $n$, there exists $c_1 > 0$ with $log(1 - M/P) <= - c_1 (M/P)$, hence
$ A <= - c_1 p_n^2 (M/P) $.
Because $M/P >= c_"min" > 0$ for all large $n$ (again by the tail product and fixed head), there exists $c_2 > 0$ such that
$ A <= - c_2 p_n^2 $.

*Step 4 (lower bound on $L$).*
By the prime number theorem, $sum_(i=1)^n log p_i = Theta(p_n)$; in particular $sum_(i=ell)^n log p_i >= c_3 p_n$ for some $c_3 > 0$ and all large $n$.
Combining with the tail-gap estimate above gives $L >= K c_3 p_n - O(n)$.
Since $p_n -> oo$, there exists $c_4 > 0$ such that $L >= c_4 p_n$ for all large $n$.

*Step 5 (closure).*
We have $A <= - c_2 p_n^2$ and $L >= c_4 p_n$.
For $n$ large enough, $c_2 p_n^2 > c_4 p_n$, hence $A < -L$ and @eq-sieve-hole-agg holds.

*Edge case $K = 0$ on the tail.*
Then $m_i = p_i$ for $i >= ell$, so $M = P$ and $binom(P - k_(t_n), M) = 0$ whenever $k_(t_n) > 0$, which holds for $n$ large.
The left-hand side of @eq-sieve-hole-agg is then $0 < 1 / |Omega|$. $square$

=== Aggregated sieve hole (conditional on domination) <cor-prime-delay-first>

Suppose $n >= N_0$ from @lem-sieve-hole-aggregated and @eq-first-miss-dom-agg holds at $t_n = p_n^2$ (hypothesis; not proved in general, @rem-domination-open, @rem-first-not-dominate-second).
Then
$
  P_(Omega)(U^(I) > t_n)
  <= binom(P - k_(t_n), M) / binom(P, M)
  < 1 / product_(i=1)^n binom(p_i, m_i)
$
by @eq-sieve-hole-agg, and @lem-zero-count gives $N_("bad") (t_n) = 0$.

*Proof.*
@lem-first-miss-dominated-agg, @lem-sieve-hole-aggregated, @lem-zero-count. $square$

The unconditional HL cutoff uses @lem-sieve-hole-finite for $ell <= n < N_0$ and does not require @cor-prime-delay-first (@cor-chain).

=== Finite head check <lem-sieve-hole-finite>

Fix admissible $bold(h)$ with tail data $ell = ell (bold(h))$, $K = K_(bold(h))$, and HL multiplicities $(p_i, m_i)$ from @def-m-from-h on the first $n$ consecutive primes.
Let $t_n = p_n^2$ and $|Omega| = product_(i=1)^n binom(p_i, m_i)$ (@rem-config-count).
For each $n$ with $ell <= n < N_0 (ell, K, (m_i)_(i < ell))$, where $N_0$ is as in @lem-sieve-hole-aggregated,
$
  N_("bad") (t_n) = 0 .
$
Equivalently, every $bold(S) in Omega$ has a #ONE in ${1, dots, t_n}$, so $U(bold(S)) <= t_n$; in particular $U(bold(S) (bold(h))) <= t_n$.

*Verification procedure.*
$|Omega|$ is finite. For each $bold(S) = (S_1, dots, S_n) in Omega$, test whether ${1, dots, t_n} inter D(bold(S)) = nothing$; increment $N_("bad") (t_n)$ when it is empty.
This is a finite exhaustive search over $product_(i=1)^n binom(p_i, m_i)$ configurations.

*Twin primes $bold(h) = (0, 2)$.*
Here $ell = 2$, $K = 2$, and $m_1 = 1$, $m_i = p_i - 2$ for $i >= 2$.
The script #text[scripts/verify\_sieve\_hole.py] reproduces the counts below (run: #text[python3 scripts/verify\_sieve\_hole.py --pattern twins --max-n 6]).

#table(
  columns: (auto, auto, auto, auto, auto),
  align: (right, right, right, right, center),
  table.header([$n$], [$p_n$], [$t_n = p_n^2$], [config count], [$N_("bad") (t_n)$]),
  [2], [3], [9], [6], [0],
  [3], [5], [25], [60], [0],
  [4], [7], [49], [1260], [0],
  [5], [11], [121], [69300], [0],
  [6], [13], [169], [5405400], [0],
)

For these depths, @eq-sieve-hole-agg often *fails* (the asymptotic aggregated hole is not yet active), yet $N_("bad") (t_n) = 0$ holds directly.
For twin primes, the script reports the first depth with @eq-sieve-hole-agg active near $n = 19$ ($p_n = 67$); for $ell <= n < N_0$ the finite check is the valid input to @lem-zero-count.

*Proof.*
For $bold(h) = (0, 2)$ and $2 <= n <= 6$, the table entries are the output of the exhaustive procedure (verified by #text[scripts/verify\_sieve\_hole.py]).
Each entry $N_("bad") (t_n) = 0$ implies $P(E_(t_n)) = 0 < 1 / |Omega|$, hence @lem-zero-count gives $U(bold(S)) <= t_n$ for every configuration.
The same finite procedure applies to any other admissible $bold(h)$ and each $n < N_0$; carrying it out is a purely combinatorial computation in $|Omega|$. $square$

=== Second distribution comparison on CRT grids (optional) <lem-second-bigger>

*Scope.* This lemma applies to the *CRT-grid* waiting-time laws of Section 3 (@sec-pinned-moments), not to the consecutive scan used for $E_t$ above.
Fix direction $i$ with $m_i >= 2$ and $1 <= t <= p_i - m_i$.
Let $U_i^(I)$ be the grid first-hit time and $U_i^(I I) ~ "Geometric"(q_i)$ with $q_i = m_i / p_i$ (@lem-geom-survival).
Then
$ P(U_i^(I) > t) > P(U_i^(I I) > t) = (1 - q_i)^t $,
so the intersection (first) model has *longer* capped zero runs than the coordinate-rate geometric model.

*Proof.*
@lem-crt-general identifies $U_i^(I)$ with the pinned $n = 1$ waiting time on $(p_i, m_i)$; @tail-ineq / @n1-moment give $P(U_i^(I) > t) > P(U_i^(I I) > t)$ for $1 <= t <= p_i - m_i$. $square$

This comparison is *not* used to prove the consecutive-scan bounds below; @cor-chain records it as an optional grid-range benchmark only.
A product-rate benchmark would reverse the inequality (@rem-prod-rate).

=== Saturated tail ($K = 0$ on the tail) <thm-prime-saturated>

If $K = 0$ on the tail $i >= ell$, then $m_i = p_i$ and $S_i = ZZ / p_i ZZ$ for every tail coordinate.
If in addition $m_i = p_i$ for *every* $i <= n$ (head and tail both saturated), then $D(bold(S)) = {0, dots, P - 1}$ and $U = 1$ always.
If only the tail is saturated, $U = 1$ once $1 in S_i$ for every head coordinate $i < ell$ (@lem-all-ones).

*Proof.*
Full saturation makes every residue class compatible, so $1 in D(bold(S))$.
Tail-only saturation gives $1 in S_i$ for every $i >= ell$; if the head also allows $1$ at each $i < ell$, then $1 in D(bold(S))$. $square$

=== Nondegenerate allowed sets <def-nondegenerate>

Call $bold(S) = (S_1, dots, S_n)$ *nondegenerate* if $m_i = 1 arrow.r.double 0 in.not S_i$ for every $i$.
For admissible $bold(h)$ and $p > H_(max) = max_j |h_j|$, one has $0 in F_p (bold(h))$ whenever some $h_j = 0$, hence $0 in.not S_p (bold(h))$ (@def-hl-pattern).

=== When $1$ lies in every coordinate <lem-all-ones>

If $1 in S_i$ for every $i in {1, dots, n}$, then $1 in D(bold(S))$ and $U(bold(S)) = 1$.

*Proof.*
Immediate. $square$

=== Hardy--Littlewood anchor bound <cor-hl-witness-pn>

Fix admissible $bold(h)$ and sieve depth $n >= ell (bold(h))$ on consecutive primes $p_1 < dots < p_n$.
Let $bold(S) = bold(S) (bold(h))$ be the deterministic configuration from @def-m-from-h.
Define $W(bold(h)) >= 1$ as follows: for each $i >= 1$, let
$ s_i := cases(1 & "if " 1 in S_(p_i) (bold(h)), min S_(p_i) (bold(h)) without {0} & "otherwise") $
(the minimum is over a nonempty set because $0 in.not S_p (bold(h))$ for every odd $p > 2$ when $0 in F_p (bold(h))$, and the finitely many small primes are checked directly).
Let $u(bold(h)) in {1, dots, P}$ be the unique CRT integer with $u(bold(h)) equiv s_i mod p_i$ for every $i <= n$, where $P = product_(i=1)^n p_i$ (@lem-crt-bijection).
Set $W(bold(h)) := u(bold(h))$ at the current sieve depth $n$ (so $W$ depends on $n$ as well as $bold(h)$).
Once $p_i > H_(max)$ and $1 in S_(p_i) (bold(h))$, each new tail coordinate uses $s_i = 1$; the recipe for $(s_i)$ is then fixed, but $u(bold(h))$ must still be recomputed by CRT at each depth and need not agree with any earlier anchor.

If $p_n >= W(bold(h))$, then $U(bold(S) (bold(h))) <= W(bold(h)) <= p_n$.

*Proof.*
By construction $u(bold(h)) mod p_i = s_i in S_(p_i) (bold(h))$ for every $i <= n$, so $u(bold(h)) in D(bold(S) (bold(h)))$.
Hence $U <= u(bold(h)) = W(bold(h))$.
If $p_n >= W(bold(h))$, then $U <= p_n$. $square$

*Example (twin primes $bold(h) = (0, 2)$).*
At $p_1 = 2$ one has $s_1 = 1$; at $p_2 = 3$ one has $1 in F_3$, so $s_2 = min S_3 without {0} = 2$; for each odd $p_i > 3$, $1 in S_(p_i)$ and $s_i = 1$.
At depth $n = 2$ the CRT anchor is $u = 5$, so $W = 5$ and $p_2 = 3 < 5$: @cor-hl-witness-pn gives $U <= 5$ but not $U <= p_2$ (indeed $U = 5 > p_2$).
At depth $n = 3$ one must also impose $u equiv 1 mod 5$; since $5 equiv 0 mod 5$, the anchor becomes $u = 11$ ($11 equiv 1 mod 2$, $11 equiv 2 mod 3$, $11 equiv 1 mod 5$), with $p_3 = 5 < 11$.
In general $W$ grows with $n$; only the tail rule $s_i = 1$ for odd $p_i > 3$ is stable, not the integer $u$.
For this pattern, $p_n >= W$ holds only at $n = 1$ ($p_1 = 2 >= W = 1$); already at $n = 2$ one has $p_2 = 3 < W = 5$.

=== Remark: anchor scale versus $p_n$ <rem-W-vs-pn>

The anchor $W(bold(h)) = u(bold(h))$ is the CRT class modulo $P = product_(i=1)^n p_i$, so $1 <= W < P$.
Since $log P = sum_(i=1)^n log p_i ~ p_n$ while $p_n ~ n log n$, the modulus $P$ (and typically $W$ once the congruences force $u > 1$ on many primes) grows *much faster* than $p_n$---heuristically $log W = Theta(p_n)$, i.e. $W$ is super-polynomial and often hyper-exponential in $n$ relative to $p_n$.

*Consequence.*
The hypothesis $p_n >= W(bold(h))$ holds only for *finitely many* small depths $n$ (in the twin example above, only $n = 1$).
For all sufficiently large $n$, $p_n < W(bold(h))$.

When $p_n < W(bold(h))$, @cor-hl-witness-pn still proves $u(bold(h)) in D(bold(S) (bold(h)))$ and $U(bold(S) (bold(h))) <= W(bold(h))$, but it implies *nothing* about the short bound $U <= p_n$.
The unconditional comparison remains $U <= P$ from @cor-one-before-P, with $P$ itself eventually far larger than $p_n^2$.

Every corollary that deduces $U <= p_n$, $x <= p_(n+1)$, or $L_0 <= p_n - 1$ from @cor-hl-witness-pn must state $p_n >= W(bold(h))$ (or $p_(n+1) >= W$ at the relevant depth) explicitly; *large $n$ alone does not suffice.*

=== Remark: the short bound is not universal <rem-not-universal>

#block(stroke: 0.5pt + gray, inset: 8pt)[
  The bound $U <= p_n$ for *every* nondegenerate $bold(S) in Omega$ with a uniform tail gap is *false*.
  For example $p_1 = 2$, $p_2 = 3$, $S_1 = {0}$, $S_2 = {0}$ gives $D = {0, 6, 12, dots}$ and $U = 6 > p_2 = 3$.
  The general theorem @cor-one-before-P always gives $U <= P$; the short witness $U <= p_n$ from @cor-hl-witness-pn requires $p_n >= W(bold(h))$ and is false without that hypothesis (@rem-W-vs-pn).
]

=== Corollary (#ONE before the next prime, HL only) <cor-one-before-p>

Fix admissible $bold(h)$ and $n >= ell (bold(h))$ with $p_n >= W(bold(h))$.
For $bold(S) = bold(S) (bold(h))$,
$ U(bold(S)) <= p_n $.
In particular, $U <= p_n^2$.

*Proof.*
@cor-hl-witness-pn. $square$

=== Consecutive prime squares dominate the next prime <lem-pn-vs-square>

If $p_n < p_(n+1)$ are consecutive primes, then $p_(n+1) <= p_n^2$ for every $n >= 1$.

*Proof.*
For $n = 1$, $p_1 = 2$, $p_2 = 3$, and $3 <= 4$.
For $n >= 2$, Bertrand's postulate (elementary; see @hardywright2008) gives $p_(n+1) < 2 p_n$, hence
$ p_(n+1) < 2 p_n <= p_n^2 $
because $p_n >= 2$. $square$

=== Corollary (HL empty-run probability) <cor-prime-tail-prob>

Fix admissible $bold(h)$ and $n >= ell (bold(h))$ with $p_n >= W(bold(h))$.
For the deterministic configuration $bold(S) (bold(h))$ and every $t >= p_n$,
$ P(U > t) = 0 $ (equivalently $U <= p_n$).

*Proof.*
@cor-hl-witness-pn gives $U(bold(S) (bold(h))) <= p_n <= t$. $square$

=== Uniform tail gap ($p_i - m_i = K$ for $i >= ell$) <thm-prime-const-gap>

Assume $p_i - m_i = K$ for every $i >= ell$ (with $K >= 0$ fixed and $0 <= m_i <= p_i$ on the head).
Fix admissible $bold(h)$ matching this tail gap and $n >= ell (bold(h))$ (with $N_0$ from @lem-sieve-hole-aggregated for the asymptotic range).
Let $t_n = p_n^2$.
Then for $bold(S) = bold(S) (bold(h))$, $P(U > t_n) = 0$, @prime-delay-bound holds, and $U(bold(S) (bold(h))) <= t_n$.

*Proof.*
@cor-prime-large-n. $square$

*Examples.*
$K = 0$ on the full sieve is @thm-prime-saturated.
For $bold(h) = (0, 2)$, the anchor is $W = 5$ at depth $n = 2$ and $W = 11$ at $n = 3$ (@cor-hl-witness-pn).

=== Sieve hole for HL multiplicities (no anchor) <cor-prime-large-n>

Fix admissible $bold(h)$ with uniform tail gap $K = K_(bold(h))$ for $i >= ell (bold(h))$ and HL multiplicities from @def-m-from-h.
Whenever $N_("bad") (p_n^2) = 0$ on the full space $Omega$ (@def-all-zeroes),
$
  P(U(bold(S) (bold(h))) > p_n^2) = 0
  quad text("and") quad
  U(bold(S) (bold(h))) <= p_n^2 .
$

*Proof.*
If $N_("bad") (p_n^2) = 0$, no configuration has ${1, dots, p_n^2} inter D(bold(S)) = nothing$, so the deterministic $bold(S) (bold(h))$ has a #ONE in ${1, dots, p_n^2}$ and $U(bold(S) (bold(h))) <= p_n^2$. $square$

*Inputs that force $N_("bad") (p_n^2) = 0$.*

+ *Finite head.* @lem-sieve-hole-finite (exhaustive on $|Omega|$; twins $bold(h) = (0, 2)$ verified for $2 <= n <= 6$ in the table there, @rem-finite-verify-scope).

+ *Optional large $n$.* @cor-prime-delay-first when @eq-first-miss-dom-agg and @eq-sieve-hole-agg both hold at $t_n = p_n^2$ (@rem-sieve-two-difficulties).

+ *Not used for domination.* @lem-second-product-hole-hl gives $P_(Omega)(E_(p_n^2)^(I I,"prod")) = 0 < 1 / |Omega|$ but does not bound $P_(Omega)(E_(p_n^2)^(I))$ without a separate argument (@rem-first-not-dominate-second).

=== Remark (finite verification scope) <rem-finite-verify-scope>

@lem-sieve-hole-finite is stated at sieve depth $n$ with threshold $t_n = p_n^2$.
@cor-hl-full-tuple uses depth $n + 1$, so a printed row at index $n$ covers the full-tuple witness bound when the corollary is invoked with parameter $n - 1$.

For $bold(h) = (0, 2)$, the table verifies $N_("bad") (p_n^2) = 0$ for $2 <= n <= 6$, hence @cor-prime-large-n holds for depths $2, dots, 6$ and @cor-hl-full-tuple holds for $n + 1 <= 6$ (i.e.\ $n <= 5$).
For $7 <= n + 1 < N_0$, the same exhaustive procedure applies; for twins, @eq-sieve-hole-agg on the aggregated model is first near $n approx 19$ (@rem-sieve-hole-threshold), so depths $7, dots, 18$ are a finite gap (#text[scripts/verify\_sieve\_hole.py --max-n N]).
Large $n$ may alternatively use @cor-prime-delay-first only when domination @eq-first-miss-dom-agg is verified at that depth.

=== Main consequence: a #ONE before $p_n^2$ for $bold(S) (bold(h))$ <cor-one-before-sqrt>

Fix admissible $bold(h)$ and $n >= ell (bold(h))$.
For $bold(S) = bold(S) (bold(h))$,
$ U(bold(S)) <= p_n^2 $.

*Proof.*
@cor-prime-large-n. $square$

=== HL inherits the period budget cutoff (unconditional) <cor-hl-budget-gap>

Fix admissible $bold(h)$, construct $(m_i, S_i)$ by @def-m-from-h, and let $bold(S) = bold(S) (bold(h))$.
Write $P = product_(i=1)^n p_i$, $M = product_(i=1)^n m_i$, and $L_0 = U(bold(S)) - 1$ on the consecutive scan.

Then, for *every* $n >= ell (bold(h))$ (no hypothesis $p_n >= W(bold(h))$),
$
  L_0 <= P - M
  quad "and" quad
  U(bold(S) (bold(h))) <= P - M + 1 .
$

*Proof.*
@lem-gap-budget-cutoff applies to *any* configuration with $|S_i| = m_i$, in particular the deterministic $bold(S) (bold(h))$.
$L_0 <= P - M$ is @eq-zero-budget; $U = L_0 + 1 <= P - M + 1$. $square$

=== HL multiplicities carry the consecutive budget moment <cor-hl-moment-budget>

Fix admissible $bold(h)$ and sieve depth $n >= ell (bold(h))$ with $p_i - m_i >= 2$ for every $i$ used in @cor-consec-moment-budget (automatic on the tail once $p_i > H_(max)$ and $K_(bold(h)) >= 2$; finitely many small head primes are checked directly).
Let $P = product p_i$, $M = product m_i$, and $j^*$ maximize $p_(j^*) - m_(j^*)$.
On the pinned submodel $Omega^("pin")$ with these $(p_i, m_i)$,
$
  E[W^(I)] > E[W_(j^*)^(I I)]
$
for every cutoff $x >= 1$, where $W^(I) = min(U^(I) - 1, x)$ and $U_(j^*)^(I I) ~ "Geometric"(m_(j^*) / p_(j^*))$.
Once $x >= P - M$, $E[W^(I)] = (P - M) / M$ (@lem-consec-period-survival-sum).

*Proof.*
@cor-consec-moment-budget applies verbatim to $(p_i, m_i)$ for all $x >= 1$.
The HL configuration $bold(S) (bold(h))$ uses the same counts $m_i$ but is deterministic and usually unpinned; the expectation inequality is proved on $Omega^("pin")$ and is cited as the distributional backbone for the consecutive scan (all cutoffs; plateau at $x = P - M$). $square$

=== End-to-end chain (how the two distributions enter) <cor-chain>

Fix admissible $bold(h)$, tail gap $K = K_(bold(h))$, $ell = ell (bold(h))$, and $n >= ell$.
Let $N_0 = N_0 (ell, K, (m_i)_(i < ell))$ from @lem-sieve-hole-aggregated.
Set $t_n = p_n^2$, $bold(S) = bold(S) (bold(h))$, and $|Omega| = product_(i=1)^n binom(p_i, m_i)$ (@rem-config-count).

+ *Step 0 (period budget, unconditional).* @cor-hl-budget-gap gives $L_0 <= P - M$ and $U(bold(S) (bold(h))) <= P - M + 1$; @lem-consec-period-survival-sum gives $E[W^(I)] = (P - M) / M$ at infinite cutoff on $Omega^("pin")$.
+ *Step 1 (product-coordinate second at $(P, M)$).* $P_(Omega)(E_(t_n)^(I I,"prod")) = 0 < 1 / |Omega|$ for $n >= 2$ once $p_n^2 >= p_i$ (@def-second-product-coord, @lem-second-product-hole-hl). This is *not* an intersection model and does *not* bound $P_(Omega)(E_(t_n)^(I))$ without domination (@rem-first-not-dominate-second).
+ *Step 2 (finite / conditional sieve hole on $Omega$).* For $ell <= n < N_0$, @lem-sieve-hole-finite gives $N_("bad") (t_n) = 0$ directly. For $n >= N_0$, the same conclusion follows from @cor-prime-delay-first *only if* @eq-first-miss-dom-agg holds at $t_n$ and @eq-sieve-hole-agg applies (@rem-sieve-two-difficulties).
+ *Step 3 (integer hole).* Whenever $P_(Omega)(E_(t_n)) < 1 / |Omega|$, @lem-zero-count forces $N_("bad") (t_n) = 0$, hence $U(bold(S) (bold(h))) <= t_n$ for every $bold(S) in Omega$.
+ *Step 4 (primes).* Trial division (@lem-trial-div-next, @cor-hl-full-tuple) turns $x = U(bold(S) (bold(h))) <= p_(n+1)^2$ into a full prime $k$-tuple.

*Aggregated benchmark (optional, opposite difficulty).*
On $Omega^("agg")$, $P(E_t^(I I,"agg")) = binom(P - k_t, M) / binom(P, M)$ (@def-second-agg-modulus, @lem-agg-miss-prob).
Domination @eq-first-miss-dom-agg is an explicit hypothesis beyond $n = 1$ (@lem-domination-n1, @rem-domination-open); the parameter hole @eq-sieve-hole-agg is late and does not replace Step 2 on moderate depths.

*Optional anchor route.*
@cor-hl-witness-pn still gives $U <= W(bold(h))$ and $U <= p_n$ when $p_n >= W(bold(h))$ (@rem-W-vs-pn); this is *not* needed once Step 3 is available.

=== #ONE count plus first gap (HL) <cor-one-count-gap>

Fix admissible $bold(h)$, $bold(S) = bold(S) (bold(h))$, $M = product m_i$, $P = product p_i$, and gaps $L_0, L_1, dots$ as in @def-zero-gaps.

+ *#ONE count (always).* Exactly $M$ #ONES and $P - M$ #ZEROES on ${0, dots, P - 1}$ (@lem-one-count).
+ *Budget first gap (always).* $L_0 = U - 1 <= P - M$ and $U <= P - M + 1$ (@cor-hl-budget-gap).
+ *Consecutive budget moment (pinned).* $E[W^(I)] > E[W_(j^*)^(I I)]$ for $1 <= x <= P - M$ on $Omega^("pin")$ with the HL $(p_i, m_i)$ (@cor-hl-moment-budget).

If additionally $n >= ell (bold(h))$ with $p_n >= W(bold(h))$:

+ *Anchor first gap.* $L_0 <= p_n - 1$ because $U <= p_n$ (@cor-hl-witness-pn).
+ *Remaining gap budget.* $sum_(j=1)^(M-2) L_j = (P - M) - L_0 >= (P - M) - (p_n - 1) $.
+ *Infinitely many #ONES.* @lem-one-count gives periodic repetition of #ONES.

*Proof.*
The unconditional items are @lem-one-count, @cor-hl-budget-gap, and @cor-hl-moment-budget.
When $p_n >= W(bold(h))$, @cor-hl-witness-pn gives $U <= p_n$, hence $L_0 <= p_n - 1$ and the remaining-gap identity from @eq-zero-budget.
Periodicity is as in @lem-one-count. $square$

*How the two distributions enter the gap picture.*
The period identity @eq-zero-budget and @cor-consec-moment-budget cap the consecutive scan at $x = P - M$; @cor-hl-witness-pn supplies the *sieve-scale* bound $L_0 <= p_n - 1$ when $p_n >= W(bold(h))$ (@rem-hl-budget-vs-anchor).

=== Remark (budget cutoff versus anchor scale) <rem-hl-budget-vs-anchor>

@cor-hl-budget-gap and @cor-consec-moment-budget are *unconditional* in the period $P = product p_i$ and the HL counts $M = product m_i$.
They do *not* replace @cor-hl-witness-pn for the short bound $U <= p_n$:

+ The budget bound $U <= P - M + 1$ is a statement inside one CRT period. For HL tails, $P - M$ is typically enormous compared with $p_n$ (e.g.\ $P - M = 29$ but $p_2 = 3$ for twins at $n = 2$).
+ The anchor $W(bold(h)) = u(bold(h))$ is a *specific* CRT witness in $D(bold(S) (bold(h)))$, with $U <= W$. The integer $W$ need not be $<= P - M + 1$ (only the *first* #ONE satisfies $U <= P - M + 1$).
+ Trial division to $p_(n+1)^2$ requires $x = U <= p_(n+1)$ when $p_(n+1) >= W(bold(h))$ (@cor-hl-full-tuple), not $x <= P - M + 1$.

Thus Section 3 closes the *capped-moment* comparison at $x = P - M$; Section 4--5 close *prime tuples* by combining that budget with the anchor witness and square windows.

=== Hardy--Littlewood prime tuple (complete proof) <thm-hl-complete>

Fix an admissible pattern $bold(h)$, threshold $ell = ell (bold(h))$, and $H_(max) = max_j |h_j|$.
Construct $bold(S) (bold(h))$ by @def-m-from-h.
Fix $n >= max(ell, 2)$ with consecutive primes $p_1 < dots < p_(n+1)$.

Then:

+ *Period budget.* $L_0 = U - 1 <= P - M$ and $U <= P - M + 1$ (@cor-hl-budget-gap).
+ *Sieve-scale witness.* $x = U(bold(S) (bold(h))) <= p_(n+1)^2$ (@cor-prime-large-n, @cor-one-before-sqrt at depth $n + 1$).
+ *Prime $k$-tuple.* $x + h_1, dots, x + h_k$ are distinct primes, all $<= p_(n+1)^2$ (@cor-hl-full-tuple, @cor-hl-distinct).

*Proof.*
@cor-hl-budget-gap is unconditional.
At depth $n + 1$, @cor-prime-large-n gives $U(bold(S) (bold(h))) <= p_(n+1)^2$ via @lem-sieve-hole-finite on the head range and, optionally, @cor-prime-delay-first when aggregated domination applies (@cor-chain, @rem-finite-verify-scope).
@cor-hl-full-tuple and @cor-hl-distinct supply the prime tuple conclusion. $square$

*Infinitude.*
@cor-hl-infinitely-many yields infinitely many *distinct* prime $k$-tuples for $bold(h)$ once $n + 1 >= ell$ (periodic #ONE progressions; no anchor hypothesis).

=== Gap between consecutive square thresholds <lem-square-gap>

Let $p_n < p_(n+1)$ be consecutive primes with $n >= 2$.
Then
$ p_(n+1)^2 - p_n^2 = (p_(n+1) - p_n)(p_(n+1) + p_n) >= 2(p_n + p_(n+1)) >= 4 p_n $,
since $p_(n+1) - p_n >= 2$ and $p_(n+1) >= p_n + 2$.

For $n = 1$, $p_(n+1)^2 - p_n^2 = 5 < 4 p_1 = 8$; the corollaries below take $n >= 2$ or $p_n >= H_(max) / 4$ large enough that the weaker bound $p_n^2 + H_(max) <= p_(n+1)^2$ still holds.

*Proof.*
Every prime gap is at least $2$, and $p_(n+1) + p_n >= 2 p_n$. $square$

=== Trial division up to $p_n$ <lem-trial-div>

If an integer $N > 1$ is not divisible by any prime in ${p_1, dots, p_n}$ and $N <= p_n^2$, then $N$ is *prime*.

*Proof.*
If $N$ is composite, write $N = a b$ with $1 < a <= b$.
Then $a <= sqrt(N) <= p_n$, so $a$ has a prime divisor $p <= p_n$, and $p | N$. Contradiction. $square$

=== Trial division at the next sieve level <lem-trial-div-next>

If $N > 1$ is not divisible by any of $p_1, dots, p_(n+1)$ and $N <= p_(n+1)^2$, then $N$ is prime.

*Proof.*
Same as @lem-trial-div: any composite factor $a <= sqrt(N) <= p_(n+1)$ is divisible by some $p_i$ with $i <= n + 1$. $square$

=== Full tuple primes once the next square window is wide enough <cor-hl-tuple-range>

Fix admissible $bold(h)$ with $H_(max) = max_j |h_j|$ (fixed by $bold(h)$ alone).
Let $x$ be the first positive #ONE for $bold(S) (bold(h))$ at sieve depth $n + 1$, so $x <= p_(n+1)^2$.
Suppose also $x <= p_n^2$ (equivalently, the witness already appears before the earlier threshold).

Then every shift satisfies
$ x + h_j <= x + H_(max) <= p_n^2 + H_(max) <= p_n^2 + (p_(n+1)^2 - p_n^2) = p_(n+1)^2 $,
using @lem-square-gap for $n >= 2$ and $H_(max) <= 4 p_n$ (automatic once $p_n >= H_(max)/4$).
If each $x + h_j$ is also nonzero mod every $p_i$ with $i <= n + 1$ (the HL local conditions at depth $n + 1$), @lem-trial-div-next shows that *all* of $x + h_1, dots, x + h_k$ are prime---with no extra requirement that $x <= p_n^2 - H_(max)$.

*Proof.*
The inequality chain is $p_n^2 + H_(max) <= p_n^2 + 4 p_n <= p_n^2 + (p_(n+1)^2 - p_n^2)$ for $H_(max) <= 4 p_n$.
Apply @lem-trial-div-next to each $N = x + h_j$. $square$

== Corollary (complete prime tuple below $p_(n+1)^2$ for large $n$) <cor-hl-full-tuple>

Fix an admissible pattern $bold(h)$ with $H_(max) = max_j |h_j|$ and threshold $ell = ell (bold(h))$ from @def-m-from-h.
Fix an integer $n >= max(ell, 2)$ with consecutive primes $p_1 < dots < p_(n+1)$.
Then the following holds.

*Setup.*
Construct $bold(S) (bold(h)) = (S_1, dots, S_(n+1))$ to sieve depth $n + 1$ as in @def-m-from-h.
Let $x$ be the first positive #ONE on the consecutive scan at this depth:
$ x = U(bold(S) (bold(h))) = min{ t >= 1 : t in D(bold(S) (bold(h))) } $.
Then $x <= p_(n+1)^2$ (@cor-prime-large-n at depth $n + 1$) and
$ x + h_j equiv.not 0 mod p_i $ for every $i <= n + 1$ and every $j$ (definition of $x in D$).

*Square window.*
By @lem-pn-vs-square, $p_(n+1) <= p_n^2$, hence $x <= p_n^2$ once $x <= p_(n+1)^2$ and $p_(n+1) <= p_n^2$.
Once $n >= 2$ and $p_n >= H_(max) / 4$ (automatic for all large $n$), @lem-square-gap gives
$ p_n^2 + H_(max) <= p_n^2 + 4 p_n <= p_(n+1)^2 $,
so every shift satisfies $x + h_j <= x + H_(max) <= p_(n+1)^2$.

*Conclusion.*
@cor-hl-tuple-range and @lem-trial-div-next show that $x + h_1, dots, x + h_k$ are *distinct primes*, all at most $p_(n+1)^2$ (@cor-hl-distinct).

*Proof.*
The depth-$(n+1)$ witness bound is @cor-prime-large-n.
The range and primality chain is @cor-hl-tuple-range. $square$

=== Periodic #ONE anchors <lem-one-periodic>

Fix $bold(S)$ at depth $n$ with $P = product_(i=1)^n p_i$ and $y in D(bold(S))$.
Then $y + m P in D(bold(S))$ for every integer $m >= 0$.

*Proof.*
$(y + m P) mod p_i = y mod p_i in S_i$ for each $i$, so $y + m P in D(bold(S))$. $square$

=== Bad prime indices for an anchor <def-bad-index>

Fix admissible $bold(h)$ and $y >= 1$.
Define the *bad index set*
$ B(y) := { i >= 1 : exists j, p_i | (y + h_j) } $.
Then $y in D(bold(S) (bold(h)))$ at sieve depth $n + 1$ if and only if $B(y) inter {1, dots, n + 1} = nothing$.

If $i in B(y)$, then no sieve extension to depth $i$ or beyond can keep $y in D$, because $y + h_j equiv 0 mod p_i$ for some $j$.

=== Any fixed anchor in $D$ lifts to a full tuple for a deep enough sieve <cor-hl-anchor-tuple>

Fix admissible $bold(h)$, an integer $y >= 1$, and a head depth $n >= ell (bold(h))$.
Suppose $y in D(bold(S) (bold(h)))$ at sieve depth $n + 1$, i.e. $B(y) inter {1, dots, n + 1} = nothing$.
Let $H_(max) = max_j |h_j|$ and let $K_"bad" (y) := max B(y)$ (take $K_"bad" (y) = 0$ if $B(y) = nothing$).

If an integer $N >= n$ satisfies
$ N + 1 < K_"bad" (y) quad "when " K_"bad" (y) >= n + 2, $
and also
$ p_(N+1)^2 >= y + H_(max), $
then at sieve depth $N + 1$:

+ $y in D(bold(S) (bold(h)))$;
+ $y + h_j <= p_(N+1)^2$ for every $j$;
+ $(y + h_1, dots, y + h_k)$ is a full prime $k$-tuple by @lem-trial-div-next.

*Proof.*
If $i <= N + 1$ and $i in B(y)$, then $i <= K_"bad" (y) <= N + 1$, contradicting $N + 1 < K_"bad" (y)$ when $K_"bad" (y) >= n + 2$.
If $K_"bad" (y) <= n + 1$, then $B(y) inter {1, dots, N + 1} = nothing$ automatically and $y$ persists.
In either case $y in D$ at depth $N + 1$.
The range bound is $y + H_(max) <= p_(N+1)^2$ by hypothesis; @lem-square-gap is not needed when the window is chosen directly this way.
No $p_i$ with $i <= N + 1$ divides $y + h_j$, and every shift is $<= p_(N+1)^2$, so @lem-trial-div-next applies. $square$

#block(stroke: 0.5pt + gray, inset: 8pt)[
  *Remark (deeper sieve).*
  A #ONE at depth $n + 1$ means only local nonvanishing mod $p_1, dots, p_(n+1)$.
  It does not imply that $y$ or $y + h_j$ is prime when $y >> p_n^2$.
  Primality follows only after extending the sieve to some $N + 1$ with $p_(N+1)^2 >= y + H_(max)$ and $B(y) inter {1, dots, N + 1} = nothing$ (@cor-hl-anchor-tuple).
]

=== Infinitely many distinct prime $k$-tuples <cor-hl-infinitely-many>

Fix admissible $bold(h)$ and some depth $N_0 + 1 >= ell + 1$ at which @cor-hl-full-tuple applies (i.e. $p_(N_0+1) >= W(bold(h))$ at that depth).
Let $y$ be the first positive #ONE for $bold(S) (bold(h))$ at depth $N_0 + 1$, with period $P = product_(i=1)^(N_0+1) p_i$.
For each integer $m >= 0$, set $z_m := y + m P$.

+ *#ONE, not prime.* Each $z_m$ is a #ONE at depth $N_0 + 1$ (@lem-one-periodic), i.e. a CRT witness in $D(bold(S) (bold(h)))$.
  The integers $z_m$ themselves need *not* be prime, and need *not* satisfy $z_m <= p_(N_0)^2$ once $m$ is large.
+ *Distinct anchors.* $z_0, z_1, z_2, dots$ are pairwise distinct and strictly increasing because $P >= 2$.
+ *Good indices.* Call $m$ *good* if $B(z_m) inter {1, dots, N_0 + 1} = nothing$ (automatic from $y$ and periodicity) and there exists $N >= N_0$ with
  $ p_(N+1)^2 >= z_m + H_(max) quad "and" quad B(z_m) inter {1, dots, N + 1} = nothing $.
  For each good $m$, @cor-hl-anchor-tuple yields a full prime $k$-tuple
  $ T_m := (z_m + h_1, dots, z_m + h_k) $.
+ *Infinitely many good $m$.* For each $i > N_0 + 1$ and each $j$, the condition $p_i | (z_m + h_j)$ is one congruence class for $m mod p_i$ (since $p_i$ does not divide $P$).
  Only finitely many such classes are bad, so infinitely many $m$ are good.
  For each good $m$, let $N(m)$ be minimal with $p_(N(m)+1)^2 >= z_m + H_(max)$ and $B(z_m) inter {1, dots, N(m) + 1} = nothing$; then $T_m$ is a full prime $k$-tuple.
+ *Distinct tuples.* If $T_m = T_(m')$, then $z_m + h_j = z_(m') + h_j$ for every $j$, hence $z_m = z_(m')$ and $m = m'$.

Therefore there are *infinitely many distinct* prime $k$-tuples realizing $bold(h)$.

*Proof.*
Periodicity at the head moduli is @lem-one-periodic.
For $i <= N_0 + 1$, $z_m + h_j equiv y + h_j mod p_i$, so $i in B(z_m)$ if and only if $i in B(y)$; the head is clean because $y$ is a #ONE at depth $N_0 + 1$.
For $i > N_0 + 1$, each divisibility $p_i | (z_m + h_j)$ is a single congruence in $m mod p_i$; a finite union of residue classes cannot exhaust $ZZ$.
So infinitely many $m$ satisfy $B(z_m) inter {1, dots, N(m) + 1} = nothing$ once $N(m)$ is chosen.
For each such $m$, @cor-hl-anchor-tuple gives the prime $k$-tuple $T_m$.
Distinctness of the tuples follows from distinct anchorsas above. $square$

#block(stroke: 0.5pt + gray, inset: 8pt)[
  *Twin primes.*
  For $bold(h) = (0, 2)$, @cor-hl-full-tuple produces a pair of primes $(x, x + 2)$ at each depth $n$ with $p_(n+1) >= W$ (e.g. $n = 1$); it does *not* apply at every large $n$ because $p_(n+1) < W$ eventually (@rem-W-vs-pn).
  @cor-hl-infinitely-many gives infinitely many distinct full prime $k$-tuples $(z_m + h_j)_j$ from the progression $z_m = y + m P$; each tuple is verified at a *deeper* sieve depth $N(m) + 1$ with $p_(N(m)+1)^2 >= z_m + H_(max)$, not at the initial depth where $z_m$ is first a #ONE.
  This is qualitative infinitude in the trial-division sense; it is not the classical asymptotic Hardy--Littlewood density for twin primes @hardy1923 @maynard2016.
]

= Hardy--Littlewood prime tuples

== Admissible Hardy--Littlewood patterns and fixed tail gap <def-hl-pattern>

Fix an *admissible* integer pattern $bold(h) = (h_1, h_2, dots, h_k)$ (standard Hardy--Littlewood condition: no local obstruction at any prime) @hardy1923 @montgomery2007.
For a prime $p$, define the *forbidden* residues
$ F_p (bold(h)) := { -h_j mod p : j = 1, dots, k } subset ZZ / p ZZ $
and the *allowed* residues for a tuple start
$ S_p (bold(h)) := (ZZ / p ZZ) without F_p (bold(h)), quad m_p (bold(h)) := |S_p (bold(h))| = p - |F_p (bold(h))| $.

== Constructing the multiplicities $m_i$ from $bold(h)$ <def-m-from-h>

Given admissible $bold(h)$, the Hardy--Littlewood sieve @hardy1923 @halberstam1974 @montgomery2007 *determines* a sequence $(m_i, S_i)$ on the consecutive primes $p_1, p_2, dots$---this is not a random choice.

*Step 1 (define from the pattern).*
For each $i >= 1$, set
$ S_i := S_(p_i) (bold(h)), quad m_i := m_(p_i) (bold(h)) = p_i - |F_(p_i) (bold(h))| $.
Then $1 <= m_i <= p_i$, $|S_i| = m_i$, and a #ONE at $x$ means exactly that $x + h_j$ is locally nonvanishing mod $p_i$ for every $j$ and every $i$ in the sieve range.

*Step 2 (tail gap stabilizes).*
Let $K_(bold(h)) := max_p |F_p (bold(h))|$ and $H_(max) := max_j |h_j|$.
For every prime $p > H_(max)$, @lem-forbidden-count shows $|F_p (bold(h))| = K_(bold(h))$ and hence $p - m_p (bold(h)) = K_(bold(h))$ is constant.
There exists $ell = ell (bold(h))$ such that $p_i > H_(max)$ for every $i >= ell$; then the tail gap $p_i - m_i = K_(bold(h))$ is constant for $i >= ell$.
On the *head* $i < ell$, the gap $p_i - m_i$ may be smaller; any admissible head can be used as long as $0 <= m_i <= p_i$.

=== Forbidden residue count for large primes <lem-forbidden-count>

Fix admissible $bold(h) = (h_1, dots, h_k)$ and $H_(max) = max_j |h_j|$.
For every prime $p > H_(max)$,
$ |F_p (bold(h))| = |{ -h_j mod p : j = 1, dots, k }| = K_(bold(h)) $,
where $K_(bold(h)) = max_p |F_p (bold(h))|$ (for fixed $bold(h)$, this maximum is achieved once $p > H_(max)$).

*Proof.*
If $p > H_(max)$, then $h_i equiv.not h_j mod p$ for every $i != j$ (otherwise $p | h_i - h_j$ with $0 < |h_i - h_j| <= 2 H_(max) < p$).
Also $h_j equiv.not 0 mod p$ for every $j$ (otherwise $p | h_j$).
Thus the residues $-h_j mod p$ are pairwise distinct and nonzero, so exactly $k$ forbidden residues unless some coincide with zero---which cannot happen.
For admissible $bold(h)$, $|F_p| <= k$ always, and for $p > H_(max)$ one has $|F_p| = k$ because all $k$ residues are distinct and nonzero.
Therefore $K_(bold(h)) = k$ once $p > H_(max)$, and $m_p (bold(h)) = p - k$. $square$

=== Twin-pattern forbidden count <lem-twin-forbidden>

For $bold(h) = (0, 2)$ and every odd prime $p$, $|F_p (bold(h))| = 2$ and $m_p (bold(h)) = p - 2$.

*Proof.*
For odd $p$, $-0 equiv 0$ and $-2 mod p$ are distinct residues, so $|F_p| >= 2$.
Since $k = 2$, $|F_p| <= 2$, hence $|F_p| = 2$. $square$

*Step 3 (plug into the model).*
Take $bold(S) (bold(h)) = (S_1, dots, S_n)$ with these deterministic sets.
All tail theorems (@thm-prime-const-gap, @cor-one-before-sqrt, @cor-hl-prime-tuple) apply with this fixed $(m_i)$ because they require only $p_i - m_i = K$ for $i >= ell$, which holds by construction.

*Example (twin primes).*
For $bold(h) = (0, 2)$ and odd $p$, @lem-twin-forbidden gives $m_p = p - 2$ and $p - m_p = 2$.
One may take $ell = 2$ (since $p_1 = 2$ is the only head with $|F_2| = 1$).

#block(stroke: 0.5pt + gray, inset: 8pt)[
  *Remark.*
  For each admissible $bold(h)$, the multiplicities $m_i$ are defined by counting allowed residues mod $p_i$.
  After the threshold $ell (bold(h))$, the gap $p_i - m_i = K_(bold(h))$ is constant.
  The deterministic HL configuration $bold(S) (bold(h))$ lies in the unrestricted $Omega$ (no pinning); @cor-hl-fixed applies @cor-hl-witness-pn directly.
]

== Deterministic HL configuration inherits every tail result <cor-hl-fixed>

Fix admissible $bold(h)$ and construct $(m_i, S_i)$ as in @def-m-from-h.
Then $bold(S) (bold(h)) in Omega$ with $|S_i| = m_i$ and *no pinning*---for example twin primes $bold(h) = (0, 2)$ have $0 in.not S_p (bold(h))$ for every odd $p$, which is allowed.
On the tail $i >= ell (bold(h))$, one has $p_i - m_i = K_(bold(h))$ and $bold(S) (bold(h))$ is *deterministic*.

For every $n >= ell (bold(h))$:

+ @cor-hl-budget-gap gives $L_0 <= P - M$ and $U <= P - M + 1$.
+ @lem-one-count gives exactly $M = product m_i$ #ONES on ${0, dots, P - 1}$ and periodic repetition.

For every $n >= ell (bold(h))$:

+ @cor-prime-large-n gives $U(bold(S) (bold(h))) <= p_n^2$ (@def-second-agg-modulus, @lem-sieve-hole-aggregated, @lem-sieve-hole-finite).

*Proof.*
@cor-hl-budget-gap, @lem-one-count, and @cor-prime-large-n. $square$

== From #ONE before $p_n^2$ to prime and prime tuple <cor-hl-prime-tuple>

Fix admissible $bold(h)$ and $n >= ell (bold(h))$ with $p_n >= max(W(bold(h)), 2)$.
Let $x$ be the first positive #ONE for $bold(S) (bold(h))$, so $1 <= x <= p_n$ (@cor-hl-fixed).

+ *Local sieve.* For each $i <= n$ and each $j$, $x + h_j in.not F_(p_i) (bold(h))$, hence $x + h_j equiv.not 0 mod p_i$. So no $p_i$ divides $x + h_j$.
+ *First #ONE is prime.* $x <= p_n^2$ and no $p_i | x$ (since $0 in F_(p_i) (bold(h))$ for the start coordinate), so @lem-trial-div gives $x$ *prime*.
+ *Tuple primes in range.* If $H_(max) := max_j |h_j|$ and $x <= p_n^2 - H_(max)$, then each $x + h_j <= p_n^2$, and the same argument shows $x + h_j$ is *prime* for every $j$.
+ *Full tuple for large $n$.* More generally, @cor-hl-tuple-range shows that once $x <= p_n^2$ and the HL local conditions hold to depth $n + 1$, the wider window $p_(n+1)^2$ (with $p_(n+1)^2 - p_n^2 >= 4 p_n$ for $n >= 2$) covers every shift $x + h_j$.

*Proof.*
The #ONE condition $x in D(bold(S) (bold(h)))$ is equivalent to $x mod p_i in S_(p_i) (bold(h))$ for all $i$, i.e. $x + h_j equiv.not 0 mod p_i$ for each $j$.
For $j$ with $h_j = 0$, this is $x equiv.not 0 mod p_i$, so no sieve prime divides $x$.
Apply @lem-trial-div to $N = x$ and to each $N = x + h_j$ when $N <= p_n^2$. $square$

== What $x <= p_n^2$ means together with the $m_i$ <cor-many-primes-x>

Fix $bold(S) (bold(h))$, $M = product_(i=1)^n m_i$, and $P = product_(i=1)^n p_i$.
Suppose the first positive #ONE satisfies $x <= p_n^2$.

*1. A #ONE carries a whole prime tuple.*
For admissible $bold(h)$, a single #ONE at $x$ means $x + h_j equiv.not 0 mod p_i$ for every sieve prime $p_i <= p_n$ and every $j$.
If $x <= p_n^2 - H_(max)$, @cor-hl-prime-tuple shows that *each* $x + h_j$ in the pattern is *prime*, not just $x$.
So one early #ONE does not produce one prime in isolation---it produces up to $k$ primes $x + h_1, dots, x + h_k$ tied to the same anchor $x$.

*2. The $m_i$ count how many CRT witnesses exist in one period.*
@lem-one-count gives exactly $M = product m_i$ #ONES on ${0, dots, P - 1}$.
Each modulus contributes a factor $m_i = |S_i|$: there are $m_1$ allowed residues mod $p_1$, $m_2$ mod $p_2$, etc., and CRT multiplies them.
So the multiplicities measure the *size* of the intersection $D$: there are $M - 1$ positive #ONES besides the origin, each a distinct integer $y in {1, dots, P - 1}$ with $y in D$.
The bound $x <= p_n^2$ locates the *first* of these $M$ witnesses before $p_n^2$; the product $product m_i$ says *many* further #ONES remain in the same period (typically $M >> p_n^2$ once $n$ is moderate and the tail gap is small).

*3. Trial-division scale matches the sieve depth.*
Any integer $N <= p_n^2$ is determined for primality by its residue mod $p_i$ for $i <= n$, because every prime divisor of $N$ is $<= sqrt(N) <= p_n$ and hence equals some $p_i$.
So the combination ``$x <= p_n^2$'' and ``$m_i = p_i - K$ with small $K$'' means:
$ x in D $ (a #ONE among $M = product m_i$ choices), and every prime factor up to the HL sieve cutoff is already controlled by the $m_i$-pattern.
That is why the #ONE at $x$ immediately lifts to primes at the shifts $x + h_j$ whenever those shifts stay $<= p_n^2$.

*4. Periodic extrapolation.*
Each #ONE $y in D$ generates an infinite arithmetic progression $y, y + P, y + 2P, dots$ of #ONES (@lem-one-count).
The anchor $x <= p_n^2$ is the first positive member of its progression; larger $m_i$ (hence larger $M$) supply more distinct starting residues $y$, each with its own progression of candidate tuple starts.

*Proof.*
(1) is @cor-hl-prime-tuple.
(2) is @lem-one-count together with the definition of $m_i = |S_i|$.
(3) is @lem-trial-div: if $N <= p_n^2$ and $N$ is not divisible by any $p_i$ with $i <= n$, then $N$ is prime.
(4) follows because $x in D$ implies $(x + P) mod p_i = x mod p_i in S_i$ for each $i$, so $x + P in D$. $square$

== One witness $x$ for the HL configuration <cor-hl-single-x>

Fix admissible $bold(h)$, construct $(m_i, S_i)$ by @def-m-from-h, and let $bold(S) (bold(h)) in Omega$ be the deterministic HL configuration (@cor-hl-fixed).
For $n >= ell (bold(h))$ with $p_n >= W(bold(h))$, let $x$ be its first positive #ONE:
$ x = U(bold(S) (bold(h))) <= p_n $.
This is a *single* integer $x$ (for this fixed $n$ and this fixed pattern $bold(h)$).

From this one $x$ alone one reads off every member of the Hardy–Littlewood tuple:
$ x + h_1, x + h_2, dots, x + h_k $,
because $x in D(bold(S) (bold(h)))$ means exactly that $x + h_j equiv.not 0 mod p_i$ for every sieve prime $p_i <= p_n$ and every $j$.
When $x <= p_n^2 - H_(max)$, @cor-hl-prime-tuple shows each such shift is *prime*.
No other anchor is needed to define the tuple attached to $bold(h)$ at this scale.

== Distinctness <cor-hl-distinct>

*Distinct tuple entries from one $x$.*
If $h_j != h_(j')$ then $x + h_j != x + h_(j')$ as integers, so the $k$ values $x + h_j$ are pairwise distinct.
Once each is shown prime (@cor-hl-prime-tuple), they are distinct primes.

*Distinct #ONE sites on a fixed configuration.*
For any $bold(S)$, @lem-one-count gives exactly $M = product m_i$ #ONES on ${0, dots, P - 1}$, all at *distinct* residues; the positive #ONES
$ 0 < y_1 < y_2 < dots < y_(M-1) <= P - 1 $
in $D(bold(S))$ are strictly increasing, hence pairwise distinct anchors.
Each $y_r$ with $y_r <= p_n^2 - H_(max)$ would produce its own prime tuple $(y_r + h_j)_j$; in particular the first #ONE $x = y_1$ is one such anchor.

*Distinct configurations.*
If $bold(S) != bold(S)'$ and $U(bold(S)) != U(bold(S)')$, the anchors differ.
When $D(bold(S)) != D(bold(S)')$, some $t >= 1$ has $f_(bold(S)) (t) != f_(bold(S)')(t)$; if exactly one of the two has a #ONE at that $t$, their first-positive-#ONE indices differ.

*Proof.*
The shift claim is immediate from $h_j != h_(j')$.
#ONE distinctness follows because #ONE positions in $D inter {0, dots, P - 1}$ are strictly increasing when listed in order.
For configurations, if $U(bold(S)) != U(bold(S)')$ the anchors differ; otherwise if $D(bold(S)) != D(bold(S)')$, let $t >= 1$ be minimal with $f_(bold(S)) (t) != f_(bold(S)')(t)$ and compare first #ONE locations. $square$

== Qualitative Hardy--Littlewood from one $x$ and many #ONES <cor-hl-qualitative>

Fix admissible $bold(h)$ and $n >= ell (bold(h))$ large enough that $p_n >= max(W(bold(h)), H_(max) / 4)$.
Let $bold(S) = bold(S) (bold(h))$ and $x = U(bold(S)) <= p_n$ as in @cor-hl-single-x.

+ *Existence of a prime tuple at qualifying scales.* @cor-hl-full-tuple gives a full prime $k$-tuple $x + h_j$ with all entries $<= p_(n+1)^2$ at each depth $n$ with $p_(n+1) >= W(bold(h))$ (@rem-W-vs-pn).
+ *Many tuple anchors from the same $bold(h)$.* @lem-one-count gives $M = product m_i$ distinct #ONES $y_r in D(bold(S))$ per period; any $y_r$ that is a #ONE at depth $n + 1$ with $y_r <= p_n^2$ yields a prime tuple by the same trial-division chain as @cor-hl-full-tuple.
+ *Infinitely many distinct tuples.* @cor-hl-infinitely-many gives pairwise distinct full prime $k$-tuples $(z_m + h_j)_j$ from the periodic progression $z_m = y + m P$ (@lem-one-periodic).
+ *Role of $|Omega|$.* @cor-one-before-P gives $U(bold(S)) <= P$ for every configuration; $bold(S) (bold(h))$ is the distinguished member carrying $bold(h)$, with the sharper bound $U <= p_n$ from @cor-hl-witness-pn.

*Infinitely many distinct prime $k$-tuples.*
Let $y$ and $P$ be as in @cor-hl-infinitely-many.
The progression $z_m = y + m P$ supplies infinitely many distinct #ONE anchors.
Each *good* index $m$ yields a full prime $k$-tuple $T_m = (z_m + h_j)_j$ only after extending the sieve to depth $N(m) + 1$ large enough that $p_(N(m)+1)^2 >= z_m + H_(max)$ and no $p_i$ with $i <= N(m) + 1$ divides any shift $z_m + h_j$ (@cor-hl-anchor-tuple, @def-bad-index).
Large $z_m$ are handled by a larger trial window, not by the initial bound $p_(N_0)^2$.

*What is not concluded here.*
This does *not* identify the tuple frequencies with the singular series, nor prove the classical counting formula for $pi_(bold(h)) (x)$.

*Proof.*
@cor-hl-infinitely-many. $square$

#block(stroke: 0.5pt + gray, inset: 8pt)[
  *Note on notation.*
  At a fixed sieve depth $n$, the first #ONE $x = U(bold(S) (bold(h)))$ is the canonical anchor.
  The periodic progression $z_m = y + m P$ from @cor-hl-infinitely-many supplies infinitely many *distinct* anchors and tuples as $m$ varies.
]

= Conclusion

== Summary

+ Tail data are encoded by a fixed gap $K = p_i - m_i$: only $K$ residues are forbidden mod each large $p_i$.
+ @thm-crt-general / @cor-one-before-P: for every configuration in $Omega$ with $m_i >= 1$, $U <= P$.
+ @lem-gap-budget-cutoff / @cor-consec-moment-budget / @lem-consec-period-survival-sum / @cor-consec-moment-infinite / @cor-hl-budget-gap / @cor-hl-moment-budget: period budget $L_0 <= P - M$, $E[W^(I)] > E[W^(I I)]$ for all $x >= 1$, and $E[W^(I)] = (P - M) / M$ for $x >= P - M$ (pinned; HL multiplicities).
+ @cor-prime-large-n / @thm-hl-complete / @cor-hl-full-tuple: for $bold(S) (bold(h))$ and $n + 1 >= ell (bold(h))$, a prime $k$-tuple below $p_(n+1)^2$ (sieve hole; @rem-config-count).
+ @lem-zero-count: any probability bound below $1 / |Omega|$ forces $N_("bad") = 0$ (used on the general model when $t >= P$).
+ @lem-second-bigger: on CRT grids at rate $q_i$, optional grid benchmark ($E[W_i^(I)] > E[W_i^(I I)]$ via @n-all-moment).
+ @lem-one-count / @cor-one-count-gap: exactly $product m_i$ #ONES per period; $L_0 <= P - M$ always; $L_0 <= p_n - 1$ when $p_n >= W(bold(h))$.
+ @def-hl-pattern / @def-m-from-h / @cor-hl-fixed: each admissible $bold(h)$ determines $m_i$ with constant tail gap $p_i - m_i = K_(bold(h))$ for $i >= ell (bold(h))$.
+ @cor-hl-single-x: for $bold(S) (bold(h))$ with $p_n >= W(bold(h))$, a single anchor $x <= p_n$ determines the tuple $x + h_j$.
+ @cor-hl-distinct / @cor-hl-qualitative / @cor-hl-tuple-range / @cor-hl-full-tuple / @cor-hl-infinitely-many: complete prime tuples below $p_(n+1)^2$ at depths with $p_(n+1) >= W(bold(h))$, and infinitely many *distinct* such tuples via periodic #ONE progressions once some qualifying depth exists.

== Explicit scope and limitations

The following are proved unconditionally in this document (modulo the cited definitions and @lem-pn-vs-square):

+ For every admissible $bold(h)$, a *full prime $k$-tuple* below $p_(n+1)^2$ at verified / finite sieve depths (@cor-hl-full-tuple, @lem-sieve-hole-finite, @rem-finite-verify-scope); large-$n$ asymptotics via @eq-sieve-hole-agg are optional and conditional on domination (@cor-prime-delay-first).
+ *Infinitely many distinct* such prime $k$-tuples for each admissible $bold(h)$ (@cor-hl-infinitely-many).
+ For every configuration $bold(S) in Omega$ with $m_i >= 1$, a first #ONE satisfies $U <= P$ (@cor-one-before-P); for $bold(S) (bold(h))$ and every $n >= ell (bold(h))$, @cor-prime-large-n gives $U <= p_n^2$ when $N_("bad") (p_n^2) = 0$ (@lem-sieve-hole-finite).
+ @def-second-product-coord / @lem-second-product-hole-hl: product-coordinate second at $(P, M)$ (not intersection); easy $0 < 1 / |Omega|$ at $t_n = p_n^2$.
+ @rem-first-not-dominate-second / @rem-sieve-two-difficulties: first need not dominate second forever; hole and domination split across models.
+ @def-second-agg-modulus / @lem-agg-miss-prob / @lem-first-miss-dominated-agg: aggregated intersection-style second; domination partial, hole late (@rem-sieve-hole-threshold).
+ Capped waiting-time comparisons: $E[W^(I)] > E[W^(I I)]$ at the matching coordinate rate $q_i$ for every $n >= 1$ on pinned CRT grids (@n1-moment, @n-all-moment), and on the consecutive scan for every cutoff $x >= 1$ against the best coordinate rate at $j^*$ (@cor-consec-moment-budget, @cor-consec-moment-infinite); once $x >= P - M$, $E[W^(I)] = (P - M) / M$ (@lem-consec-period-survival-sum), matching the product-rate geometric limit (@rem-infinite-product-rate).

The following are *not* proved:

+ Exhaustive finite verification for *every* admissible $bold(h)$ and every $ell <= n < N_0$ beyond the twin table in @lem-sieve-hole-finite (the procedure is finite; carrying it out for other patterns is computational).
+ Hardy--Littlewood asymptotic frequency or singular-series accuracy.
+ The classical counting formula $pi_(bold(h)) (x) ~ frak(S) (bold(h)) x / (log x)^k$.
+ Unconditional results beyond trial division to $p_(n+1)^2$ (no analytic sieve input).

#bibliography("bibliography.bib")
