# Annotated assignment (PEP 526). Both with and without an initializer.

a: int = 1  # $ cfgdefines=a
b: str = "hi"  # $ cfgdefines=b

# Annotation without value: the AST records `c` as defined,
# and the new CFG now visits it via the AnnAssignStmt wrapper.
c: int  # $ cfgdefines=c

class K:  # $ cfgdefines=K
    field: int = 0  # $ cfgdefines=field


