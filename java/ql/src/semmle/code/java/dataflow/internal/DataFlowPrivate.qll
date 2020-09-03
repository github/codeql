private import java
private import DataFlowUtil
private import DataFlowImplCommon
private import DataFlowDispatch
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dataflow.TypeFlow

private newtype TReturnKind = TNormalReturnKind()

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For Java, this is simply a method return.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this return kind. */
  string toString() { result = "return" }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  result = call.getNode() and
  kind = TNormalReturnKind()
}

/**
 * A data flow node that occurs as the argument of a call and is passed as-is
 * to the callable. Arguments that are wrapped in an implicit varargs array
 * creation are not included, but the implicitly created array is.
 * Instance arguments are also included.
 */
class ArgumentNode extends Node {
  ArgumentNode() {
    exists(Argument arg | this.asExpr() = arg | not arg.isVararg())
    or
    this instanceof ImplicitVarargsArray
    or
    this = getInstanceArgument(_)
  }

  /**
   * Holds if this argument occurs at the given position in the given call.
   * The instance argument is considered to have index `-1`.
   */
  predicate argumentOf(DataFlowCall call, int pos) {
    exists(Argument arg | this.asExpr() = arg | call = arg.getCall() and pos = arg.getPosition())
    or
    call = this.(ImplicitVarargsArray).getCall() and
    pos = call.getCallee().getNumberOfParameters() - 1
    or
    pos = -1 and this = getInstanceArgument(call)
  }

  /** Gets the call in which this node is an argument. */
  DataFlowCall getCall() { this.argumentOf(result, _) }
}

/** A data flow node that occurs as the result of a `ReturnStmt`. */
class ReturnNode extends ExprNode {
  ReturnNode() { exists(ReturnStmt ret | this.getExpr() = ret.getResult()) }

  /** Gets the kind of this returned value. */
  ReturnKind getKind() { any() }
}

/** A data flow node that represents the output of a call. */
class OutNode extends ExprNode {
  OutNode() { this.getExpr() instanceof MethodAccess }

  /** Gets the underlying call. */
  DataFlowCall getCall() { result = this.getExpr() }
}

/**
 * Holds if data can flow from `node1` to `node2` through a static field.
 */
private predicate staticFieldStep(ExprNode node1, ExprNode node2) {
  exists(Field f, FieldRead fr |
    f.isStatic() and
    f.getAnAssignedValue() = node1.getExpr() and
    fr.getField() = f and
    fr = node2.getExpr() and
    hasNonlocalValue(fr)
  )
}

/**
 * Holds if data can flow from `node1` to `node2` through variable capture.
 */
private predicate variableCaptureStep(Node node1, ExprNode node2) {
  exists(SsaImplicitInit closure, SsaVariable captured |
    closure.captures(captured) and
    node2.getExpr() = closure.getAFirstUse()
  |
    node1.asExpr() = captured.getAUse()
    or
    not exists(captured.getAUse()) and
    exists(SsaVariable capturedDef | capturedDef = captured.getAnUltimateDefinition() |
      capturedDef.(SsaImplicitInit).isParameterDefinition(node1.asParameter()) or
      capturedDef.(SsaExplicitUpdate).getDefiningExpr().(VariableAssign).getSource() =
        node1.asExpr() or
      capturedDef.(SsaExplicitUpdate).getDefiningExpr().(AssignOp) = node1.asExpr()
    )
  )
}

/**
 * Holds if data can flow from `node1` to `node2` through a static field or
 * variable capture.
 */
predicate jumpStep(Node node1, Node node2) {
  staticFieldStep(node1, node2) or
  variableCaptureStep(node1, node2) or
  variableCaptureStep(node1.(PostUpdateNode).getPreUpdateNode(), node2)
}

/**
 * Holds if `fa` is an access to an instance field that occurs as the
 * destination of an assignment of the value `src`.
 */
private predicate instanceFieldAssign(Expr src, FieldAccess fa) {
  exists(AssignExpr a |
    a.getSource() = src and
    a.getDest() = fa and
    fa.getField() instanceof InstanceField
  )
}

private newtype TContent =
  TFieldContent(InstanceField f) or
  TCollectionContent() or
  TArrayContent()

/**
 * A reference contained in an object. Examples include instance fields, the
 * contents of a collection object, or the contents of an array.
 */
class Content extends TContent {
  /** Gets a textual representation of this element. */
  abstract string toString();

  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }
}

private class FieldContent extends Content, TFieldContent {
  InstanceField f;

  FieldContent() { this = TFieldContent(f) }

  InstanceField getField() { result = f }

  override string toString() { result = f.toString() }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    f.getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }
}

private class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "collection" }
}

