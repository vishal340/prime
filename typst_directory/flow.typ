#set math.equation(numbering: "(1)")
== Distribution of Random Residue Classes

For a fixed pair of natural numbers $(p, m)$ where $m < p$:

1. *The Sample Space* $Omega$: The set of all subsets of $ZZ/p ZZ$ with exactly $m$ elements.
   $ |Omega| = binom(p, m) $

2. *The Random Variable* $S$: A random subset $s subset {0, 1, dots, p-1}$ such that $|s| = m$.
   Assuming a uniform distribution, the probability of selecting any specific subset $s$ is:
   $ P(S = s) = 1 / binom(p, m) $

---

== The Joint Distribution

Given $n$ pairs $(p_i, m_i)$ for $i = 1, dots, n$, we define the joint random variable $bold(S) = (S_1, S_2, dots, S_n)$.

=== 1. Joint Probability Mass Function
Assuming the selection of residues for each modulus $p_i$ is independent, the joint probability of observing a specific sequence of subsets $(s_1, s_2, dots, s_n)$ is the product of their individual probabilities:

$ P(bold(S) = (s_1, s_2, dots, s_n)) = product_(i=1)^n P(S_i = s_i) = product_(i=1)^n 1 / binom(p_i, m_i) $

=== 2. The Intersection Variable (CRT Property)
Let $X$ be an integer chosen uniformly from $\{0, 1, dots, (product p_i) - 1\}$. 
The "intersection" of these distributions defines the event where $X$ falls into the chosen residue classes for all $i$ simultaneously @crt:

$ D = { x : x equiv s_i mod p_i quad forall i in {1, dots, n} } $ <crt>

If all $p_i$ are pairwise coprime, the probability that a random $x$ satisfies this joint condition is:

$ P(x in D) = product_(i=1)^n m_i / p_i $





== Capped Mean Distance for Binomial Success

Let $X$ be the number of trials until the first success in a sequence of Bernoulli trials with probability $p$. 
$ X ~ "Geometric"(p) \
P(X = k) = (1-p)^(k-1) p, quad k = 1, 2, dots $

We define the **capped distance** $W$ such that any success occurring after distance $y$ is treated as $y$ @capped_distance:
$ W = min(X, y) $ <capped_distance>

=== Derivation of $E[W]$

Using the survival function property for discrete random variables, $E[W] = sum_(k=1)^y P(X >= k)$. 
The probability of k consecutive failures :
$ P(X >= k) = (1-p)^k $

Substituting this into the summation:
$ E[W] = sum_(k=1)^y (1-p)^k $

$ E[W] = (1 - (1-p)^y) (1-p)/ p $