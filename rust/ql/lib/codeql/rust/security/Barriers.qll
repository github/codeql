/**
 * Classes to represent barriers commonly used in data flow and taint tracking
 * configurations.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.internal.typeinference.TypeInference as TypeInference
private import codeql.rust.internal.typeinference.Type
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.controlflow.CfgNodes as CfgNodes
private import codeql.rust.frameworks.stdlib.Builtins as Builtins

/** A node whose type is a numeric type. */
class NumericTypeBarrier extends DataFlow::Node {
  NumericTypeBarrier() {
    TypeInference::inferType(this.asExpr()).(StructType).getTypeItem() instanceof
      Builtins::NumericType
  }
}

/** A node whose type is `bool`. */
class BooleanTypeBarrier extends DataFlow::Node {
  BooleanTypeBarrier() {
    TypeInference::inferType(this.asExpr()).(StructType).getTypeItem() instanceof Builtins::Bool
  }
}

/** A node whose type is an integral (integer). */
class IntegralTypeBarrier extends DataFlow::Node {
  IntegralTypeBarrier() {
    TypeInference::inferType(this.asExpr()).(StructType).getTypeItem() instanceof
      Builtins::IntegralType
  }
}

/** A node whose type is a fieldless enum. */
class FieldlessEnumTypeBarrier extends DataFlow::Node {
  FieldlessEnumTypeBarrier() {
    TypeInference::inferType(this.asExpr()).(EnumType).getTypeItem().isFieldless()
  }
}

/**
 * Holds if guard expression `g` having result `branch` indicates that the
 * sub-expression `e` is not null. For example when `ptr.is_null()` is
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
