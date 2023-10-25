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
private import DataFlowNodes
private import codeql.dataflow.VariableCapture as VariableCapture
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
 * Holds if data can flow from `node1` to `node2` through a field.
 */
private predicate fieldStep(Node node1, Node node2) {
  exists(Field f |
    // Taint fields through assigned values only if they're static
    f.isStatic() and
    f.getAnAssignedValue() = node1.asExpr() and
    node2.(FieldValueNode).getField() = f
  )
  or
  exists(Field f, FieldRead fr |
    node1.(FieldValueNode).getField() = f and
    fr.getField() = f and
    fr = node2.asExpr() and
    hasNonlocalValue(fr)
  )
}

private predicate closureFlowStep(Expr e1, Expr e2) {
  simpleAstFlowStep(e1, e2)
  or
  exists(SsaVariable v |
    v.getAUse() = e2 and
    v.getAnUltimateDefinition().(SsaExplicitUpdate).getDefiningExpr().(VariableAssign).getSource() =
      e1
  )
}

private module CaptureInput implements VariableCapture::InputSig {
  private import java as J

  class Location = J::Location;

  class BasicBlock instanceof J::BasicBlock {
    string toString() { result = super.toString() }

    Callable getEnclosingCallable() { result = super.getEnclosingCallable() }

    Location getLocation() { result = super.getLocation() }
  }

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { bbIDominates(result, bb) }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) {
    result = bb.(J::BasicBlock).getABBSuccessor()
  }

  //TODO: support capture of `this` in lambdas
  class CapturedVariable instanceof LocalScopeVariable {
    CapturedVariable() {
      2 <=
        strictcount(J::Callable c |
          c = this.getCallable() or c = this.getAnAccess().getEnclosingCallable()
        )
    }

    string toString() { result = super.toString() }

    Callable getCallable() { result = super.getCallable() }

    Location getLocation() { result = super.getLocation() }
  }

  class CapturedParameter extends CapturedVariable instanceof Parameter { }

  class Expr instanceof J::Expr {
    string toString() { result = super.toString() }

    Location getLocation() { result = super.getLocation() }

    predicate hasCfgNode(BasicBlock bb, int i) { this = bb.(J::BasicBlock).getNode(i) }
  }

  class VariableWrite extends Expr instanceof VariableUpdate {
    CapturedVariable v;

    VariableWrite() { super.getDestVar() = v }

    CapturedVariable getVariable() { result = v }
  }

  class VariableRead extends Expr instanceof VarRead {
    CapturedVariable v;

    VariableRead() { super.getVariable() = v }

    CapturedVariable getVariable() { result = v }
  }

  class ClosureExpr extends Expr instanceof ClassInstanceExpr {
    NestedClass nc;

    ClosureExpr() {
      nc.(AnonymousClass).getClassInstanceExpr() = this
      or
      nc instanceof LocalClass and
      super.getConstructedType().getASourceSupertype*().getSourceDeclaration() = nc
    }

    predicate hasBody(Callable body) { nc.getACallable() = body }

    predicate hasAliasedAccess(Expr f) { closureFlowStep+(this, f) and not closureFlowStep(f, _) }
  }

  class Callable extends J::Callable {
    predicate isConstructor() { this instanceof Constructor }
  }
}

class CapturedVariable = CaptureInput::CapturedVariable;

class CapturedParameter = CaptureInput::CapturedParameter;

module CaptureFlow = VariableCapture::Flow<CaptureInput>;

private CaptureFlow::ClosureNode asClosureNode(Node n) {
  result = n.(CaptureNode).getSynthesizedCaptureNode()
  or
  result.(CaptureFlow::ExprNode).getExpr() = n.asExpr()
  or
  result.(CaptureFlow::ExprPostUpdateNode).getExpr() =
    n.(PostUpdateNode).getPreUpdateNode().asExpr()
  or
  result.(CaptureFlow::ParameterNode).getParameter() = n.asParameter()
  or
  result.(CaptureFlow::ThisParameterNode).getCallable() = n.(InstanceParameterNode).getCallable()
  or
  exprNode(result.(CaptureFlow::MallocNode).getClosureExpr()).(PostUpdateNode).getPreUpdateNode() =
    n
  or
  exists(CaptureInput::VariableWrite write |
    result.(CaptureFlow::VariableWriteSourceNode).getVariableWrite() = write
  |
    n.asExpr() = write.(VariableAssign).getSource()
    or
    n.asExpr() = write.(AssignOp)
  )
}