private class ArrayContent extends Content, TArrayContent {
  override string toString() { result = "array" }
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content f, PostUpdateNode node2) {
  exists(FieldAccess fa |
    instanceFieldAssign(node1.asExpr(), fa) and
    node2.getPreUpdateNode() = getFieldQualifier(fa) and
    f.(FieldContent).getField() = fa.getField()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content f, Node node2) {
  exists(FieldRead fr |
    node1 = getFieldQualifier(fr) and
    fr.getField() = f.(FieldContent).getField() and
    fr = node2.asExpr()
  )
  or
  exists(Record r, Method getter, Field recf, MethodAccess get |
    getter.getDeclaringType() = r and
    recf.getDeclaringType() = r and
    getter.getNumberOfParameters() = 0 and
    getter.getName() = recf.getName() and
    not exists(getter.getBody()) and
    recf = f.(FieldContent).getField() and
    get.getMethod() = getter and
    node1.asExpr() = get.getQualifier() and
    node2.asExpr() = get
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, Content c) {
  n = any(PostUpdateNode pun | storeStep(_, c, pun)).getPreUpdateNode()
}

/**
 * Gets a representative (boxed) type for `t` for the purpose of pruning
 * possible flow. A single type is used for all numeric types to account for
 * numeric conversions, and otherwise the erasure is used.
 */
private DataFlowType getErasedRepr(Type t) {
  exists(Type e | e = t.getErasure() |
    if e instanceof NumericOrCharType
    then result.(BoxedType).getPrimitiveType().getName() = "double"
    else
      if e instanceof BooleanType
      then result.(BoxedType).getPrimitiveType().getName() = "boolean"
      else result = e
  )
  or
  t instanceof NullType and result instanceof TypeObject
}

pragma[noinline]
DataFlowType getNodeType(Node n) { result = getErasedRepr(n.getTypeBound()) }

/** Gets a string representation of a type returned by `getErasedRepr`. */
string ppReprType(Type t) {
  if t.(BoxedType).getPrimitiveType().getName() = "double"
  then result = "Number"
  else result = t.toString()
}

private predicate canContainBool(Type t) {
  t instanceof BooleanType or
  any(BooleanType b).(RefType).getASourceSupertype+() = t
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(Type t1, Type t2) {
  exists(Type e1, Type e2 |
    e1 = getErasedRepr(t1) and
    e2 = getErasedRepr(t2)
  |
    // Because of `getErasedRepr`, `erasedHaveIntersection` is a sufficient
    // compatibility check, but `conContainBool` is kept as a dummy disjunct
    // to get the proper join-order.
    erasedHaveIntersection(e1, e2)
    or
    canContainBool(e1) and canContainBool(e2)
  )
}

/** A node that performs a type cast. */
class CastNode extends ExprNode {
  CastNode() { this.getExpr() instanceof CastExpr }
}

class DataFlowCallable = Callable;

class DataFlowExpr = Expr;

class DataFlowType = RefType;

class DataFlowCall extends Call {
  /** Gets the data flow node corresponding to this call. */
  ExprNode getNode() { result.getExpr() = this }
}

/** Holds if `e` is an expression that always has the same Boolean value `val`. */
private predicate constantBooleanExpr(Expr e, boolean val) {
  e.(CompileTimeConstantExpr).getBooleanValue() = val
  or
  exists(SsaExplicitUpdate v, Expr src |
    e = v.getAUse() and
    src = v.getDefiningExpr().(VariableAssign).getSource() and
    constantBooleanExpr(src, val)
  )
}

/** An argument that always has the same Boolean value. */
private class ConstantBooleanArgumentNode extends ArgumentNode, ExprNode {
  ConstantBooleanArgumentNode() { constantBooleanExpr(this.getExpr(), _) }

  /** Gets the Boolean value of this expression. */
  boolean getBooleanValue() { constantBooleanExpr(this.getExpr(), result) }
}

/**
 * Holds if the node `n` is unreachable when the call context is `call`.
 */
cached
predicate isUnreachableInCall(Node n, DataFlowCall call) {
  exists(
    ExplicitParameterNode paramNode, ConstantBooleanArgumentNode arg, SsaImplicitInit param,
    Guard guard
  |
    // get constant bool argument and parameter for this call
    viableParamArg(call, paramNode, arg) and
    // get the ssa variable definition for this parameter
    param.isParameterDefinition(paramNode.getParameter()) and
    // which is used in a guard
    param.getAUse() = guard and
    // which controls `n` with the opposite value of `arg`
    guard.controls(n.asExpr().getBasicBlock(), arg.getBooleanValue().booleanNot())
  )
}

int accessPathLimit() { result = 5 }

/**
 * Holds if `n` does not require a `PostUpdateNode` as it either cannot be
 * modified or its modification cannot be observed, for example if it is a
 * freshly created object that is not saved in a variable.
 *
 * This predicate is only used for consistency checks.
 */
predicate isImmutableOrUnobservable(Node n) {
  n.getType() instanceof ImmutableType or n instanceof ImplicitVarargsArray
}

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) { none() }
