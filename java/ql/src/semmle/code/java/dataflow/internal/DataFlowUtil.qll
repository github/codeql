/**
 * Basic definitions for use in the data flow library.
 */

private import java
private import DataFlowPrivate
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dataflow.TypeFlow
private import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.InstanceAccess

cached
private newtype TNode =
  TExprNode(Expr e) {
    not e.getType() instanceof VoidType and
    not e.getParent*() instanceof Annotation
  } or
  TExplicitParameterNode(Parameter p) { exists(p.getCallable().getBody()) } or
  TImplicitVarargsArray(Call c) {
    c.getCallee().isVarargs() and
    not exists(Argument arg | arg.getCall() = c and arg.isExplicitVarargsArray())
  } or
  TInstanceParameterNode(Callable c) { exists(c.getBody()) and not c.isStatic() } or
  TImplicitInstanceAccess(InstanceAccessExt ia) { not ia.isExplicit(_) } or
  TMallocNode(ClassInstanceExpr cie) or
  TExplicitExprPostUpdate(Expr e) {
    explicitInstanceArgument(_, e)
    or
    e instanceof Argument and not e.getType() instanceof ImmutableType
    or
    exists(FieldAccess fa | fa.getField() instanceof InstanceField and e = fa.getQualifier())
    or
    exists(ArrayAccess aa | e = aa.getArray())
  } or
  TImplicitExprPostUpdate(InstanceAccessExt ia) {
    implicitInstanceArgument(_, ia)
    or
    exists(FieldAccess fa |
      fa.getField() instanceof InstanceField and ia.isImplicitFieldQualifier(fa)
    )
  }

/**
 * An element, viewed as a node in a data flow graph. Either an expression,
 * a parameter, or an implicit varargs array creation.
 */
class Node extends TNode {
  /** Gets a textual representation of this element. */
  string toString() { none() }

  /** Gets the source location for this element. */
  Location getLocation() { none() }

  /** Gets the expression corresponding to this node, if any. */
  Expr asExpr() { result = this.(ExprNode).getExpr() }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ExplicitParameterNode).getParameter() }

  /** Gets the type of this node. */
  Type getType() {
    result = this.asExpr().getType()
    or
    result = this.asParameter().getType()
    or
    exists(Parameter p |
      result = p.getType() and
      p.isVarargs() and
      p = this.(ImplicitVarargsArray).getCall().getCallee().getAParameter()
    )
    or
    result = this.(InstanceParameterNode).getCallable().getDeclaringType()
    or
    result = this.(ImplicitInstanceAccess).getInstanceAccess().getType()
    or
    result = this.(MallocNode).getClassInstanceExpr().getType()
    or
    result = this.(ImplicitPostUpdateNode).getPreUpdateNode().getType()
  }

  private Callable getEnclosingCallableImpl() {
    result = this.asExpr().getEnclosingCallable() or
    result = this.asParameter().getCallable() or
    result = this.(ImplicitVarargsArray).getCall().getEnclosingCallable() or
    result = this.(InstanceParameterNode).getCallable() or
    result = this.(ImplicitInstanceAccess).getInstanceAccess().getEnclosingCallable() or
    result = this.(MallocNode).getClassInstanceExpr().getEnclosingCallable() or
    result = this.(ImplicitPostUpdateNode).getPreUpdateNode().getEnclosingCallableImpl()
  }

  /** Gets the callable in which this node occurs. */
  Callable getEnclosingCallable() {
    result = unique(DataFlowCallable c | c = this.getEnclosingCallableImpl() | c)
  }

  private Type getImprovedTypeBound() {
    exprTypeFlow(this.asExpr(), result, _) or
    result = this.(ImplicitPostUpdateNode).getPreUpdateNode().getImprovedTypeBound()
  }

  /**
   * Gets an upper bound on the type of this node.
   */
  Type getTypeBound() {
    result = getImprovedTypeBound()
    or
    result = getType() and not exists(getImprovedTypeBound())
  }

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

/** Gets the node corresponding to `e`. */
ExprNode exprNode(Expr e) { result.getExpr() = e }

/** An explicit or implicit parameter. */
abstract class ParameterNode extends Node {
  /**
   * Holds if this node is the parameter of `c` at the specified (zero-based)
   * position. The implicit `this` parameter is considered to have index `-1`.
   */
  abstract predicate isParameterOf(Callable c, int pos);
}

/**
 * A parameter, viewed as a node in a data flow graph.
 */
class ExplicitParameterNode extends ParameterNode, TExplicitParameterNode {
  Parameter param;

  ExplicitParameterNode() { this = TExplicitParameterNode(param) }

  override string toString() { result = param.toString() }

  override Location getLocation() { result = param.getLocation() }

  /** Gets the parameter corresponding to this node. */
  Parameter getParameter() { result = param }

  override predicate isParameterOf(Callable c, int pos) { c.getParameter(pos) = param }
}

