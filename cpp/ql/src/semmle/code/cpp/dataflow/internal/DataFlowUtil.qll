/**
 * Provides C++-specific definitions for use in the data flow library.
 */

private import cpp
private import semmle.code.cpp.dataflow.internal.FlowVar
private import semmle.code.cpp.models.interfaces.DataFlow

cached
private newtype TNode =
  TExprNode(Expr e) or
  TPartialDefinitionNode(PartialDefinition pd) or
  TPreConstructorCallNode(ConstructorCall call) or
  TExplicitParameterNode(Parameter p) { exists(p.getFunction().getBlock()) } or
  TInstanceParameterNode(MemberFunction f) { exists(f.getBlock()) and not f.isStatic() } or
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
  Parameter asParameter() { result = this.(ExplicitParameterNode).getParameter() }

  /** Gets the argument that defines this `DefinitionByReferenceNode`, if any. */
  Expr asDefiningArgument() { result = this.(DefinitionByReferenceNode).getArgument() }

  /**
   * Gets the expression that is partially defined by this node, if any.
   *
   * Partial definitions are created for field stores (`x.y = taint();` is a partial
   * definition of `x`), and for calls that may change the value of an object (so
   * `x.set(taint())` is a partial definition of `x`, and `transfer(&x, taint())` is
   * a partial definition of `&x`).
   */
  Expr asPartialDefinition() {
    result = this.(PartialDefinitionNode).getPartialDefinition().getDefinedExpr()
  }

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

abstract class ParameterNode extends Node, TNode {
  /**
   * Holds if this node is the parameter of `c` at the specified (zero-based)
   * position. The implicit `this` parameter is considered to have index `-1`.
   */
  abstract predicate isParameterOf(Function f, int i);
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ExplicitParameterNode extends ParameterNode, TExplicitParameterNode {
  Parameter param;

  ExplicitParameterNode() { this = TExplicitParameterNode(param) }

  override Function getFunction() { result = param.getFunction() }

  override Type getType() { result = param.getType() }

  override string toString() { result = param.toString() }

  override Location getLocation() { result = param.getLocation() }

  /** Gets the parameter corresponding to this node. */
  Parameter getParameter() { result = param }

  override predicate isParameterOf(Function f, int i) { f.getParameter(i) = param }
}

class ImplicitParameterNode extends ParameterNode, TInstanceParameterNode {
  MemberFunction f;

  ImplicitParameterNode() { this = TInstanceParameterNode(f) }

  override Function getFunction() { result = f }

  override Type getType() { result = f.getDeclaringType() }

  override string toString() { result = "`this` parameter in " + f.getName() }

  override Location getLocation() { result = f.getLocation() }

  override predicate isParameterOf(Function fun, int i) { f = fun and i = -1 }
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
class DefinitionByReferenceNode extends PartialDefinitionNode {
  VariableAccess va;

  Expr argument;

  DefinitionByReferenceNode() {
    exists(DefinitionByReference def |
      def = this.getPartialDefinition() and
      argument = def.getDefinedExpr() and
      va = def.getVariableAccess()
    )
  }

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
abstract class PostUpdateNode extends Node {
  /**
   * Gets the node before the state update.
   */
  abstract Node getPreUpdateNode();

  override Function getFunction() { result = getPreUpdateNode().getFunction() }

  override Type getType() { result = getPreUpdateNode().getType() }

  override Location getLocation() { result = getPreUpdateNode().getLocation() }
}

class PartialDefinitionNode extends PostUpdateNode, TPartialDefinitionNode {
  PartialDefinition pd;

  PartialDefinitionNode() { this = TPartialDefinitionNode(pd) }

  override Node getPreUpdateNode() { result.asExpr() = pd.getDefinedExpr() }

  override Location getLocation() { result = pd.getLocation() }

  PartialDefinition getPartialDefinition() { result = pd }

  override string toString() { result = getPreUpdateNode().toString() + " [post update]" }
}

/**
 * A node representing the object that was just constructed and is identified
 * with the "return value" of the constructor call.
 */
private class PostConstructorCallNode extends PostUpdateNode, TExprNode {
  PostConstructorCallNode() { this = TExprNode(any(ConstructorCall c)) }

  override PreConstructorCallNode getPreUpdateNode() {
    TExprNode(result.getConstructorCall()) = this
  }

