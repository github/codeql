type T[T1, T2: E1, *T3, **T4] = T5

def f[T6, T7: E2, *T8, **T9](): ...

class C[T10, T11: E3, *T12, **T13]: ...

# From PEP-696 (https://peps.python.org/pep-0696/#grammar-changes):

# TypeVars
class Foo1[T14 = str]: ...

# ParamSpecs
class Baz1[**P1 = [int, str]]: ...

# TypeVarTuples
class Qux1[*Ts1 = *tuple[int, bool]]: ...

# TypeAliases
type Foo2[T15, U1 = str] = Bar1[T15, U1]
type Baz2[**P2 = [int, str]] = Spam[**P2]
type Qux2[*Ts2 = *tuple[str]] = Ham[*Ts2]
type Rab[U2, T15 = str] = Bar2[T15, U2]
