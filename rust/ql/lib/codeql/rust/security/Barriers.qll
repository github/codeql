/**
 * Classes to represent barriers commonly used in dataflow and taint tracking
 * configurations.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.internal.TypeInference as TypeInference
private import codeql.rust.internal.Type
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.controlflow.CfgNodes as CfgNodes
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

/**
 * Holds if guard expression `g` having result `branch` indicates that the
 * sub-expression `node` is not null. For example when `ptr.is_null()` is
 * `false`, we have that `ptr` is not null.
 */
private predicate notNullCheck(AstNode g, Expr e, boolean branch) {
  exists(MethodCallExpr call |
    call.getStaticTarget().getName().getText() = "is_null" and
    g = call and
    e = call.getReceiver() and
    branch = false
  )
}

/**
 * A node representing a value checked to be non-null. This may be an
 * appropriate taint flow barrier for some queries.
 */
class NotNullCheckBarrier extends DataFlow::Node {
  NotNullCheckBarrier() { this = DataFlow::BarrierGuard<notNullCheck/3>::getABarrierNode() }
}
