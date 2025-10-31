/**
 * Classes to represent barriers commonly used in dataflow and taint tracking
 * configurations.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.internal.TypeInference as TypeInference
private import codeql.rust.internal.Type
private import codeql.rust.frameworks.stdlib.Builtins

/**
 * A node whose type is a numeric or boolean type, which may be an appropriate
 * taint flow barrier for some queries.
 */
class NumericTypeBarrier extends DataFlow::Node {
  NumericTypeBarrier() {
    exists(TypeInference::Type t |
      t = TypeInference::inferType(this.asExpr().getExpr()) and
      (
        t.(StructType).getStruct() instanceof NumericType or
        t.(StructType).getStruct() instanceof Bool
      )
    )
  }
}
