/**
 * Classes to represent barriers commonly used in dataflow and taint tracking
 * configurations.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.internal.TypeInference as TypeInference
private import codeql.rust.internal.Type
private import codeql.rust.frameworks.stdlib.Builtins as Builtins

/**
 * A node whose type is a numeric or boolean type, which may be an appropriate
 * taint flow barrier for some queries.
 */
class NumericTypeBarrier extends DataFlow::Node {
  NumericTypeBarrier() {
    exists(StructType t, Struct s |
      t = TypeInference::inferType(this.asExpr()) and
      s = t.getStruct()
    |
      s instanceof Builtins::NumericType or
      s instanceof Builtins::Bool
    )
  }
}

/**
 * A node whose type is an integral (integer) or boolean type, which may be an
 * appropriate taint flow barrier for some queries.
 */
class IntegralOrBooleanTypeBarrier extends DataFlow::Node {
  IntegralOrBooleanTypeBarrier() {
    exists(StructType t, Struct s |
      t = TypeInference::inferType(this.asExpr()) and
      s = t.getStruct()
    |
      s instanceof Builtins::IntegralType or
      s instanceof Builtins::Bool
    )
  }
}
