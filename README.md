# CRT intersection / Hardy–Littlewood experiments

C++ code for [`proof.typ`](proof.typ). Compile the paper with `make proof`.

Two models on the same residue data: CRT intersection (**ONE**/**ZERO**) vs independent geometric trials at rate \(m_i/p_i\).

```bash
make research    # builds to bin/
make proof
```

Config file format (most tools):

```
<number_of_cases>
<number_of_moduli>
<prime> <multiplicity>
...
```

Examples in `examples/`.
