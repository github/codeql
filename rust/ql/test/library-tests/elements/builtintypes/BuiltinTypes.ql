import rust
import codeql.rust.frameworks.stdlib.Builtins
import codeql.rust.internal.Type

string describe(BuiltinType t) {
  (t instanceof NumericType and result = "NumericType")
  or
  (t instanceof IntegralType and result = "IntegralType")
  or
  (t instanceof FloatingPointType and result = "FloatingPointType")
}

from BuiltinType t
select t.toString(), concat(describe(t), ", ")