private predicate captureStoreStep(Node node1, CapturedVariableContent c, Node node2) {
  CaptureFlow::storeStep(asClosureNode(node1), c.getVariable(), asClosureNode(node2))
}

private predicate captureReadStep(Node node1, CapturedVariableContent c, Node node2) {
  CaptureFlow::readStep(asClosureNode(node1), c.getVariable(), asClosureNode(node2))
}

predicate captureValueStep(Node node1, Node node2) {
  CaptureFlow::localFlowStep(asClosureNode(node1), asClosureNode(node2))
}

/**
 * Holds if data can flow from `node1` to `node2` through a field or
 * variable capture.
 */
predicate jumpStep(Node node1, Node node2) {
  fieldStep(node1, node2)
  or
  any(AdditionalValueStep a).step(node1, node2) and
  node1.getEnclosingCallable() != node2.getEnclosingCallable()
  or
  FlowSummaryImpl::Private::Steps::summaryJumpStep(node1.(FlowSummaryNode).getSummaryNode(),
    node2.(FlowSummaryNode).getSummaryNode())
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
predicate storeStep(Node node1, ContentSet f, Node node2) {
  exists(FieldAccess fa |
    instanceFieldAssign(node1.asExpr(), fa) and
    node2.(PostUpdateNode).getPreUpdateNode() = getFieldQualifier(fa) and
    f.(FieldContent).getField() = fa.getField()
  )
  or
  f instanceof ArrayContent and arrayStoreStep(node1, node2)
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1.(FlowSummaryNode).getSummaryNode(), f,
    node2.(FlowSummaryNode).getSummaryNode())
  or
  captureStoreStep(node1, f, node2)
  or
  any(AdditionalStoreStep a).step(node1, f, node2) and
  pragma[only_bind_out](node1.getEnclosingCallable()) =
    pragma[only_bind_out](node2.getEnclosingCallable())
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, ContentSet f, Node node2) {
  exists(FieldRead fr |
    node1 = getFieldQualifier(fr) and
    fr.getField() = f.(FieldContent).getField() and
    fr = node2.asExpr()
  )
  or
  exists(Record r, Method getter, Field recf, MethodCall get |
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
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(), f,
    node2.(FlowSummaryNode).getSummaryNode())
  or
  captureReadStep(node1, f, node2)
  or
  any(AdditionalReadStep a).step(node1, f, node2) and
  pragma[only_bind_out](node1.getEnclosingCallable()) =
    pragma[only_bind_out](node2.getEnclosingCallable())
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) {
  exists(FieldAccess fa |
    instanceFieldAssign(_, fa) and
    n = getFieldQualifier(fa) and
    c.(FieldContent).getField() = fa.getField()
  )
  or
  FlowSummaryImpl::Private::Steps::summaryClearsContent(n.(FlowSummaryNode).getSummaryNode(), c)
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryExpectsContent(n.(FlowSummaryNode).getSummaryNode(), c)
}

/**
 * Gets a representative (boxed) type for `t` for the purpose of pruning
 * possible flow. A single type is used for all numeric types to account for
 * numeric conversions, and otherwise the erasure is used.
 */