/** Gets the node corresponding to `p`. */
ExplicitParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/**
 * An implicit varargs array creation expression.
 *
 * A call `f(x1, x2)` to a method `f(A... xs)` desugars to `f(new A[]{x1, x2})`,
 * and this node corresponds to such an implicit array creation.
 */
class ImplicitVarargsArray extends Node, TImplicitVarargsArray {
  Call call;

  ImplicitVarargsArray() { this = TImplicitVarargsArray(call) }

  override string toString() { result = "new ..[] { .. }" }

  override Location getLocation() { result = call.getLocation() }

  /** Gets the call containing this varargs array creation argument. */
  Call getCall() { result = call }
}

/**
 * An instance parameter for an instance method or constructor.
 */
class InstanceParameterNode extends ParameterNode, TInstanceParameterNode {
  Callable callable;

  InstanceParameterNode() { this = TInstanceParameterNode(callable) }

  override string toString() { result = "parameter this" }

  override Location getLocation() { result = callable.getLocation() }

  /** Gets the callable containing this `this` parameter. */
  Callable getCallable() { result = callable }

  override predicate isParameterOf(Callable c, int pos) { callable = c and pos = -1 }
}

/**
 * An implicit read of `this` or `A.this`.
 */
class ImplicitInstanceAccess extends Node, TImplicitInstanceAccess {
  InstanceAccessExt ia;

  ImplicitInstanceAccess() { this = TImplicitInstanceAccess(ia) }

  override string toString() { result = ia.toString() }

  override Location getLocation() { result = ia.getLocation() }

  InstanceAccessExt getInstanceAccess() { result = ia }
}

/**
 * A node that corresponds to the value of a `ClassInstanceExpr` before the
 * constructor has run.
 */
private class MallocNode extends Node, TMallocNode {
  ClassInstanceExpr cie;

  MallocNode() { this = TMallocNode(cie) }

  override string toString() { result = cie.toString() + " [pre constructor]" }

  override Location getLocation() { result = cie.getLocation() }

  ClassInstanceExpr getClassInstanceExpr() { result = cie }
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
}

private class NewExpr extends PostUpdateNode, TExprNode {
  NewExpr() { exists(ClassInstanceExpr cie | this = TExprNode(cie)) }

  override Node getPreUpdateNode() { this = TExprNode(result.(MallocNode).getClassInstanceExpr()) }
}

/**
 * A `PostUpdateNode` that is not a `ClassInstanceExpr`.
 */
abstract private class ImplicitPostUpdateNode extends PostUpdateNode {
  override Location getLocation() { result = getPreUpdateNode().getLocation() }

  override string toString() { result = getPreUpdateNode().toString() + " [post update]" }
}

private class ExplicitExprPostUpdate extends ImplicitPostUpdateNode, TExplicitExprPostUpdate {
  override Node getPreUpdateNode() { this = TExplicitExprPostUpdate(result.asExpr()) }
}

private class ImplicitExprPostUpdate extends ImplicitPostUpdateNode, TImplicitExprPostUpdate {
  override Node getPreUpdateNode() {
    this = TImplicitExprPostUpdate(result.(ImplicitInstanceAccess).getInstanceAccess())
  }
}

/** Holds if `n` is an access to an unqualified `this` at `cfgnode`. */
private predicate thisAccess(Node n, ControlFlowNode cfgnode) {
  n.(InstanceParameterNode).getCallable().getBody() = cfgnode
  or
  exists(InstanceAccess ia | ia = n.asExpr() and ia = cfgnode and ia.isOwnInstanceAccess())
  or
  n.(ImplicitInstanceAccess).getInstanceAccess().(OwnInstanceAccess).getCfgNode() = cfgnode
}

/** Calculation of the relative order in which `this` references are read. */
private module ThisFlow {
  private predicate thisAccess(Node n, BasicBlock b, int i) { thisAccess(n, b.getNode(i)) }

  private predicate thisRank(Node n, BasicBlock b, int rankix) {
    exists(int i |
      i = rank[rankix](int j | thisAccess(_, b, j)) and
      thisAccess(n, b, i)
    )
  }

  private int lastRank(BasicBlock b) { result = max(int rankix | thisRank(_, b, rankix)) }

  private predicate blockPrecedesThisAccess(BasicBlock b) { thisAccess(_, b.getABBSuccessor*(), _) }

  private predicate thisAccessBlockReaches(BasicBlock b1, BasicBlock b2) {
    thisAccess(_, b1, _) and b2 = b1.getABBSuccessor()
    or
    exists(BasicBlock mid |
      thisAccessBlockReaches(b1, mid) and
      b2 = mid.getABBSuccessor() and
      not thisAccess(_, mid, _) and
      blockPrecedesThisAccess(b2)
    )
  }

  private predicate thisAccessBlockStep(BasicBlock b1, BasicBlock b2) {
    thisAccessBlockReaches(b1, b2) and
    thisAccess(_, b2, _)
  }

