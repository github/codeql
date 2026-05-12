# Annotated assignment (PEP 526). Both with and without an initializer.

a: int = 1  # $ MISSING: cfgdefines=a
b: str = "hi"  # $ MISSING: cfgdefines=b

# Annotation without value: the AST records `c` as defined,
# but currently the new CFG has no node for it.
c: int  # $ MISSING: cfgdefines=c

class K:  # $ cfgdefines=K
    field: int = 0  # $ MISSING: cfgdefines=field

