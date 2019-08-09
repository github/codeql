/**
 * Provides C++-specific definitions for use in the data flow library.
 */

private import cpp
private import semmle.code.cpp.dataflow.internal.FlowVar
private import semmle.code.cpp.models.interfaces.DataFlow

cached
private newtype TNode =
  TExprNode(Expr e) or
  TParameterNode(Parameter p) { exists(p.getFunction().getBlock()) } or
  TDefinitionByReferenceNode(VariableAccess va, Expr argument) {
    definitionByReference(va, argument)
  } or
  TUninitializedNode(LocalVariable v) { not v.hasInitializer() }

/**
 * A node in a data flow graph.
 *
 * A node can be either an expression, a parameter, or an uninitialized local
 * variable. Such nodes are created with `DataFlow::exprNode`,
 * `DataFlow::parameterNode`, and `DataFlow::uninitializedNode` respectively.
 */
class Node extends TNode {
  /** Gets the function to which this node belongs. */
  Function getFunction() { none() } // overridden in subclasses

  /**
   * INTERNAL: Do not use. Alternative name for `getFunction`.
   */
  Function getEnclosingCallable() { result = this.getFunction() }

  /** Gets the type of this node. */
  Type getType() { none() } // overridden in subclasses

  /** Gets the expression corresponding to this node, if any. */
  Expr asExpr() { result = this.(ExprNode).getExpr() }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ParameterNode).getParameter() }

  /** Gets the argument that defines this `DefinitionByReferenceNode`, if any. */
  Expr asDefiningArgument() { result = this.(DefinitionByReferenceNode).getArgument() }

  /**
   * Gets the uninitialized local variable corresponding to this node, if
   * any.
   */
  LocalVariable asUninitialized() { result = this.(UninitializedNode).getLocalVariable() }

  /** Gets a textual representation of this element. */
  string toString() { none() } // overridden by subclasses

  /** Gets the location of this element. */
  Location getLocation() { none() } // overridden by subclasses

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

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

  override Function getFunction() { result = expr.getEnclosingFunction() }

  override Type getType() { result = expr.getType() }

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

  override Function getFunction() { result = param.getFunction() }

  override Type getType() { result = param.getType() }

  override string toString() { result = param.toString() }

  override Location getLocation() { result = param.getLocation() }

  /** Gets the parameter corresponding to this node. */
  Parameter getParameter() { result = param }

  /**
   * Holds if this node is the parameter of `c` at the specified (zero-based)
   * position. The implicit `this` parameter is considered to have index `-1`.
   */
  predicate isParameterOf(Function f, int i) { f.getParameter(i) = param }
}

/**
 * A node that represents the value of a variable after a function call that
 * may have changed the variable because it's passed by reference.
 *
 * A typical example would be a call `f(&x)`. Firstly, there will be flow into
 * `x` from previous definitions of `x`. Secondly, there will be a
 * `DefinitionByReferenceNode` to represent the value of `x` after the call has
 * returned. This node will have its `getArgument()` equal to `&x`.
 */
class DefinitionByReferenceNode extends Node, TDefinitionByReferenceNode {
  VariableAccess va;

  Expr argument;

  DefinitionByReferenceNode() { this = TDefinitionByReferenceNode(va, argument) }

  override Function getFunction() { result = va.getEnclosingFunction() }

  override Type getType() { result = va.getType() }

  override string toString() { result = "ref arg " + argument.toString() }

  override Location getLocation() { result = argument.getLocation() }

  /** Gets the argument corresponding to this node. */
  Expr getArgument() { result = argument }

  /** Gets the parameter through which this value is assigned. */
  Parameter getParameter() {
    exists(FunctionCall call, int i |
      argument = call.getArgument(i) and
      result = call.getTarget().getParameter(i)
    )
  }
}

/**
 * The value of an uninitialized local variable, viewed as a node in a data
 * flow graph.
 */
class UninitializedNode extends Node, TUninitializedNode {
  LocalVariable v;

  UninitializedNode() { this = TUninitializedNode(v) }

  override Function getFunction() { result = v.getFunction() }

