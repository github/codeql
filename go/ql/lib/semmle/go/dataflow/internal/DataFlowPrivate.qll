private import go
private import DataFlowUtil
private import DataFlowImplCommon
private import ContainerFlow
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.go.dataflow.FlowSummary as FlowSummary
private import semmle.go.dataflow.ExternalFlow
private import codeql.util.Unit
import DataFlowNodes::Private

private newtype TReturnKind =
  MkReturnKind(int i) { exists(SignatureType st | exists(st.getResultType(i))) }

ReturnKind getReturnKind(int i) { result = MkReturnKind(i) }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For Go, this is either a return of a single value
 * or of one of multiple values.
 */
class ReturnKind extends TReturnKind {
  int i;

  ReturnKind() { this = MkReturnKind(i) }

  /** Gets the index of this return value. */
  int getIndex() { result = i }

  /** Gets a textual representation of this return kind. */
  string toString() { result = "return[" + i + "]" }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  exists(DataFlow::CallNode c, int i | c.asExpr() = call and kind = MkReturnKind(i) |
    result = c.getResult(i)
  )
}

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step, not taking function models into account.
 */
predicate basicLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // Instruction -> Instruction
  exists(Expr pred, Expr succ |
    succ.(LogicalBinaryExpr).getAnOperand() = pred or
    succ.(ConversionExpr).getOperand() = pred
  |
    nodeFrom = exprNode(pred) and
    nodeTo = exprNode(succ)
  )
  or
  // Type assertion: if in the context `checked, ok := e.(*Type)` (in which
  // case tuple-extraction instructions exist), flow from `e` to `e.(*Type)[0]`;
  // otherwise flow from `e` to `e.(*Type)`.
  exists(IR::Instruction evalAssert, TypeAssertExpr assert |
    nodeFrom.asExpr() = assert.getExpr() and
    evalAssert = IR::evalExprInstruction(assert) and
    if exists(IR::extractTupleElement(evalAssert, _))
    then nodeTo.asInstruction() = IR::extractTupleElement(evalAssert, 0)
    else nodeTo.asInstruction() = evalAssert
  )
  or
  // Instruction -> SSA
  exists(IR::Instruction pred, SsaExplicitDefinition succ |
    succ.getRhs() = pred and
    nodeFrom = instructionNode(pred) and
    nodeTo = ssaNode(succ)
  )
  or
  // SSA -> SSA
  exists(SsaDefinition pred, SsaPseudoDefinition succ | succ.getAnInput() = pred |
    nodeFrom = ssaNode(pred) and
    nodeTo = ssaNode(succ)
  )
  or
  // SSA -> Instruction
  exists(SsaDefinition pred, IR::Instruction succ |
    succ = pred.getVariable().getAUse() and
    nodeFrom = ssaNode(pred) and
    nodeTo = instructionNode(succ)
  )
  or
  // GlobalFunctionNode -> use
  nodeFrom =
    any(GlobalFunctionNode fn | fn.getFunction() = nodeTo.asExpr().(FunctionName).getTarget())
}

