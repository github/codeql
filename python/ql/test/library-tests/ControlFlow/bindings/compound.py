# Compound (tuple/list) assignment targets — actually wired in the new CFG.

a, b = (1, 2)  # $ cfgdefines=a cfgdefines=b
[c, d] = [3, 4]  # $ cfgdefines=c cfgdefines=d

# Nested unpacking.
(e, (f, g)) = (1, (2, 3))  # $ cfgdefines=e cfgdefines=f cfgdefines=g

# Star unpacking.
h, *i = [1, 2, 3]  # $ cfgdefines=h cfgdefines=i

# Chained assignment with compound target.
j = k, l = (5, 6)  # $ cfgdefines=j cfgdefines=k cfgdefines=l

