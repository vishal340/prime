# Example inputs

Sample configurations for smoke tests and quick experiments.

## `calc1_twin.txt`

Two test cases for `calc1`:

1. Twin-prime tail moduli: \((5,3)\) and \((7,5)\) — here \(m_i = p_i - 2\).
2. Small head: \((2,1)\), \((3,1)\), \((5,3)\).

```bash
make calc1
./calc1 examples/calc1_twin.txt /tmp/out.txt
```

## `consecutive_zeros.txt`

Single case with moduli \((5,3)\) and \((7,5)\) for maximum consecutive ZERO prefix analysis.

```bash
make consecutive_zeros
./consecutive_zeros examples/consecutive_zeros.txt /tmp/out.txt
```

## `induction_on_n.txt`

Configuration enumeration for \((3,2)\) and \((5,3)\).

```bash
make induction_on_n
./induction_on_n examples/induction_on_n.txt /tmp/out.txt
```
