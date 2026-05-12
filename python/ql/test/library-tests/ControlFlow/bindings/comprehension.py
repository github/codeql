# Comprehension and `for` loop targets — wired in the new CFG.

# Bare-name `for` target.
for i in range(3):  # $ cfgdefines=i
    pass

# Compound `for` target.
for k, v in [(1, 2)]:  # $ cfgdefines=k cfgdefines=v
    pass

# Comprehension targets.
_ = [x for x in range(3)]  # $ cfgdefines=_ cfgdefines=x
_ = {y: z for y, z in []}  # $ cfgdefines=_ cfgdefines=y cfgdefines=z
_ = (a for a in [])  # $ cfgdefines=_ cfgdefines=a

# Nested comprehensions.
_ = [b for c in [] for b in c]  # $ cfgdefines=_ cfgdefines=c cfgdefines=b

