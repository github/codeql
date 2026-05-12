# `with cm() as x:` bindings — wired in the new CFG.

class CM:  # $ cfgdefines=CM
    def __enter__(self): return self  # $ cfgdefines=__enter__
    def __exit__(self, *a): pass  # $ cfgdefines=__exit__

with CM() as x:  # $ cfgdefines=x
    pass

# Multiple items.
with CM() as a, CM() as b:  # $ cfgdefines=a cfgdefines=b
    pass

# Parenthesised form (Python 3.10+).
with (CM() as p, CM() as q):  # $ cfgdefines=p cfgdefines=q
    pass

# Compound target in `with`.
with CM() as (m, n):  # $ cfgdefines=m cfgdefines=n
    pass