  override Type getType() { result = v.getType() }

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
 * Gets the `Node` corresponding to a definition by reference of the variable
 * that is passed as `argument` of a call.
 */
DefinitionByReferenceNode definitionByReferenceNodeFromArgument(Expr argument) {
  result.getArgument() = argument
}

/**
 * Gets the `Node` corresponding to the value of an uninitialized local
 * variable `v`.
 */
UninitializedNode uninitializedNode(LocalVariable v) { result.getLocalVariable() = v }

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
cached
predicate localFlowStep(Node nodeFrom, Node nodeTo) {
  // Expr -> Expr
  exprToExprStep_nocfg(nodeFrom.asExpr(), nodeTo.asExpr())
  or
  // Node -> FlowVar -> VariableAccess
  exists(FlowVar var |
    (
      exprToVarStep(nodeFrom.asExpr(), var)
      or
      varSourceBaseCase(var, nodeFrom.asParameter())
      or
      varSourceBaseCase(var, nodeFrom.asUninitialized())
      or
      var.definedByReference(nodeFrom.asDefiningArgument())
    ) and
    varToExprStep(var, nodeTo.asExpr())
  )
  or
  // Expr -> DefinitionByReferenceNode
  exprToDefinitionByReferenceStep(nodeFrom.asExpr(), nodeTo.asDefiningArgument())
}

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * Holds if the initial value of `v`, if it is a source, flows to `var`.
 */
private predicate varSourceBaseCase(FlowVar var, Variable v) { var.definedByInitialValue(v) }

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
private predicate varToExprStep(FlowVar var, Expr e) { e = var.getAnAccess() }

/**
 * Holds if data flows from `fromExpr` to `toExpr` directly, in the case
 * where `toExpr` is the immediate AST parent of `fromExpr`. For example,
 * data flows from `x` and `y` to `b ? x : y`.
 */
private predicate exprToExprStep_nocfg(Expr fromExpr, Expr toExpr) {
  toExpr = any(ConditionalExpr cond | fromExpr = cond.getThen() or fromExpr = cond.getElse())
  or
  toExpr = any(AssignExpr assign | fromExpr = assign.getRValue())
  or
  toExpr = any(CommaExpr comma | fromExpr = comma.getRightOperand())
  or
  toExpr = any(PostfixCrementOperation op | fromExpr = op.getOperand())
  or
  toExpr = any(StmtExpr stmtExpr | fromExpr = stmtExpr.getResultExpr())
  or
  toExpr = any(Call call |
      exists(DataFlowFunction f, FunctionInput inModel, FunctionOutput outModel, int iIn |
        call.getTarget() = f and
        f.hasDataFlow(inModel, outModel) and
        outModel.isOutReturnValue() and
        inModel.isInParameter(iIn) and
        fromExpr = call.getArgument(iIn)
      )
    )
}

private predicate exprToDefinitionByReferenceStep(Expr exprIn, Expr argOut) {
  exists(DataFlowFunction f, Call call, FunctionOutput outModel, int argOutIndex |
    call.getTarget() = f and
    argOut = call.getArgument(argOutIndex) and
    outModel.isOutParameterPointer(argOutIndex) and
    exists(int argInIndex, FunctionInput inModel | f.hasDataFlow(inModel, outModel) |
      inModel.isInParameterPointer(argInIndex) and
      call.passesByReference(argInIndex, exprIn)
      or
      inModel.isInParameter(argInIndex) and
      exprIn = call.getArgument(argInIndex)
    )
  )
}

VariableAccess getAnAccessToAssignedVariable(Expr assign) {
  (
    assign instanceof Assignment
    or
    assign instanceof CrementOperation
  ) and
  exists(FlowVar var |
    var.definedByExpr(_, assign) and
    result = var.getAnAccess()
  )
}

/** A guard that validates some expression. */
class BarrierGuard extends Expr {
  /** Holds if this guard validates `e` upon evaluating to `branch`. */
  abstract predicate checks(Expr e, boolean branch);

  /** Gets a node guarded by this. */
  final Node getAGuardedNode() {
    none() // stub
  }
}
