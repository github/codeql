# Walrus and starred-target edge cases — wired in the new CFG.

# Walrus in expression context.
if (y := 5) > 0:  # $ cfgdefines=y
    pass

# Walrus in a comprehension. The comprehension introduces a synthetic
# `.0` parameter bound to the iterable.
_ = [w for _ in range(3) if (w := 1)]  # $ cfgdefines=_ cfgdefines=w cfgdefines=.0

# Starred target in a Tuple LHS.
*head, tail = [1, 2, 3]  # $ cfgdefines=head cfgdefines=tail