  /** Holds if `n1` and `n2` are control-flow adjacent references to `this`. */
  predicate adjacentThisRefs(Node n1, Node n2) {
    exists(int rankix, BasicBlock b |
      thisRank(n1, b, rankix) and
      thisRank(n2, b, rankix + 1)
    )
    or
    exists(BasicBlock b1, BasicBlock b2 |
      thisRank(n1, b1, lastRank(b1)) and
      thisAccessBlockStep(b1, b2) and
      thisRank(n2, b2, 1)
    )
  }
}

/**
 * Holds if data can flow from `node1` to `node2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localFlow(Node node1, Node node2) { localFlowStep*(node1, node2) }

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localExprFlow(Expr e1, Expr e2) { localFlow(exprNode(e1), exprNode(e2)) }

/**
 * Holds if the `FieldRead` is not completely determined by explicit SSA
 * updates.
 */
predicate hasNonlocalValue(FieldRead fr) {
  not exists(SsaVariable v | v.getAUse() = fr)
  or
  exists(SsaVariable v, SsaVariable def | v.getAUse() = fr and def = v.getAnUltimateDefinition() |
    def instanceof SsaImplicitInit or
    def instanceof SsaImplicitUpdate
  )
}

/**
 * Holds if data can flow from `node1` to `node2` in one local step.
 */
predicate localFlowStep(Node node1, Node node2) { simpleLocalFlowStep(node1, node2) }

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
cached
predicate simpleLocalFlowStep(Node node1, Node node2) {
  // Variable flow steps through adjacent def-use and use-use pairs.
  exists(SsaExplicitUpdate upd |
    upd.getDefiningExpr().(VariableAssign).getSource() = node1.asExpr() or
    upd.getDefiningExpr().(AssignOp) = node1.asExpr()
  |
    node2.asExpr() = upd.getAFirstUse()
  )
  or
  exists(SsaImplicitInit init |
    init.isParameterDefinition(node1.asParameter()) and
    node2.asExpr() = init.getAFirstUse()
  )
  or
  adjacentUseUse(node1.asExpr(), node2.asExpr()) and
  not exists(FieldRead fr |
    hasNonlocalValue(fr) and fr.getField().isStatic() and fr = node1.asExpr()
  )
  or
  ThisFlow::adjacentThisRefs(node1, node2)
  or
  adjacentUseUse(node1.(PostUpdateNode).getPreUpdateNode().asExpr(), node2.asExpr())
  or
  ThisFlow::adjacentThisRefs(node1.(PostUpdateNode).getPreUpdateNode(), node2)
  or
  node2.asExpr().(CastExpr).getExpr() = node1.asExpr()
  or
  node2.asExpr().(ChooseExpr).getAResultExpr() = node1.asExpr()
  or
  node2.asExpr().(AssignExpr).getSource() = node1.asExpr()
  or
  exists(MethodAccess ma, Method m |
    ma = node2.asExpr() and
    m = ma.getMethod() and
    m.getDeclaringType().hasQualifiedName("java.util", "Objects") and
    (
      m.hasName(["requireNonNull", "requireNonNullElseGet"]) and node1.asExpr() = ma.getArgument(0)
      or
      m.hasName("requireNonNullElse") and node1.asExpr() = ma.getAnArgument()
      or
      m.hasName("toString") and node1.asExpr() = ma.getArgument(1)
    )
  )
  or
  exists(MethodAccess ma, Method m |
    ma = node2.asExpr() and
    m = ma.getMethod() and
    m
        .getDeclaringType()
        .getSourceDeclaration()
        .getASourceSupertype*()
        .hasQualifiedName("java.util", "Stack") and
    m.hasName("push") and
    node1.asExpr() = ma.getArgument(0)
  )
}

/**
 * Gets the node that occurs as the qualifier of `fa`.
 */
Node getFieldQualifier(FieldAccess fa) {
  fa.getField() instanceof InstanceField and
  (
    result.asExpr() = fa.getQualifier() or
    result.(ImplicitInstanceAccess).getInstanceAccess().isImplicitFieldQualifier(fa)
  )
}

private predicate explicitInstanceArgument(Call call, Expr instarg) {
  call instanceof MethodAccess and instarg = call.getQualifier() and not call.getCallee().isStatic()
}

private predicate implicitInstanceArgument(Call call, InstanceAccessExt ia) {
  ia.isImplicitMethodQualifier(call) or
  ia.isImplicitThisConstructorArgument(call)
}

/** Gets the instance argument of a non-static call. */
Node getInstanceArgument(Call call) {
  result.(MallocNode).getClassInstanceExpr() = call or
  explicitInstanceArgument(call, result.asExpr()) or
  implicitInstanceArgument(call, result.(ImplicitInstanceAccess).getInstanceAccess())
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
class BarrierGuard extends Guard {
  /** Holds if this guard validates `e` upon evaluating to `branch`. */
  abstract predicate checks(Expr e, boolean branch);

  /** Gets a node guarded by this guard. */
  final Node getAGuardedNode() {
    exists(SsaVariable v, boolean branch, RValue use |
      this.checks(v.getAUse(), branch) and
      use = v.getAUse() and
      this.controls(use.getBasicBlock(), branch) and
      result.asExpr() = use
    )
  }
}