RefType getErasedRepr(Type t) {
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

class DataFlowType extends SrcRefType {
  DataFlowType() { this = getErasedRepr(_) }
}

pragma[nomagic]
predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { t1.getASourceSupertype+() = t2 }

pragma[noinline]
DataFlowType getNodeType(Node n) {
  result = getErasedRepr(n.getTypeBound())
  or
  result = FlowSummaryImpl::Private::summaryNodeType(n.(FlowSummaryNode).getSummaryNode())
}

/** Gets a string representation of a type returned by `getErasedRepr`. */
string ppReprType(DataFlowType t) {
  if t.(BoxedType).getPrimitiveType().getName() = "double"
  then result = "Number"
  else result = t.toString()
}

pragma[nomagic]
private predicate compatibleTypes0(DataFlowType t1, DataFlowType t2) {
  erasedHaveIntersection(t1, t2)
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
bindingset[t1, t2]
pragma[inline_late]
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { compatibleTypes0(t1, t2) }

/** A node that performs a type cast. */
class CastNode extends ExprNode {
  CastNode() { this.getExpr() instanceof CastingExpr }
}

private newtype TDataFlowCallable =
  TSrcCallable(Callable c) or
  TSummarizedCallable(SummarizedCallable c) or
  TFieldScope(Field f)

/**
 * A callable or scope enclosing some number of data flow nodes. This can either
 * be a source callable, a synthesized callable for which we have a summary
 * model, or a synthetic scope for a field value node.
 */
class DataFlowCallable extends TDataFlowCallable {
  /** Gets the source callable corresponding to this callable, if any. */
  Callable asCallable() { this = TSrcCallable(result) }

  /** Gets the summary model callable corresponding to this callable, if any. */
  SummarizedCallable asSummarizedCallable() { this = TSummarizedCallable(result) }

  /** Gets the field corresponding to this callable, if it is a field value scope. */
  Field asFieldScope() { this = TFieldScope(result) }

  /** Gets a textual representation of this callable. */
  string toString() {
    result = this.asCallable().toString() or
    result = "Synthetic: " + this.asSummarizedCallable().toString() or
    result = "Field scope: " + this.asFieldScope().toString()
  }

  /** Gets the location of this callable. */
  Location getLocation() {
    result = this.asCallable().getLocation() or
    result = this.asSummarizedCallable().getLocation() or
    result = this.asFieldScope().getLocation()
  }
}

class DataFlowExpr = Expr;

private newtype TDataFlowCall =
  TCall(Call c) or
  TSummaryCall(SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver) {
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
  private FlowSummaryImpl::Private::SummaryNode receiver;

  SummaryCall() { this = TSummaryCall(c, receiver) }

  /** Gets the data flow node that this call targets. */
  FlowSummaryImpl::Private::SummaryNode getReceiver() { result = receiver }

  override DataFlowCallable getEnclosingCallable() { result.asSummarizedCallable() = c }

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

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) {
  c instanceof ArrayContent or c instanceof CollectionContent or c instanceof MapValueContent
}

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) { n instanceof FlowSummaryNode }

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
  receiver.(FlowSummaryNode).getSummaryNode() = call.(SummaryCall).getReceiver() and
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
  or
  CaptureFlow::heuristicAllowInstanceParameterReturnInSelf(p.(InstanceParameterNode).getCallable())
}

/** An approximated `Content`. */
class ContentApprox extends TContentApprox {
  /** Gets a textual representation of this approximated `Content`. */
  string toString() {
    exists(string firstChar |
      this = TFieldContentApprox(firstChar) and
      result = "approximated field " + firstChar
    )
    or
    this = TArrayContentApprox() and
    result = "[]"
    or
    this = TCollectionContentApprox() and
    result = "<element>"
    or
    this = TMapKeyContentApprox() and
    result = "<map.key>"
    or
    this = TMapValueContentApprox() and
    result = "<map.value>"
    or
    this = TSyntheticFieldApproxContent() and
    result = "approximated synthetic field"
  }
}

/** Gets an approximated value for content `c`. */
pragma[nomagic]
ContentApprox getContentApprox(Content c) {
  result = TFieldContentApprox(approximateFieldContent(c))
  or
  c instanceof ArrayContent and result = TArrayContentApprox()
  or
  c instanceof CollectionContent and result = TCollectionContentApprox()
  or
  c instanceof MapKeyContent and result = TMapKeyContentApprox()
  or
  c instanceof MapValueContent and result = TMapValueContentApprox()
  or
  exists(CapturedVariable v |
    c = TCapturedVariableContent(v) and result = TCapturedVariableContentApprox(v)
  )
  or
  c instanceof SyntheticFieldContent and result = TSyntheticFieldApproxContent()
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