pragma[noinline]
private Field getASparselyUsedChannelTypedField() {
  result.getType() instanceof ChanType and
  count(result.getARead()) = 2
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that loses the
 * calling context. For example, this would happen with flow through a
 * global or static variable.
 */
predicate jumpStep(Node n1, Node n2) {
  exists(ValueEntity v |
    not v instanceof SsaSourceVariable and
    not v instanceof Field and
    (
      any(Write w).writes(v, n1)
      or
      n1.(DataFlow::PostUpdateNode).getPreUpdateNode() = v.getARead()
    ) and
    n2 = v.getARead()
  )
  or
  exists(SsaDefinition pred, SsaDefinition succ |
    succ.(SsaVariableCapture).getSourceVariable() = pred.(SsaExplicitDefinition).getSourceVariable()
  |
    n1 = ssaNode(pred) and
    n2 = ssaNode(succ)
  )
  or
  // If a channel-typed field is referenced exactly once in the context of
  // a send statement and once in a receive expression, assume the two are linked.
  exists(
    Field f, DataFlow::ReadNode recvRead, DataFlow::ReadNode sendRead, RecvExpr re, SendStmt ss
  |
    f = getASparselyUsedChannelTypedField() and
    recvRead = f.getARead() and
    sendRead = f.getARead() and
    recvRead.asExpr() = re.getOperand() and
    sendRead.asExpr() = ss.getChannel() and
    n1.(DataFlow::PostUpdateNode).getPreUpdateNode() = sendRead and
    n2 = recvRead
  )
  or
  FlowSummaryImpl::Private::Steps::summaryJumpStep(n1.(FlowSummaryNode).getSummaryNode(),
    n2.(FlowSummaryNode).getSummaryNode())
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `c`.
 * Thus, `node2` references an object with a content `x` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, ContentSet cs, Node node2) {
  exists(Content c | cs.asOneContent() = c |
    // a write `(*p).f = rhs` is modeled as two store steps: `rhs` is flows into field `f` of `(*p)`,
    // which in turn flows into the pointer content of `p`
    exists(Write w, Field f, DataFlow::Node base, DataFlow::Node rhs | w.writesField(base, f, rhs) |
      node1 = rhs and
      node2.(PostUpdateNode).getPreUpdateNode() = base and
      c = any(DataFlow::FieldContent fc | fc.getField() = f)
      or
      node1 = base and
      node2.(PostUpdateNode).getPreUpdateNode() = node1.(PointerDereferenceNode).getOperand() and
      c = any(DataFlow::PointerContent pc | pc.getPointerType() = node2.getType())
    )
    or
    node1 = node2.(AddressOperationNode).getOperand() and
    c = any(DataFlow::PointerContent pc | pc.getPointerType() = node2.getType())
    or
    containerStoreStep(node1, node2, c)
  )
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1.(FlowSummaryNode).getSummaryNode(), cs,
    node2.(FlowSummaryNode).getSummaryNode())
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `c`.
 * Thus, `node1` references an object with a content `c` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, ContentSet cs, Node node2) {
  exists(Content c | cs.asOneContent() = c |
    node1 = node2.(PointerDereferenceNode).getOperand() and
    c = any(DataFlow::PointerContent pc | pc.getPointerType() = node1.getType())
    or
    exists(FieldReadNode read |
      node2 = read and
      node1 = read.getBase() and
      c = any(DataFlow::FieldContent fc | fc.getField() = read.getField())
    )
    or
    containerReadStep(node1, node2, c)
  )
  or
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(), cs,
    node2.(FlowSummaryNode).getSummaryNode())
  or
  any(ImplicitFieldReadNode ifrn).shouldImplicitlyReadAllFields(node1) and
  cs.isUniversalContent() and
  node1 = node2
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`.
 */
predicate clearsContent(Node n, ContentSet c) {
  // Because our post-update nodes are shared between multiple pre-update
  // nodes, attempting to clear content causes summary stores into arg in
  // particular to malfunction.
  none()
  // c instanceof FieldContent and
  // FlowSummaryImpl::Private::Steps::summaryStoresIntoArg(c, n)
  // or
  // FlowSummaryImpl::Private::Steps::summaryClearsContent(n, c)
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) {
  FlowSummaryImpl::Private::Steps::summaryExpectsContent(n.(FlowSummaryNode).getSummaryNode(), c)
}

predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

predicate localMustFlowStep(Node node1, Node node2) { none() }

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(Node n) { result = TTodoDataFlowType() and exists(n) }

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
  t1 = TTodoDataFlowType() and t2 = TTodoDataFlowType() // stub implementation
}

//////////////////////////////////////////////////////////////////////////////
// Java QL library compatibility wrappers
//////////////////////////////////////////////////////////////////////////////
/** A node that performs a type cast. */
class CastNode extends ExprNode {
  override ConversionExpr expr;
}

/**
 * Holds if `n` should never be skipped over in the `PathGraph` and in path
 * explanations.
 */
predicate neverSkipInPathGraph(Node n) {
  exists(DataFlow::FunctionModel fm | fm.getAnInputNode(_) = n or fm.getAnOutputNode(_) = n)
  or
  exists(TaintTracking::FunctionModel fm | fm.getAnInputNode(_) = n or fm.getAnOutputNode(_) = n)
}

class DataFlowExpr = Expr;

private newtype TDataFlowType = TTodoDataFlowType()

class DataFlowType extends TDataFlowType {
  /** Gets a textual representation of this element. */
  string toString() { result = "" }
}

private newtype TDataFlowCallable =
  TCallable(Callable c) or
  TFileScope(File f) or
  TExternalFileScope() or
  TSummarizedCallable(FlowSummary::SummarizedCallable c)

class DataFlowCallable extends TDataFlowCallable {
  /**
   * Gets the `Callable` corresponding to this `DataFlowCallable`, if any.
   */
  Callable asCallable() { this = TCallable(result) }

  /**
   * Gets the `File` whose root scope corresponds to this `DataFlowCallable`, if any.
   */
  File asFileScope() { this = TFileScope(result) }

  /**
   * Holds if this `DataFlowCallable` is an external file scope.
   */
  predicate isExternalFileScope() { this = TExternalFileScope() }

  /**
   * Gets the `SummarizedCallable` corresponding to this `DataFlowCallable`, if any.
   */
  FlowSummary::SummarizedCallable asSummarizedCallable() { this = TSummarizedCallable(result) }

  /**
   * Gets the type of this callable.
   *
   * If this is a `File` root scope, this has no value.
   */
  SignatureType getType() { result = [this.asCallable(), this.asSummarizedCallable()].getType() }

  /**
   * Gets a string representation of this callable.
   */
  string toString() {
    result = this.asCallable().toString() or
    result = "File scope: " + this.asFileScope().toString() or
    result = "Summary: " + this.asSummarizedCallable().toString()
  }

  /**
   * Holds if this callable is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.asCallable().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) or
    this.asFileScope().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) or
    this.asSummarizedCallable()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets the location of this callable. */
  Location getLocation() {
    result = getCallableLocation(this.asCallable()) or
    result = this.asFileScope().getLocation() or
    result = getCallableLocation(this.asSummarizedCallable())
  }
}

private Location getCallableLocation(Callable c) {
  exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
    c.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
    result.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  )
}

/** A function call relevant for data flow. */
class DataFlowCall extends Expr {
  DataFlow::CallNode call;

  DataFlowCall() { this = call.asExpr() }

  /**
   * Gets the nth argument for this call.
   */
  Node getArgument(int n) { result = call.getArgument(n) }

  /** Gets the data flow node corresponding to this call. */
  ExprNode getNode() { result = call }

  /** Gets the enclosing callable of this call. */
  DataFlowCallable getEnclosingCallable() {
    // NB. At present calls cannot occur inside summarized callables-- this will change if we implement advanced lambda support.
    result.asCallable().getFuncDef() = this.getEnclosingFunction()
    or
    not exists(this.getEnclosingFunction()) and result.asFileScope() = this.getFile()
  }

  /** Gets the location of this call. */
  Location getLocation() { result = super.getLocation() }
}

/** Holds if `e` is an expression that always has the same Boolean value `val`. */
private predicate constantBooleanExpr(Expr e, boolean val) {
  e.getBoolValue() = val
  or
  exists(SsaExplicitDefinition v, Expr src |
    IR::evalExprInstruction(e) = v.getVariable().getAUse() and
    IR::evalExprInstruction(src) = v.getRhs() and
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
 * Returns a guard that will certainly not hold in calling context `call`.
 *
 * In particular it does not hold because it checks that `param` has value `b`, but
 * in context `call` it is known to have value `!b`. Note this is `noinline`d in order
 * to avoid a bad join order in `isUnreachableInCall`.
 */
pragma[noinline]
private ControlFlow::ConditionGuardNode getAFalsifiedGuard(DataFlowCall call) {
  exists(SsaParameterNode param, ConstantBooleanArgumentNode arg |
    // get constant bool argument and parameter for this call
    viableParamArg(call, pragma[only_bind_into](param), pragma[only_bind_into](arg)) and
    // which is used in a guard controlling `n` with the opposite value of `arg`
    result.ensures(param.getAUse(), arg.getBooleanValue().booleanNot())
  )
}

class NodeRegion instanceof BasicBlock {
  string toString() { result = "NodeRegion" }

  predicate contains(Node n) { n.getBasicBlock() = this }
}

/**
 * Holds if the nodes in `nr` are unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) {
  getAFalsifiedGuard(call).dominates(nr)
}

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) {
  c instanceof ArrayContent or c instanceof CollectionContent
}

/**
 * Gets the `i`th argument of call `c`, where the receiver of a method call
 * counts as argument -1.
 */
Node getArgument(CallNode c, int i) {
  result = c.getArgument(i)
  or
  result = c.(MethodCallNode).getReceiver() and
  i = -1
}

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) { n instanceof FlowSummaryNode }

class LambdaCallKind = Unit;

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) { none() }

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() }

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

predicate knownSourceModel(Node source, string model) { sourceNode(source, _, model) }

predicate knownSinkModel(Node sink, string model) { sinkNode(sink, _, model) }

class DataFlowSecondLevelScope = Unit;

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) {
  exists(DataFlowCallable c, int pos |
    p.isParameterOf(c, pos) and
    FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(c.asSummarizedCallable(), pos)
  )
}

/** An approximated `Content`. */
class ContentApprox = Unit;

/** Gets an approximated value for content `c`. */
pragma[inline]
ContentApprox getContentApprox(Content c) { any() }
