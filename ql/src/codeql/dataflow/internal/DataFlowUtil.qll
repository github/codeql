/**
 * Provides QL-specific definitions for use in the data flow library.
 */

private import ql

cached
private newtype TNode =
  TExprNode(Expr e) or
  TOutParameterNode(Parameter p) or
  TArgumentOutNode(VarAccess acc, Call call, int pos) {
    acc.(Argument).getCall() = call and acc.(Argument).getPosition() = pos
  } or
  TParameterNode(Parameter p)

/** An argument to a call. */
class Argument extends Expr {
  Call call;
  int pos;

  Argument() { call.getArgument(pos) = this }

  /** Gets the call that has this argument. */
  Call getCall() { result = call }

  /** Gets the position of this argument. */
  int getPosition() { result = pos }
}

newtype TDataFlowCallable =
  TDataFlowPredicate(Predicate p) or
  TDataFlowTopLevel() or
  TDataFlowNewtypeBranch(NewTypeBranch branch)

class DataFlowCallable extends TDataFlowCallable {
  string toString() {
    exists(Predicate p |
      this = TDataFlowPredicate(p) and
      result = p.toString()
    )
    or
    this = TDataFlowTopLevel() and
    result = "top level"
    or
    exists(NewTypeBranch branch |
      this = TDataFlowNewtypeBranch(branch) and
      result = branch.toString()
    )
  }

  Predicate asPredicate() { this = TDataFlowPredicate(result) }

  predicate asTopLevel() { this = TDataFlowTopLevel() }

  NewTypeBranch asNewTypeBranch() { this = TDataFlowNewtypeBranch(result) }
}

private newtype TParameter =
  TThisParam(ClassPredicate p) or
  TResultParam(Predicate p) { exists(p.getReturnType()) } or
  TVarParam(VarDecl v, int i, Predicate pred) { pred.getParameter(i) = v }

class Parameter extends TParameter {
  string toString() { this.hasName(result) }

  predicate hasName(string name) {
    this instanceof TThisParam and name = "this"
    or
    this instanceof TResultParam and name = "result"
    or
    exists(VarDecl v | this = TVarParam(v, _, _) and name = v.toString())
  }

  int getIndex() {
    this instanceof TThisParam and result = -1
    or
    this instanceof TResultParam and result = -2
    or
    this = TVarParam(_, result, _)
  }

  Predicate getPredicate() {
    this = TThisParam(result)
    or
    this = TResultParam(result)
    or
    this = TVarParam(_, _, result)
  }

  Type getType() {
    exists(ClassPredicate cp |
      this = TThisParam(cp) and
      result = cp.getDeclaringType()
    )
    or
    exists(Predicate p |
      this = TResultParam(p) and
      result = p.getReturnType()
    )
    or
    exists(VarDecl v |
      this = TVarParam(v, _, _) and
      result = v.getType()
    )
  }

  Location getLocation() {
    exists(ClassPredicate cp |
      this = TThisParam(cp) and
      result = cp.getLocation()
    )
    or
    exists(Predicate p |
      this = TResultParam(p) and
      result = p.getLocation()
    )
    or
    exists(VarDecl v |
      this = TVarParam(v, _, _) and
      result = v.getLocation()
    )
  }
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
  DataFlowCallable getFunction() { none() } // overridden in subclasses

  /**
   * INTERNAL: Do not use. Alternative name for `getFunction`.
   */
  final DataFlowCallable getEnclosingCallable() { result = this.getFunction() }

  /** Gets the type of this node. */
  Type getType() { none() } // overridden in subclasses

  /**
   * Gets the expression corresponding to this node, if any. This predicate
   * only has a result on nodes that represent the value of evaluating the
   * expression. For data flowing _out of_ an expression, like when an
   * argument is passed by reference, use `asDefiningArgument` instead of
   * `asExpr`.
   */
  Expr asExpr() { result = this.(ExprNode).getExpr() }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ParameterNode).getParameter() }

  /** Gets a textual representation of this element. */
  string toString() { none() } // overridden by subclasses

  /** Gets the location of this element. */
  Location getLocation() { none() } // overridden by subclasses

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
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

NewTypeBranch getNewTypeBranch(Expr e) { e.getParent*() = result.getBody() }

/**
 * An expression, viewed as a node in a data flow graph.
 */
