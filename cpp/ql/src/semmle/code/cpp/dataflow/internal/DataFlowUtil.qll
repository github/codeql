/**
 * Provides C++-specific definitions for use in the data flow library.
 */
import cpp
private import semmle.code.cpp.dataflow.internal.FlowVar

private newtype TNode =
  TExprNode(Expr e) or
  TParameterNode(Parameter p) { exists(p.getFunction().getBlock()) } or
  TUninitializedNode(LocalVariable v) {
    not v.hasInitializer()
  }

/**
 * A node in a data flow graph.
 *
 * A node can be either an expression, a parameter, or an uninitialized local
 * variable. Such nodes are created with `DataFlow::exprNode`,
 * `DataFlow::parameterNode`, and `DataFlow::uninitializedNode` respectively.
*/
class Node extends TNode {
  /** Gets the function to which this node belongs. */
  Function getFunction() {
    result = this.asExpr().getEnclosingFunction()
    or
    result = this.asParameter().getFunction()
    or
    result = this.asUninitialized().getFunction()
  }

  /**
   * INTERNAL: Do not use. Alternative name for `getFunction`.
   */
  Function getEnclosingCallable() {
    result = this.getFunction()
  }

  /** Gets the type of this node. */
  Type getType() {
    result = this.asExpr().getType()
    or
    result = asVariable(this).getType()
  }

  /** Gets the expression corresponding to this node, if any. */
  Expr asExpr() { result = this.(ExprNode).getExpr() }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ParameterNode).getParameter() }

  /**
   * Gets the uninitialized local variable corresponding to this node, if
   * any.
   */
  LocalVariable asUninitialized() {
    result = this.(UninitializedNode).getLocalVariable()
  }

  /** Gets a textual representation of this element. */
  string toString() { none() } // overridden by subclasses

  /** Gets the location of this element. */
  Location getLocation() { none() } // overridden by subclasses

  /**
   * Gets an upper bound on the type of this node.
   */
  Type getTypeBound() { result = getType() }
}

/**
 * An expression, viewed as a node in a data flow graph.
 */
class ExprNode extends Node, TExprNode {
  Expr expr;
  ExprNode() { this = TExprNode(expr) }
  override string toString() { result = expr.toString() }
  override Location getLocation() { result = expr.getLocation() }
  /** Gets the expression corresponding to this node. */
  Expr getExpr() { result = expr }
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends Node, TParameterNode {
  Parameter param;
  ParameterNode() { this = TParameterNode(param) }
  override string toString() { result = param.toString() }
  override Location getLocation() { result = param.getLocation() }
  /** Gets the parameter corresponding to this node. */
  Parameter getParameter() { result = param }
  /**
   * Holds if this node is the parameter of `c` at the specified (zero-based)
   * position. The implicit `this` parameter is considered to have index `-1`.
   */
  predicate isParameterOf(Function f, int i) {
    f.getParameter(i) = param
  }
}

/**
 * The value of an uninitialized local variable, viewed as a node in a data
 * flow graph.
 */
class UninitializedNode extends Node, TUninitializedNode {
  LocalVariable v;
  UninitializedNode() { this = TUninitializedNode(v) }
  override string toString() { result = v.toString() }
  override Location getLocation() { result = v.getLocation() }
  /** Gets the uninitialized local variable corresponding to this node. */
  LocalVariable getLocalVariable() { result = v }
}

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), or the qualifier of a field after
 * an update to the field.
 *
 * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
 * to the value before the update with the exception of `ClassInstanceExpr`,
 * which represents the value after the constructor has run.
 */
class PostUpdateNode extends Node {
  PostUpdateNode() { none() } // stub implementation
  /**
   * Gets the node before the state update.
   */
  Node getPreUpdateNode() { none() } // stub implementation
}

/**
 * Gets the `Node` corresponding to `e`.
 */
ExprNode exprNode(Expr e) { result.getExpr() = e }

/**
 * Gets the `Node` corresponding to the value of `p` at function entry.
 */
ParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/**
 * Gets the `Node` corresponding to the value of an uninitialized local
 * variable `v`.
 */
UninitializedNode uninitializedNode(LocalVariable v) {
  result.getLocalVariable() = v
}

private Variable asVariable(Node node) {
  result = node.asParameter()
  or
  result = node.asUninitialized()
}

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep(Node nodeFrom, Node nodeTo) {
  // Expr -> Expr
  exprToExprStep_nocfg(nodeFrom.asExpr(), nodeTo.asExpr())
  or
  // Node -> FlowVar -> VariableAccess
  exists(FlowVar var |
    (
      exprToVarStep(nodeFrom.asExpr(), var)
      or
      varSourceBaseCase(var, asVariable(nodeFrom))
    ) and
    varToExprStep(var, nodeTo.asExpr())
  )
}

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) {
  localFlowStep*(source, sink)
}

/**
 * Holds if the initial value of `v`, if it is a source, flows to `var`.
 */
private predicate varSourceBaseCase(FlowVar var, Variable v) {
  var.definedByInitialValue(v)
}

/**
 * Holds if `var` is defined by an assignment-like operation that causes flow
 * directly from `assignedExpr` to `var`, _and_ `assignedExpr` evaluates to
 * the same value as what is assigned to `var`.
 */
private predicate exprToVarStep(Expr assignedExpr, FlowVar var) {
  exists(ControlFlowNode operation |
    var.definedByExpr(assignedExpr, operation) and
    not operation instanceof PostfixCrementOperation
  )
}

/**
 * Holds if the expression `e` is an access of the variable `var`.
 */
private predicate varToExprStep(FlowVar var, Expr e) {
  e = var.getAnAccess()
}

/**
 * Holds if data flows from `fromExpr` to `toExpr` directly, in the case
 * where `toExpr` is the immediate AST parent of `fromExpr`. For example,
 * data flows from `x` and `y` to `b ? x : y`.
 */
private predicate exprToExprStep_nocfg(Expr fromExpr, Expr toExpr) {
  toExpr = any(ConditionalExpr cond |
    fromExpr = cond.getThen() or fromExpr = cond.getElse()
  )
  or
  toExpr = any(AssignExpr assign |
    fromExpr = assign.getRValue()
  )
  or
  toExpr = any(CommaExpr comma |
    fromExpr = comma.getRightOperand()
  )
  or
  toExpr = any(PostfixCrementOperation op |
    fromExpr = op.getOperand()
  )
  or
  toExpr = any(FunctionCall moveCall |
    moveCall.getTarget().getNamespace().getName() = "std" and
    moveCall.getTarget().getName() = "move" and
    fromExpr = moveCall.getArgument(0)
  )
}

VariableAccess getAnAccessToAssignedVariable(Expr assign) {
  (assign instanceof Assignment
   or
   assign instanceof CrementOperation) and
  exists(FlowVar var |
    var.definedByExpr(_, assign) and
    result = var.getAnAccess()
  )
}
