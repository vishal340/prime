=== Consecutive survival is non-increasing <lem-consec-survival>

For the consecutive-scan first #ONE $U^(I) = min{ t >= 1 : t in D }$ and any $t >= 1$,
$ {U^(I) > t + 1} subset {U^(I) > t} $, hence $P(U^(I) > t + 1) <= P(U^(I) > t)$.

*Proof.*
${U^(I) > t + 1}$ means ${1, dots, t + 1} inter D = nothing}$, which implies ${1, dots, t} inter D = nothing}$, i.e.\ $U^(I) > t$. $square$

=== Early consecutive tails (comparison range) <lem-consec-comparison-tail>

Fix $n >= 1$, $m_i >= 2$, pairwise coprime $p_i$, and $j in {1, dots, n}$.
On $Omega^("pin")$, for each $1 <= t <= p_j - m_j$,
$ P(U^(I) > t) > (1 - q_j)^t $.
This is @lem-consec-pinned-tail; recorded here for the split at $T = p_(j^*) - m_(j^*)$. $square$

=== Remark (late-$t$ termwise comparison can fail) <rem-late-termwise-fail>

Let $j^*$ maximize $p_(j^*) - m_(j^*)$, $T := p_(j^*) - m_(j^*)$, and $q_(j^*) := m_(j^*) / p_(j^*)$.
@lem-consec-pinned-tail gives $P(U^(I) > t) > (1 - q_(j^*))^t$ for $1 <= t <= T$.
For $t > T$, @lem-consec-survival gives $P(U^(I) > t) <= P(U^(I) > T)$, not $>=$: longer prefixes are *harder* to avoid entirely.
So one cannot extend the termwise inequality to every $t <= P - M$ by monotonicity alone.
Example $(p_1, m_1) = (5, 3)$, $(p_2, m_2) = (7, 2)$: $T = 5$, $P - M = 29$, and $P(U^(I) > 20) = 0 < (1 - q_(j^*))^20$ while $E[W^(I)] > E[W_(j^*)^(I I)]$ still holds at $x = P - M$.

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

Fix $n >= 1$, pairwise coprime $p_i$, $m_i >= 2$, and $j^* in {1, dots, n}$.
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

Fix $n >= 2$, $m_i >= 2$, $P = product p_i$, $M = product m_i$, and $T := max_j (p_j - m_j)$.
Then $P - M > T$.

*Proof.*
Each factor $p_j - m_j >= 1$, and for $n >= 2$ at least two moduli contribute, so
$
  P - M = sum_(j=1)^n (product_(i != j) p_i)(p_j - m_j) >= p_(j^*) - m_(j^*) + (n - 1) = T + (n - 1) > T .
$ $square$

=== Head sum dominates the late geometric tail <lem-consec-head-beats-tail>

Fix $n >= 2$, $m_i >= 2$, pairwise coprime $p_i$, $P = product p_i$, $M = product m_i$, and $j^*$ with
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

Fix $n >= 2$, pairwise coprime $p_i$, $m_i >= 2$, $P = product p_i$, $M = product m_i$, and a cutoff $x >= 1$.
On $Omega^("pin")$, let $U^(I)$ be the consecutive-scan first #ONE and $W^(I) = min(U^(I) - 1, x)$.
For each $j in {1, dots, n}$, let $U_j^(I I) ~ "Geometric"(q_j)$ with $q_j = m_j / p_j$ and $W_j^(I I) = min(U_j^(I I) - 1, x)$.

+ *Comparison cutoff.* If $1 <= x <= p_j - m_j$, then
  $ E[W^(I)] > E[W_j^(I I)] $
  by @lem-capped-moment and @lem-consec-pinned-tail (termwise $P(U^(I) > t) > P(U_j^(I I) > t)$).

+ *Budget cutoff.* If $1 <= x <= P - M$, then $L_0 = U^(I) - 1 <= P - M$ (@lem-gap-budget-cutoff).
  Choose $j^*$ with $p_(j^*) - m_(j^*) = max_j (p_j - m_j)$.
  @cor-consec-moment-budget gives $E[W^(I)] > E[W_(j^*)^(I I)]$ (@lem-consec-head-beats-tail; @rem-late-termwise-fail).

*Coprime progression input.*
When coordinate $j$ is not in the pinned block ${1, dots, k}$, @lem-consec-coprime-prog explains how information on the line scan $1, 2, dots$ is transported along $p_j, 2p_j, dots$ while the other moduli (already pinned) cycle through all residue classes.

*Contrast with the grid.*
On a CRT *grid*, unpinned empty runs are *longer* than pinned (@lem-pin-shrink-grid), so the telescoping inequality reverses ($E[W^("un")] >= E[W^("pin")]$ there).
The consecutive line uses the opposite monotonicity (@lem-pin-grow-consec).

=== Corollary (budget cutoff with best comparison coordinate) <cor-consec-moment-budget>

Fix $n >= 2$, $m_i >= 2$, pairwise coprime $p_i$, $P = product p_i$, $M = product m_i$, and choose $j^*$ with
$ p_(j^*) - m_(j^*) = max_j (p_j - m_j) $.
Let $U^(I)$ be the consecutive-scan first #ONE on $Omega^("pin")$, $W^(I) = min(U^(I) - 1, x)$, and $W_(j^*)^(I I) = min(U_(j^*)^(I I) - 1, x)$ for $U_(j^*)^(I I) ~ "Geometric"(q_(j^*))$ with $q_(j^*) = m_(j^*) / p_(j^*)$.

For every $1 <= x <= P - M$,
$ E[W^(I)] > E[W_(j^*)^(I I)] $.

*Proof.*
Write $T := p_(j^*) - m_(j^*)$.
By @lem-capped-moment and @lem-geom-survival,
$
  E[W^(I)] - E[W_(j^*)^(I I)]
  = sum_(t=1)^x ( P(U^(I) > t) - (1 - q_(j^*))^t ).
$
Split at $T$.
For $1 <= t <= T$, @lem-consec-comparison-tail gives each summand $> 0$.
For $T < t <= x$, @rem-late-termwise-fail shows individual terms may be negative; only the *sums* matter.
@lem-consec-budget-gt-T gives $P - M > T$, so $x > T$ is possible.
If $x <= T$, the first block alone yields the strict inequality.
If $x > T$, @lem-consec-head-beats-tail gives
$
  sum_(t=1)^T ( P(U^(I) > t) - (1 - q_(j^*))^t )
  > sum_(t = T + 1)^x (1 - q_(j^*))^t
$,
and adding $sum_(t = T + 1)^x P(U^(I) > t) >= 0$ gives
$ E[W^(I)] - E[W_(j^*)^(I I)] > 0 $. $square$