class ExprNode extends Node, TExprNode {
  Expr expr;

  ExprNode() { this = TExprNode(expr) }

  override DataFlowCallable getFunction() {
    result.asPredicate() = expr.getEnclosingPredicate()
    or
    result.asNewTypeBranch() = getNewTypeBranch(expr)
    or
    not exists(expr.getEnclosingPredicate()) and
    not exists(getNewTypeBranch(expr)) and
    result.asTopLevel()
  }

  override Type getType() { result = expr.getType() }

  override string toString() { result = expr.toString() }

  override Location getLocation() { result = expr.getLocation() }

  /** Gets the expression corresponding to this node. */
  Expr getExpr() { result = expr }
}

ExprNode exprNode(Expr e) { result.getExpr() = e }

class ParameterNode extends Node, TParameterNode {
  Parameter p;

  ParameterNode() { this = TParameterNode(p) }

  Parameter getParameter() { result = p }

  /**
   * Holds if this node is the parameter of `c` at the specified (zero-based)
   * position. The implicit `this` parameter is considered to have index `-1`.
   */
  predicate isParameterOf(DataFlowCallable pred, int i) {
    p.getPredicate() = pred.asPredicate() and
    p.getIndex() = i
  }

  override DataFlowCallable getFunction() { result.asPredicate() = p.getPredicate() }

  override Type getType() { result = p.getType() }

  override string toString() { result = p.toString() }

  override Location getLocation() { result = p.getLocation() }
}

/** A data flow node that represents a returned value in the called function. */
abstract class ReturnNode extends Node {
  /** Gets the kind of this returned value. */
  abstract ReturnKind getKind();
}

newtype TReturnKind =
  TNormalReturnKind() or
  TParameterOutKind(int i) { any(Parameter p).getIndex() = i }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For C++, this is simply a function return.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this return kind. */
  string toString() {
    this instanceof TNormalReturnKind and
    result = "return"
    or
    exists(int i |
      this = TParameterOutKind(i) and
      result = "out(" + i + ")"
    )
  }
}

/** A data flow node that represents the output of a call at the call site. */
abstract class OutNode extends Node {
  /** Gets the underlying call. */
  abstract Call getCall();
}

class ArgumentOutNode extends Node, TArgumentOutNode, OutNode {
  VarAccess acc;
  Call call;
  int pos;

  ArgumentOutNode() { this = TArgumentOutNode(acc, call, pos) }

  override DataFlowCallable getFunction() {
    result.asPredicate() = acc.getEnclosingPredicate()
    or
    result.asNewTypeBranch() = getNewTypeBranch(acc)
    or
    not exists(acc.getEnclosingPredicate()) and
    not exists(getNewTypeBranch(acc)) and
    result.asTopLevel()
  }

  VarAccess getVarAccess() { result = acc }

  override Type getType() { result = acc.getType() }

  override string toString() { result = acc.toString() + " [out]" }

  override Location getLocation() { result = acc.getLocation() }

  override Call getCall() { result = call }

  int getIndex() { result = pos }
}

class OutParameterNode extends Node, ReturnNode, TOutParameterNode {
  Parameter p;

  OutParameterNode() { this = TOutParameterNode(p) }

  Parameter getParameter() { result = p }

  /**
   * Holds if this node is the parameter of `c` at the specified (zero-based)
   * position. The implicit `this` parameter is considered to have index `-1`.
   */
  predicate isParameterOf(DataFlowCallable pred, int i) {
    p.getPredicate() = pred.asPredicate() and
    p.getIndex() = i
  }

  override DataFlowCallable getFunction() { result.asPredicate() = p.getPredicate() }

  override Type getType() { result = p.getType() }

  override string toString() { result = p.toString() }

  override Location getLocation() { result = p.getLocation() }

  override ReturnKind getKind() { result = TParameterOutKind(p.getIndex()) }
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

  override DataFlowCallable getFunction() { result = getPreUpdateNode().getFunction() }

  override Type getType() { result = getPreUpdateNode().getType() }

  override Location getLocation() { result = getPreUpdateNode().getLocation() }
}

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
cached
predicate localFlowStep(Node nodeFrom, Node nodeTo) { simpleLocalFlowStep(nodeFrom, nodeTo) }

AstNode getParentOfExpr(Expr e) { result = e.getParent() }

