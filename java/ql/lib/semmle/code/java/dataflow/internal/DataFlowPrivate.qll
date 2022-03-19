private import java
private import DataFlowUtil
private import DataFlowImplCommon
private import DataFlowDispatch
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.SSA
private import ContainerFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.FlowSummary
private import FlowSummaryImpl as FlowSummaryImpl
private import DataFlowImplConsistency
import DataFlowNodes::Private

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
  result.getCall() = call and
  kind = TNormalReturnKind()
}

/**
 * Holds if data can flow from `node1` to `node2` through a static field.
 */
private predicate staticFieldStep(Node node1, Node node2) {
  exists(Field f |
    f.isStatic() and
    f.getAnAssignedValue() = node1.asExpr() and
    node2.(FieldValueNode).getField() = f
  )
  or
  exists(Field f, FieldRead fr |
    f.isStatic() and
    node1.(FieldValueNode).getField() = f and
    fr.getField() = f and
    fr = node2.asExpr() and
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
  staticFieldStep(node1, node2)
  or
  variableCaptureStep(node1, node2)
  or
  variableCaptureStep(node1.(PostUpdateNode).getPreUpdateNode(), node2)
  or
  any(AdditionalValueStep a).step(node1, node2) and
  node1.getEnclosingCallable() != node2.getEnclosingCallable()
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

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content f, Node node2) {
  exists(FieldAccess fa |
    instanceFieldAssign(node1.asExpr(), fa) and
    node2.(PostUpdateNode).getPreUpdateNode() = getFieldQualifier(fa) and
    f.(FieldContent).getField() = fa.getField()
  )
  or
  f instanceof ArrayContent and arrayStoreStep(node1, node2)
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1, f, node2)
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
  or
  f instanceof ArrayContent and arrayReadStep(node1, node2, _)
  or
  f instanceof CollectionContent and collectionReadStep(node1, node2)
  or
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1, f, node2)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, Content c) {
  exists(FieldAccess fa |
    instanceFieldAssign(_, fa) and
    n = getFieldQualifier(fa) and
    c.(FieldContent).getField() = fa.getField()
  )
  or
  FlowSummaryImpl::Private::Steps::summaryClearsContent(n, c)
}

/**
 * Gets a representative (boxed) type for `t` for the purpose of pruning
 * possible flow. A single type is used for all numeric types to account for
 * numeric conversions, and otherwise the erasure is used.
 */
DataFlowType getErasedRepr(Type t) {
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
DataFlowType getNodeType(Node n) {
  result = getErasedRepr(n.getTypeBound())
  or
  result = FlowSummaryImpl::Private::summaryNodeType(n)
}

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

private newtype TDataFlowCallable =
  TCallable(Callable c) or
  TFieldScope(Field f)

class DataFlowCallable extends TDataFlowCallable {
  Callable asCallable() { this = TCallable(result) }

  Field asFieldScope() { this = TFieldScope(result) }

  RefType getDeclaringType() {
    result = this.asCallable().getDeclaringType() or
    result = this.asFieldScope().getDeclaringType()
  }

  string toString() {
    result = this.asCallable().toString() or
    result = "Field scope: " + this.asFieldScope().toString()
  }

  Location getLocation() {
    result = this.asCallable().getLocation() or
    result = this.asFieldScope().getLocation()
  }
}

class DataFlowExpr = Expr;

class DataFlowType = RefType;

private newtype TDataFlowCall =
  TCall(Call c) or
  TSummaryCall(SummarizedCallable c, Node receiver) {
    FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
  }

/** A call relevant for data flow. Includes both source calls and synthesized calls. */
class DataFlowCall extends TDataFlowCall {
  /** Gets the source (non-synthesized) call this corresponds to, if any. */
  Call asCall() { this = TCall(result) }

  /** Gets the enclosing callable of this call. */
  abstract DataFlowCallable getEnclosingCallable();

  /** Gets a textual representation of this call. */
  abstract string toString();

  /** Gets the location of this call. */
  abstract Location getLocation();

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  final predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/** A source call, that is, a `Call`. */
class SrcCall extends DataFlowCall, TCall {
  Call call;

  SrcCall() { this = TCall(call) }

  override DataFlowCallable getEnclosingCallable() {
    result.asCallable() = call.getEnclosingCallable()
  }

  override string toString() { result = call.toString() }

  override Location getLocation() { result = call.getLocation() }
}

/** A synthesized call inside a `SummarizedCallable`. */
class SummaryCall extends DataFlowCall, TSummaryCall {
  private SummarizedCallable c;
  private Node receiver;

  SummaryCall() { this = TSummaryCall(c, receiver) }

  /** Gets the data flow node that this call targets. */
  Node getReceiver() { result = receiver }

  override DataFlowCallable getEnclosingCallable() { result = c }

  override string toString() { result = "[summary] call to " + receiver + " in " + c }

  override Location getLocation() { result = c.getLocation() }
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
predicate isUnreachableInCall(Node n, DataFlowCall call) {
  exists(
    ExplicitParameterNode paramNode, ConstantBooleanArgumentNode arg, SsaImplicitInit param,
    Guard guard
  |
    // get constant bool argument and parameter for this call
    viableParamArg(call, pragma[only_bind_into](paramNode), arg) and
    // get the ssa variable definition for this parameter
    param.isParameterDefinition(paramNode.getParameter()) and
    // which is used in a guard
    param.getAUse() = guard and
    // which controls `n` with the opposite value of `arg`
    guard
        .controls(n.asExpr().getBasicBlock(),
          pragma[only_bind_into](pragma[only_bind_out](arg.getBooleanValue()).booleanNot()))
  )
}

int accessPathLimit() { result = 5 }

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) {
  c instanceof ArrayContent or c instanceof CollectionContent
}

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  n instanceof SummaryNode
  or
  n.(ParameterNode).isParameterOf(any(SummarizedCallable c).asCallable(), _)
}

class LambdaCallKind = Method; // the "apply" method in the functional interface

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  exists(ClassInstanceExpr func, Interface t, FunctionalInterface interface |
    creation.asExpr() = func and
    func.getAnonymousClass().getAMethod() = c.asCallable() and
    func.getConstructedType().extendsOrImplements+(t) and
    t.getSourceDeclaration() = interface and
    c.asCallable().(Method).overridesOrInstantiates+(pragma[only_bind_into](kind)) and
    pragma[only_bind_into](kind) = interface.getRunMethod().getSourceDeclaration()
  )
}

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  receiver = call.(SummaryCall).getReceiver() and
  getNodeDataFlowType(receiver)
      .getSourceDeclaration()
      .(FunctionalInterface)
      .getRunMethod()
      .getSourceDeclaration() = kind
}

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) {
  FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(p)
}

private class MyConsistencyConfiguration extends Consistency::ConsistencyConfiguration {
  override predicate argHasPostUpdateExclude(ArgumentNode n) {
    n.getType() instanceof ImmutableType or n instanceof ImplicitVarargsArray
  }
}

/**
 * Holds if the the content `c` is a container.
 */
predicate containerContent(Content c) {
  c instanceof ArrayContent or
  c instanceof CollectionContent or
  c instanceof MapKeyContent or
  c instanceof MapValueContent
}