  // No override of `toString` since these nodes already have a `toString` from
  // their overlap with `ExprNode`.
}

/**
 * INTERNAL: do not use.
 *
 * A synthetic data-flow node that plays the role of the qualifier (or
 * `this`-argument) to a constructor call.
 */
class PreConstructorCallNode extends Node, TPreConstructorCallNode {
  ConstructorCall getConstructorCall() { this = TPreConstructorCallNode(result) }

  override Function getFunction() { result = getConstructorCall().getEnclosingFunction() }

  override Type getType() { result = getConstructorCall().getType() }

  override Location getLocation() { result = getConstructorCall().getLocation() }

  override string toString() { result = getConstructorCall().toString() + " [pre constructor call]" }
}

/**
 * Gets the `Node` corresponding to `e`.
 */
ExprNode exprNode(Expr e) { result.getExpr() = e }

/**
 * Gets the `Node` corresponding to the value of `p` at function entry.
 */
ParameterNode parameterNode(Parameter p) { result.(ExplicitParameterNode).getParameter() = p }

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

private module ThisFlow {
  private Node thisAccessNode(ControlFlowNode cfn) {
    result.(ImplicitParameterNode).getFunction().getBlock() = cfn or
    result.asExpr().(ThisExpr) = cfn
  }

  private int basicBlockThisIndex(BasicBlock b, Node thisNode) {
    thisNode = thisAccessNode(b.getNode(result))
  }

  private int thisRank(BasicBlock b, Node thisNode) {
    thisNode = rank[result](thisAccessNode(_) as node order by basicBlockThisIndex(b, node))
  }

  private int lastThisRank(BasicBlock b) { result = max(thisRank(b, _)) }

  private predicate thisAccessBlockReaches(BasicBlock b1, BasicBlock b2) {
    exists(basicBlockThisIndex(b1, _)) and b2 = b1.getASuccessor()
    or
    exists(BasicBlock mid |
      thisAccessBlockReaches(b1, mid) and
      b2 = mid.getASuccessor() and
      not exists(basicBlockThisIndex(mid, _))
    )
  }

  predicate adjacentThisRefs(Node n1, Node n2) {
    exists(BasicBlock b | thisRank(b, n1) + 1 = thisRank(b, n2))
    or
    exists(BasicBlock b1, BasicBlock b2 |
      lastThisRank(b1) = thisRank(b1, n1) and
      thisAccessBlockReaches(b1, b2) and
      thisRank(b2, n2) = 1
    )
  }
}

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
cached
predicate localFlowStep(Node nodeFrom, Node nodeTo) {
  // Expr -> Expr
  exprToExprStep_nocfg(nodeFrom.asExpr(), nodeTo.asExpr())
  or
  exprToExprStep_nocfg(nodeFrom.(PostUpdateNode).getPreUpdateNode().asExpr(), nodeTo.asExpr())
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
      var.definedPartiallyAt(nodeFrom.asPartialDefinition())
    ) and
    varToExprStep(var, nodeTo.asExpr())
  )
  or
  // Expr -> DefinitionByReferenceNode
  exprToDefinitionByReferenceStep(nodeFrom.asExpr(), nodeTo.asDefiningArgument())
  or
  // `this` -> adjacent-`this`
  ThisFlow::adjacentThisRefs(nodeFrom, nodeTo)
  or
  // post-update-`this` -> following-`this`-ref
  ThisFlow::adjacentThisRefs(nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
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
  // The following case is needed to track the qualifier object for flow
  // through fields. It gives flow from `T(x)` to `new T(x)`. That's not
  // strictly _data_ flow but _taint_ flow because the type of `fromExpr` is
  // `T` while the type of `toExpr` is `T*`.
  //
  // This discrepancy is an artifact of how `new`-expressions are represented
  // in the database in a way that slightly varies from what the standard
  // specifies. In the C++ standard, there is no constructor call expression
  // `T(x)` after `new`. Instead there is a type `T` and an optional
  // initializer `(x)`.
  toExpr.(NewExpr).getInitializer() = fromExpr
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

/**
 * A guard that validates some expression.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
class BarrierGuard extends Expr {
  /** NOT YET SUPPORTED. Holds if this guard validates `e` upon evaluating to `branch`. */
  abstract deprecated predicate checks(Expr e, boolean branch);

  /** Gets a node guarded by this guard. */
  final Node getAGuardedNode() {
    none() // stub
  }
}