Formula getEnclosing(Expr e) { result = getParentOfExpr+(e) }

Formula enlargeScopeStep(Formula f) { result.(Conjunction).getAnOperand() = f }

Formula enlargeScope(Formula f) {
  result = enlargeScopeStep*(f) and not exists(enlargeScopeStep(result))
}

predicate varaccesValue(VarAccess va, VarDecl v, Formula scope) {
  va.getDeclaration() = v and
  scope = enlargeScope(getEnclosing(va))
}

predicate thisValue(ThisAccess ta, Formula scope) { scope = enlargeScope(getEnclosing(ta)) }

predicate resultValue(ResultAccess ra, Formula scope) { scope = enlargeScope(getEnclosing(ra)) }

Formula getParentFormula(Formula f) { f.getParent() = result }

predicate valueStep(Expr e1, Expr e2) {
  exists(VarDecl v, Formula scope |
    varaccesValue(e1, v, scope) and
    varaccesValue(e2, v, scope)
  )
  or
  exists(VarDecl v, Formula f, Select sel |
    getParentFormula*(f) = sel.getWhere() and
    varaccesValue(e1, v, f) and
    sel.getExpr(_) = e2
  )
  or
  exists(Formula scope |
    thisValue(e1, scope) and
    thisValue(e2, scope)
    or
    resultValue(e1, scope) and
    resultValue(e2, scope)
  )
  or
  exists(InlineCast c |
    e1 = c and e2 = c.getBase()
    or
    e2 = c and e1 = c.getBase()
  )
  or
  exists(ComparisonFormula eq |
    eq.getSymbol() = "=" and
    eq.getAnOperand() = e1 and
    eq.getAnOperand() = e2 and
    e1 != e2
  )
}

predicate paramStep(Expr e1, Parameter p2) {
  exists(VarDecl v |
    p2 = TVarParam(v, _, _) and
    varaccesValue(e1, v, _)
  )
  or
  exists(Formula scope |
    p2 = TThisParam(scope.getEnclosingPredicate()) and
    thisValue(e1, scope)
    or
    p2 = TResultParam(scope.getEnclosingPredicate()) and
    resultValue(e1, scope)
  )
}

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  valueStep(nodeFrom.asExpr(), nodeTo.asExpr())
  or
  paramStep(nodeFrom.asExpr(), nodeTo.(OutParameterNode).getParameter())
  or
  valueStep(nodeFrom.(ArgumentOutNode).getVarAccess(), nodeTo.asExpr())
}

predicate foo(Node nodeFrom, Node nodeTo, Select sel) {
  valueStep(nodeFrom.(ArgumentOutNode).getVarAccess(), nodeTo.asExpr()) and
  sel.getExpr(_) = nodeTo.asExpr() and
  nodeFrom.getLocation().getFile().getBaseName() = "OverflowStatic.ql" and
  nodeFrom.getLocation().getStartLine() = 147
  // paramStep(nodeFrom.asExpr(), nodeTo.(OutParameterNode).getParameter()) and
  // nodeFrom.getLocation().getStartLine() = 60 and
  // nodeFrom.getLocation().getFile().getBaseName() = "OverflowStatic.ql"
}

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

private newtype TContent =
  TFieldContent() or
  TCollectionContent() or
  TArrayContent()

/**
 * A description of the way data may be stored inside an object. Examples
 * include instance fields, the contents of a collection object, or the contents
 * of an array.
 */
class Content extends TContent {
  /** Gets a textual representation of this element. */
  abstract string toString();

  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }
}

/** A reference through an instance field. */
class FieldContent extends Content, TFieldContent {
  override string toString() { result = "<field>" }
}

/** A reference through an array. */
private class ArrayContent extends Content, TArrayContent {
  override string toString() { result = "[]" }
}

/** A reference through the contents of some collection-like container. */
private class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "<element>" }
}

class GuardCondition extends Formula {
  GuardCondition() { any(IfFormula ifFormula).getCondition() = this }
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
class BarrierGuard extends GuardCondition {
  /** Override this predicate to hold if this guard validates `e` upon evaluating to `b`. */
  abstract predicate checks(Expr e, boolean b);

  /** Gets a node guarded by this guard. */
  final ExprNode getAGuardedNode() { none() }
}
