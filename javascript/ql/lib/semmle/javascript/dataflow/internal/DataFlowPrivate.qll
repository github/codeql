private import javascript
private import semmle.javascript.dataflow.internal.CallGraphs
private import semmle.javascript.dataflow.internal.DataFlowNode
private import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps
private import semmle.javascript.dataflow.internal.AdditionalFlowInternal
private import semmle.javascript.dataflow.internal.Contents::Private
private import semmle.javascript.dataflow.internal.VariableCapture
private import semmle.javascript.dataflow.internal.VariableOrThis
private import semmle.javascript.dataflow.internal.sharedlib.DataFlowImplCommon as DataFlowImplCommon
private import semmle.javascript.dataflow.internal.sharedlib.Ssa as Ssa2
private import semmle.javascript.internal.flow_summaries.AllFlowSummaries
private import sharedlib.FlowSummaryImpl as FlowSummaryImpl
private import semmle.javascript.dataflow.internal.FlowSummaryPrivate as FlowSummaryPrivate
private import semmle.javascript.dataflow.FlowSummary as FlowSummary
private import semmle.javascript.dataflow.internal.BarrierGuards

class DataFlowSecondLevelScope = Unit;

private class Node = DataFlow::Node;

class PostUpdateNode = DataFlow::PostUpdateNode;

class SsaUseNode extends DataFlow::Node, TSsaUseNode {
  private ControlFlowNode expr;

  SsaUseNode() { this = TSsaUseNode(expr) }

  cached
  override string toString() { result = "[ssa-use] " + expr.toString() }

  cached
  override StmtContainer getContainer() { result = expr.getContainer() }

  cached
  override Location getLocation() { result = expr.getLocation() }
}

class SsaPhiReadNode extends DataFlow::Node, TSsaPhiReadNode {
  private Ssa2::PhiReadNode phi;

  SsaPhiReadNode() { this = TSsaPhiReadNode(phi) }

  cached
  override string toString() { result = "[ssa-phi-read] " + phi.getSourceVariable().getName() }

  cached
  override StmtContainer getContainer() { result = phi.getSourceVariable().getDeclaringContainer() }

  cached
  override Location getLocation() { result = phi.getLocation() }
}

class SsaInputNode extends DataFlow::Node, TSsaInputNode {
  private Ssa2::SsaInputNode input;

  SsaInputNode() { this = TSsaInputNode(input) }

  cached
  override string toString() {
    result = "[ssa-input] " + input.getDefinitionExt().getSourceVariable().getName()
  }

  cached
  override StmtContainer getContainer() {
    result = input.getDefinitionExt().getSourceVariable().getDeclaringContainer()
  }

  cached
  override Location getLocation() { result = input.getLocation() }
}

class FlowSummaryNode extends DataFlow::Node, TFlowSummaryNode {
  FlowSummaryImpl::Private::SummaryNode getSummaryNode() { this = TFlowSummaryNode(result) }

  /** Gets the summarized callable that this node belongs to. */
  FlowSummaryImpl::Public::SummarizedCallable getSummarizedCallable() {
    result = this.getSummaryNode().getSummarizedCallable()
  }

  cached
  override string toString() { result = this.getSummaryNode().toString() }
}

class FlowSummaryDynamicParameterArrayNode extends DataFlow::Node,
  TFlowSummaryDynamicParameterArrayNode
{
  private FlowSummaryImpl::Public::SummarizedCallable callable;

  FlowSummaryDynamicParameterArrayNode() { this = TFlowSummaryDynamicParameterArrayNode(callable) }

  FlowSummaryImpl::Public::SummarizedCallable getSummarizedCallable() { result = callable }

  cached
  override string toString() { result = "[dynamic parameter array] " + callable }
}

class FlowSummaryIntermediateAwaitStoreNode extends DataFlow::Node,
  TFlowSummaryIntermediateAwaitStoreNode
{
  FlowSummaryImpl::Private::SummaryNode getSummaryNode() {
    this = TFlowSummaryIntermediateAwaitStoreNode(result)
  }

  /** Gets the summarized callable that this node belongs to. */
  FlowSummaryImpl::Public::SummarizedCallable getSummarizedCallable() {
    result = this.getSummaryNode().getSummarizedCallable()
  }

  override string toString() {
    result = this.getSummaryNode().toString() + " [intermediate node for Awaited store]"
  }
}

predicate mentionsExceptionalReturn(FlowSummaryImpl::Public::SummarizedCallable callable) {
  exists(FlowSummaryImpl::Private::SummaryNode node | node.getSummarizedCallable() = callable |
    FlowSummaryImpl::Private::summaryReturnNode(node, MkExceptionalReturnKind())
    or
    FlowSummaryImpl::Private::summaryOutNode(_, node, MkExceptionalReturnKind())
  )
}

/**
 * Exceptional return node in a summarized callable whose summary does not mention `ReturnValue[exception]`.
 *
 * By default, every call inside such a callable will forward their exceptional return to the caller's
 * exceptional return, i.e. exceptions are not caught.
 */
class FlowSummaryDefaultExceptionalReturn extends DataFlow::Node,
  TFlowSummaryDefaultExceptionalReturn
{
  private FlowSummaryImpl::Public::SummarizedCallable callable;

  FlowSummaryDefaultExceptionalReturn() { this = TFlowSummaryDefaultExceptionalReturn(callable) }

  FlowSummaryImpl::Public::SummarizedCallable getSummarizedCallable() { result = callable }

  cached
  override string toString() { result = "[default exceptional return] " + callable }
}

class CaptureNode extends DataFlow::Node, TSynthCaptureNode {
  /** Gets the underlying node from the variable-capture library. */
  VariableCaptureOutput::SynthesizedCaptureNode getNode() {
    this = TSynthCaptureNode(result) and DataFlowImplCommon::forceCachingInSameStage()
  }

  cached
  override StmtContainer getContainer() { result = this.getNode().getEnclosingCallable() }

  cached
  private string toStringInternal() { result = this.getNode().toString() + " [capture node]" }

  override string toString() { result = this.toStringInternal() } // cached in parent class

  cached
  override Location getLocation() { result = this.getNode().getLocation() }
}

class GenericSynthesizedNode extends DataFlow::Node, TGenericSynthesizedNode {
  private AstNode node;
  private string tag;
  private DataFlowCallable container;

  GenericSynthesizedNode() { this = TGenericSynthesizedNode(node, tag, container) }

  override StmtContainer getContainer() { result = container.asSourceCallable() }

  override string toString() { result = "[synthetic node] " + tag }

  override Location getLocation() { result = node.getLocation() }

  string getTag() { result = tag }
}

/**
 * An argument containing an array of all positional arguments with an obvious index, i.e. not affected by a spread argument.
 */
class StaticArgumentArrayNode extends DataFlow::Node, TStaticArgumentArrayNode {
  private InvokeExpr invoke;

  StaticArgumentArrayNode() { this = TStaticArgumentArrayNode(invoke) }

  override StmtContainer getContainer() { result = invoke.getContainer() }

  override string toString() { result = "[static argument array]" }

  override Location getLocation() { result = invoke.getLocation() }
}

/**
 * An argument containing an array of all positional arguments with non-obvious index, i.e. affected by a spread argument.
 *
 * Only exists for call sites with a spread argument.
 */
class DynamicArgumentArrayNode extends DataFlow::Node, TDynamicArgumentArrayNode {
  private InvokeExpr invoke;

  DynamicArgumentArrayNode() { this = TDynamicArgumentArrayNode(invoke) }

  override StmtContainer getContainer() { result = invoke.getContainer() }

  override string toString() { result = "[dynamic argument array]" }

  override Location getLocation() { result = invoke.getLocation() }
}

/**
 * Intermediate node with data that will be stored in `DyanmicArgumentArrayNode`.
 */
class DynamicArgumentStoreNode extends DataFlow::Node, TDynamicArgumentStoreNode {
  private InvokeExpr invoke;
  private Content content;

  DynamicArgumentStoreNode() { this = TDynamicArgumentStoreNode(invoke, content) }

  override StmtContainer getContainer() { result = invoke.getContainer() }

  override string toString() { result = "[dynamic argument store node] content=" + content }

  override Location getLocation() { result = invoke.getLocation() }
}

/**
 * Intermediate node with data that will be stored in the function's rest parameter node.
 */
class RestParameterStoreNode extends DataFlow::Node, TRestParameterStoreNode {
  private Function function;
  private Content content;

  RestParameterStoreNode() { this = TRestParameterStoreNode(function, content) }

  override StmtContainer getContainer() { result = function }

  override string toString() {
    result =
      "[rest parameter store node] '..." + function.getRestParameter().getName() + "' content=" +
        content
  }

  override Location getLocation() { result = function.getRestParameter().getLocation() }
}

/**
 * A parameter containing an array of all positional arguments with an obvious index, i.e. not affected by spread or `.apply()`.
 *
 * These are read and stored in the function's rest parameter and `arguments` array.
 * The node only exists for functions with a rest parameter or which uses the `arguments` array.
 */
class StaticParameterArrayNode extends DataFlow::Node, TStaticParameterArrayNode {
  private Function function;

  StaticParameterArrayNode() { this = TStaticParameterArrayNode(function) }

  override StmtContainer getContainer() { result = function }

  override string toString() { result = "[static parameter array]" }

  override Location getLocation() { result = function.getLocation() }
}

/**
 * A parameter containing an array of all positional argument values with non-obvious index, i.e. affected by spread or `.apply()`.
 *
 * These are read and assigned into regular positional parameters and stored into rest parameters and the `arguments` array.
 */
class DynamicParameterArrayNode extends DataFlow::Node, TDynamicParameterArrayNode {
  private Function function;

  DynamicParameterArrayNode() { this = TDynamicParameterArrayNode(function) }

  override StmtContainer getContainer() { result = function }

  override string toString() { result = "[dynamic parameter array]" }

  override Location getLocation() { result = function.getLocation() }
}

/**
 * Node with taint input from the second argument of `.apply()` and with a store edge back into that same argument.
 *
 * This ensures that if `.apply()` is called with a tainted value (not inside a content) the taint is
 * boxed in an `ArrayElement` content. This is necessary for the target function to propagate the taint.
 */
class ApplyCallTaintNode extends DataFlow::Node, TApplyCallTaintNode {
  private MethodCallExpr apply;

  ApplyCallTaintNode() { this = TApplyCallTaintNode(apply) }

  override StmtContainer getContainer() { result = apply.getContainer() }

  override string toString() { result = "[apply call taint node]" }

  override Location getLocation() { result = apply.getArgument(1).getLocation() }

  MethodCallExpr getMethodCallExpr() { result = apply }

  DataFlow::Node getArrayNode() { result = apply.getArgument(1).flow() }
}

cached
newtype TReturnKind =
  MkNormalReturnKind() or
  MkExceptionalReturnKind()

class ReturnKind extends TReturnKind {
  string toString() {
    this = MkNormalReturnKind() and result = "return"
    or
    this = MkExceptionalReturnKind() and result = "exception"
  }
}

private predicate returnNodeImpl(DataFlow::Node node, ReturnKind kind) {
  node instanceof TFunctionReturnNode and kind = MkNormalReturnKind()
  or
  exists(Function fun |
    node = TExceptionalFunctionReturnNode(fun) and
    kind = MkExceptionalReturnKind() and
    // For async/generators, the exception is caught and wrapped in the returned promise/iterator object.
    // See the models for AsyncAwait and Generator.
    not fun.isAsyncOrGenerator()
  )
  or
  FlowSummaryImpl::Private::summaryReturnNode(node.(FlowSummaryNode).getSummaryNode(), kind)
  or
  node instanceof FlowSummaryDefaultExceptionalReturn and
  kind = MkExceptionalReturnKind()
}

private DataFlow::Node getAnOutNodeImpl(DataFlowCall call, ReturnKind kind) {
  kind = MkNormalReturnKind() and result = call.asOrdinaryCall()
  or
  kind = MkExceptionalReturnKind() and result = call.asOrdinaryCall().getExceptionalReturn()
  or
  kind = MkNormalReturnKind() and result = call.asBoundCall(_)
  or
  kind = MkExceptionalReturnKind() and result = call.asBoundCall(_).getExceptionalReturn()
  or
  kind = MkNormalReturnKind() and result = call.asAccessorCall().(DataFlow::PropRead)
  or
  FlowSummaryImpl::Private::summaryOutNode(call.(SummaryCall).getReceiver(),
    result.(FlowSummaryNode).getSummaryNode(), kind)
  or
  kind = MkExceptionalReturnKind() and
  result.(FlowSummaryDefaultExceptionalReturn).getSummarizedCallable() =
    call.(SummaryCall).getSummarizedCallable()
}

class ReturnNode extends DataFlow::Node {
  ReturnNode() { returnNodeImpl(this, _) }

  ReturnKind getKind() { returnNodeImpl(this, result) }
}

/** A node that receives an output from a call. */
class OutNode extends DataFlow::Node {
  OutNode() { this = getAnOutNodeImpl(_, _) }
}

OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { result = getAnOutNodeImpl(call, kind) }

cached
predicate postUpdatePair(Node pre, Node post) {
  exists(AST::ValueNode expr |
    pre = TValueNode(expr) and
    post = TExprPostUpdateNode(expr)
  )
  or
  exists(NewExpr expr |
    pre = TNewCallThisArgument(expr) and
    post = TValueNode(expr)
  )
  or
  exists(ImplicitThisUse use |
    pre = TImplicitThisUse(use, false) and
    post = TImplicitThisUse(use, true)
  )
  or
  FlowSummaryImpl::Private::summaryPostUpdateNode(post.(FlowSummaryNode).getSummaryNode(),
    pre.(FlowSummaryNode).getSummaryNode())
  or
  VariableCaptureOutput::capturePostUpdateNode(getClosureNode(post), getClosureNode(pre))
}

class CastNode extends DataFlow::Node {
  CastNode() { none() }
}

cached
newtype TDataFlowCallable =
  MkSourceCallable(StmtContainer container) or
  MkLibraryCallable(LibraryCallable callable)

/**
 * A callable entity. This is a wrapper around either a `StmtContainer` or a `LibraryCallable`.
 */
class DataFlowCallable extends TDataFlowCallable {
  /** Gets a string representation of this callable. */
  string toString() {
    result = this.asSourceCallable().toString()
    or
    result = this.asLibraryCallable()
  }

  /** Gets the location of this callable, if it is present in the source code. */
  Location getLocation() { result = this.asSourceCallable().getLocation() }

  /** Gets the corresponding `StmtContainer` if this is a source callable. */
  StmtContainer asSourceCallable() { this = MkSourceCallable(result) }

  /** Gets the corresponding `StmtContainer` if this is a source callable. */
  pragma[nomagic]
  StmtContainer asSourceCallableNotExterns() {
    this = MkSourceCallable(result) and
    not result.inExternsFile()
  }

  /** Gets the corresponding `LibraryCallable` if this is a library callable. */
  LibraryCallable asLibraryCallable() { this = MkLibraryCallable(result) }

  int totalorder() {
    result = TotalOrdering::astNodeId(this.asSourceCallable()).bitShiftLeft(1)
    or
    result = TotalOrdering::libraryCallableId(this.asLibraryCallable()).bitShiftLeft(1) + 1
  }
}

/** A callable defined in library code, identified by a unique string. */
abstract class LibraryCallable extends string {
  bindingset[this]
  LibraryCallable() { any() }

  /** Gets a call to this library callable. */
  DataFlow::InvokeNode getACall() { none() }

  /** Same as `getACall()` except this does not depend on the call graph or API graph. */
  DataFlow::InvokeNode getACallSimple() { none() }
}

/** Internal subclass of `LibraryCallable`, whose member predicates should not be visible on `SummarizedCallable`. */
abstract class LibraryCallableInternal extends LibraryCallable {
  bindingset[this]
  LibraryCallableInternal() { any() }

  /**
   * Gets a call to this library callable.
   *
   * Same as `getACall()` but is evaluated later and may depend negatively on `getACall()`.
   */
  DataFlow::InvokeNode getACallStage2() { none() }
}

private predicate isParameterNodeImpl(Node p, DataFlowCallable c, ParameterPosition pos) {
  exists(Parameter parameter |
    parameter = c.asSourceCallable().(Function).getParameter(pos.asPositional()) and
    not parameter.isRestParameter() and
    p = TValueNode(parameter)
  )
  or
  pos.isThis() and p = TThisNode(c.asSourceCallable().(Function))
  or
  pos.isFunctionSelfReference() and p = TFunctionSelfReferenceNode(c.asSourceCallable())
  or
  pos.isStaticArgumentArray() and p = TStaticParameterArrayNode(c.asSourceCallable())
  or
  pos.isDynamicArgumentArray() and p = TDynamicParameterArrayNode(c.asSourceCallable())
  or
  exists(FlowSummaryNode summaryNode |
    summaryNode = p and
    FlowSummaryImpl::Private::summaryParameterNode(summaryNode.getSummaryNode(), pos) and
    c.asLibraryCallable() = summaryNode.getSummarizedCallable()
  )
  or
  exists(FlowSummaryImpl::Public::SummarizedCallable callable |
    c.asLibraryCallable() = callable and
    pos.isDynamicArgumentArray() and
    p = TFlowSummaryDynamicParameterArrayNode(callable)
  )
}

predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
  isParameterNodeImpl(p, c, pos)
}

private predicate isArgumentNodeImpl(Node n, DataFlowCall call, ArgumentPosition pos) {
  n = call.asOrdinaryCall().getArgument(pos.asPositional())
  or
  exists(InvokeExpr invoke |
    call.asOrdinaryCall() = TReflectiveCallNode(invoke, "apply") and
    pos.isDynamicArgumentArray() and
    n = TValueNode(invoke.getArgument(1))
  )
  or
  pos.isThis() and n = call.asOrdinaryCall().(DataFlow::CallNode).getReceiver()
  or
  exists(DataFlow::PartialInvokeNode invoke, DataFlow::Node callback |
    call = MkPartialCall(invoke, callback) and
    invoke.isPartialArgument(callback, n, pos.asPositional())
  )
  or
  pos.isThis() and n = call.asPartialCall().getBoundReceiver()
  or
  exists(int boundArgs |
    n = call.asBoundCall(boundArgs).getArgument(pos.asPositional() - boundArgs)
  )
  or
  pos.isFunctionSelfReference() and n = call.asOrdinaryCall().getCalleeNode()
  or
  pos.isFunctionSelfReference() and n = call.asImpliedLambdaCall().flow()
  or
  exists(Function fun |
    call.asImpliedLambdaCall() = fun and
    CallGraph::impliedReceiverStep(n, TThisNode(fun)) and
    sameContainerAsEnclosingContainer(n, fun) and
    pos.isThis()
  )
  or
  pos.isThis() and n = TNewCallThisArgument(call.asOrdinaryCall().asExpr())
  or
  pos.isThis() and
  n = TImplicitThisUse(call.asOrdinaryCall().asExpr().(SuperCall).getCallee(), false)
  or
  // receiver of accessor call
  pos.isThis() and n = call.asAccessorCall().getBase()
  or
  // argument to setter
  pos.asPositional() = 0 and n = call.asAccessorCall().(DataFlow::PropWrite).getRhs()
  or
  FlowSummaryImpl::Private::summaryArgumentNode(call.(SummaryCall).getReceiver(),
    n.(FlowSummaryNode).getSummaryNode(), pos)
  or
  exists(InvokeExpr invoke | call.asOrdinaryCall() = TValueNode(invoke) |
    n = TStaticArgumentArrayNode(invoke) and
    pos.isStaticArgumentArray()
    or
    n = TDynamicArgumentArrayNode(invoke) and
    pos.isDynamicArgumentArray()
  )
}

predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
  isArgumentNodeImpl(n, call, pos)
}

DataFlowCallable nodeGetEnclosingCallable(Node node) {
  result.asSourceCallable() = node.getContainer()
  or
  result.asLibraryCallable() = node.(FlowSummaryNode).getSummarizedCallable()
  or
  result.asLibraryCallable() = node.(FlowSummaryDynamicParameterArrayNode).getSummarizedCallable()
  or
  result.asLibraryCallable() = node.(FlowSummaryIntermediateAwaitStoreNode).getSummarizedCallable()
  or
  result.asLibraryCallable() = node.(FlowSummaryDefaultExceptionalReturn).getSummarizedCallable()
  or
  node = TGenericSynthesizedNode(_, _, result)
}

newtype TDataFlowType =
  TFunctionType(Function f) or
  TAnyType()

class DataFlowType extends TDataFlowType {
  string toDebugString() {
    this instanceof TFunctionType and
    result =
      "TFunctionType(" + this.asFunction().toString() + ") at line " +
        this.asFunction().getLocation().getStartLine()
    or
    this instanceof TAnyType and result = "TAnyType"
  }

  string toString() {
    result = "" // Must be the empty string to prevent this from showing up in path explanations
  }

  Function asFunction() { this = TFunctionType(result) }
}

/**
 * Holds if `t1` is strictly stronger than `t2`.
 */
predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) {
  t1 instanceof TFunctionType and t2 = TAnyType()
}

private DataFlowType getPreciseType(Node node) {
  exists(Function f |
    (node = TValueNode(f) or node = TFunctionSelfReferenceNode(f)) and
    result = TFunctionType(f)
  )
  or
  result = getPreciseType(node.getImmediatePredecessor())
  or
  result = getPreciseType(node.(PostUpdateNode).getPreUpdateNode())
}

DataFlowType getNodeType(Node node) {
  result = getPreciseType(node)
  or
  not exists(getPreciseType(node)) and
  result = TAnyType()
}

predicate nodeIsHidden(Node node) {
  // Skip phi, refinement, and capture nodes
  node.(DataFlow::SsaDefinitionNode).getSsaVariable().getDefinition() instanceof
    SsaImplicitDefinition
  or
  // Skip SSA definition of parameter as its location coincides with the parameter node
  node = DataFlow::ssaDefinitionNode(Ssa::definition(any(SimpleParameter p)))
  or
  // Skip to the top of big left-leaning string concatenation trees.
  node = any(AddExpr add).flow() and
  node = any(AddExpr add).getAnOperand().flow()
  or
  // Skip the exceptional return on functions, as this highlights the entire function.
  node = any(DataFlow::FunctionNode f).getExceptionalReturn()
  or
  // Skip the special return node for functions, as this highlights the entire function (and the returned expr is the previous node).
  node = any(DataFlow::FunctionNode f).getReturnNode()
  or
  // Skip the synthetic 'this' node, as a ThisExpr will be the next node anyway
  node = DataFlow::thisNode(_)
  or
  // Skip captured variable nodes as the successor will be a use of that variable anyway.
  node = DataFlow::capturedVariableNode(_)
  or
  node instanceof DataFlow::FunctionSelfReferenceNode
  or
  node instanceof FlowSummaryNode
  or
  node instanceof FlowSummaryDynamicParameterArrayNode
  or
  node instanceof FlowSummaryIntermediateAwaitStoreNode
  or
  node instanceof FlowSummaryDefaultExceptionalReturn
  or
  node instanceof CaptureNode
  or
  // Hide function expressions, as capture-flow causes them to appear in unhelpful ways
  // In the future we could hide PathNodes with a capture content as the head of its access path.
  node.asExpr() instanceof Function
  or
  // Also hide post-update nodes for function expressions
  node.(DataFlow::ExprPostUpdateNode).getExpr() instanceof Function
  or
  node instanceof GenericSynthesizedNode
  or
  node instanceof StaticArgumentArrayNode
  or
  node instanceof DynamicArgumentArrayNode
  or
  node instanceof DynamicArgumentStoreNode
  or
  node instanceof StaticParameterArrayNode
  or
  node instanceof DynamicParameterArrayNode
  or
  node instanceof RestParameterStoreNode
  or
  node instanceof SsaUseNode
  or
  node instanceof SsaPhiReadNode
  or
  node instanceof SsaInputNode
}

predicate neverSkipInPathGraph(Node node) {
  // Include the left-hand side of assignments
  node = DataFlow::lvalueNode(_)
  or
  // Include the return-value expression
  node.asExpr() = any(Function f).getAReturnedExpr()
  or
  // Include calls (which may have been modelled as steps)
  node.asExpr() instanceof InvokeExpr
  or
  // Include references to a variable
  node.asExpr() instanceof VarRef
}

string ppReprType(DataFlowType t) { none() }

pragma[inline]
private predicate compatibleTypesNonSymRefl(DataFlowType t1, DataFlowType t2) {
  t1 != TAnyType() and
  t2 = TAnyType()
}

pragma[inline]
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
  t1 = t2
  or
  compatibleTypesNonSymRefl(t1, t2)
  or
  compatibleTypesNonSymRefl(t2, t1)
}

predicate forceHighPrecision(Content c) { none() }

newtype TContentApprox =
  TApproxPropertyContent() or
  TApproxMapKey() or
  TApproxMapValue() or
  TApproxSetElement() or
  TApproxIteratorElement() or
  TApproxIteratorError() or
  TApproxPromiseValue() or
  TApproxPromiseError() or
  TApproxCapturedContent()

class ContentApprox extends TContentApprox {
  string toString() {
    this = TApproxPropertyContent() and result = "TApproxPropertyContent"
    or
    this = TApproxMapKey() and result = "TApproxMapKey"
    or
    this = TApproxMapValue() and result = "TApproxMapValue"
    or
    this = TApproxSetElement() and result = "TApproxSetElement"
    or
    this = TApproxIteratorElement() and result = "TApproxIteratorElement"
    or
    this = TApproxIteratorError() and result = "TApproxIteratorError"
    or
    this = TApproxPromiseValue() and result = "TApproxPromiseValue"
    or
    this = TApproxPromiseError() and result = "TApproxPromiseError"
    or
    this = TApproxCapturedContent() and result = "TApproxCapturedContent"
  }
}

pragma[inline]
ContentApprox getContentApprox(Content c) {
  c instanceof MkPropertyContent and result = TApproxPropertyContent()
  or
  c instanceof MkArrayElementUnknown and result = TApproxPropertyContent()
  or
  c instanceof MkMapKey and result = TApproxMapKey()
  or
  c instanceof MkMapValueWithKnownKey and result = TApproxMapValue()
  or
  c instanceof MkMapValueWithUnknownKey and result = TApproxMapValue()
  or
  c instanceof MkSetElement and result = TApproxSetElement()
  or
  c instanceof MkIteratorElement and result = TApproxIteratorElement()
  or
  c instanceof MkIteratorError and result = TApproxIteratorError()
  or
  c instanceof MkPromiseValue and result = TApproxPromiseValue()
  or
  c instanceof MkPromiseError and result = TApproxPromiseError()
  or
  c instanceof MkCapturedContent and result = TApproxCapturedContent()
}

cached
private newtype TDataFlowCall =
  MkOrdinaryCall(DataFlow::InvokeNode node) or
  MkPartialCall(DataFlow::PartialInvokeNode node, DataFlow::Node callback) {
    callback = node.getACallbackNode()
  } or
  MkBoundCall(DataFlow::InvokeNode node, int boundArgs) {
    FlowSteps::callsBound(node, _, boundArgs)
  } or
  MkAccessorCall(DataFlow::PropRef node) {
    // Some PropRefs can't result in an accessor call, such as Object.defineProperty.
    // Restrict to PropRefs that can result in an accessor call.
    node = TValueNode(any(PropAccess p)) or
    node = TPropNode(any(PropertyPattern p))
  } or
  MkImpliedLambdaCall(Function f) {
    VariableCaptureConfig::captures(f, _) or CallGraph::impliedReceiverStep(_, TThisNode(f))
  } or
  MkSummaryCall(
    FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
  ) {
    FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
  }

private module TotalOrdering {
  private predicate astNodeRefl(AstNode x, AstNode y) { x = y }

  int astNodeId(AstNode n) = equivalenceRelation(astNodeRefl/2)(n, result)

  predicate dataFlowNodeId(DataFlow::Node node, int cls, int content) {
    exists(AstNode n |
      node = TValueNode(n) and cls = 1 and content = astNodeId(n)
      or
      node = TReflectiveCallNode(n, _) and cls = 2 and content = astNodeId(n)
    )
  }

  predicate callId(DataFlowCall call, int cls, int child, int extra) {
    exists(DataFlow::Node node |
      call = MkOrdinaryCall(node) and dataFlowNodeId(node, cls - 1000, child) and extra = 0
      or
      call = MkPartialCall(node, _) and dataFlowNodeId(node, cls - 2000, child) and extra = 0
      or
      call = MkBoundCall(node, extra) and dataFlowNodeId(node, cls - 3000, child)
      or
      call = MkAccessorCall(node) and dataFlowNodeId(node, cls - 4000, child) and extra = 0
    )
    or
    exists(Function f |
      call = MkImpliedLambdaCall(f) and cls = 5000 and child = astNodeId(f) and extra = 0
    )
    or
    exists(
      FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
    |
      call = MkSummaryCall(c, receiver) and
      cls = 6000 and
      c = rank[child](FlowSummaryImpl::Public::SummarizedCallable cs) and
      extra = 0
    )
  }

  int libraryCallableId(LibraryCallable callable) { callable = rank[result](LibraryCallable c) }
}

class DataFlowCall extends TDataFlowCall {
  DataFlowCallable getEnclosingCallable() { none() } // Overridden in subclass

  string toString() { none() } // Overridden in subclass

  DataFlow::InvokeNode asOrdinaryCall() { this = MkOrdinaryCall(result) }

  DataFlow::PropRef asAccessorCall() { this = MkAccessorCall(result) }

  DataFlow::PartialInvokeNode asPartialCall() { this = MkPartialCall(result, _) }

  DataFlow::InvokeNode asBoundCall(int boundArgs) { this = MkBoundCall(result, boundArgs) }

  Function asImpliedLambdaCall() { this = MkImpliedLambdaCall(result) }

  predicate isSummaryCall(
    FlowSummaryImpl::Public::SummarizedCallable enclosingCallable,
    FlowSummaryImpl::Private::SummaryNode receiver
  ) {
    this = MkSummaryCall(enclosingCallable, receiver)
  }

  Location getLocation() { none() } // Overridden in subclass

  int totalorder() {
    this =
      rank[result](DataFlowCall call, int x, int y, int z |
        TotalOrdering::callId(call, x, y, z)
      |
        call order by x, y, z
      )
  }
}

private class OrdinaryCall extends DataFlowCall, MkOrdinaryCall {
  private DataFlow::InvokeNode node;

  OrdinaryCall() { this = MkOrdinaryCall(node) }

  DataFlow::InvokeNode getNode() { result = node }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = node.getContainer()
  }

  override string toString() { result = node.toString() }

  override Location getLocation() { result = node.getLocation() }
}

private class PartialCall extends DataFlowCall, MkPartialCall {
  private DataFlow::PartialInvokeNode node;
  private DataFlow::Node callback;

  PartialCall() { this = MkPartialCall(node, callback) }

  DataFlow::PartialInvokeNode getNode() { result = node }

  DataFlow::Node getCallback() { result = callback }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = node.getContainer()
  }

  override string toString() { result = node.toString() + " (as partial invocation)" }

  override Location getLocation() { result = node.getLocation() }
}

private class BoundCall extends DataFlowCall, MkBoundCall {
  private DataFlow::InvokeNode node;
  private int boundArgs;

  BoundCall() { this = MkBoundCall(node, boundArgs) }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = node.getContainer()
  }

  override string toString() {
    result = node.toString() + " (as call with " + boundArgs + " bound arguments)"
  }

  override Location getLocation() { result = node.getLocation() }
}

private class AccessorCall extends DataFlowCall, MkAccessorCall {
  private DataFlow::PropRef ref;

  AccessorCall() { this = MkAccessorCall(ref) }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = ref.getContainer()
  }

  override string toString() { result = ref.toString() + " (as accessor call)" }

  override Location getLocation() { result = ref.getLocation() }
}

class SummaryCall extends DataFlowCall, MkSummaryCall {
  private FlowSummaryImpl::Public::SummarizedCallable enclosingCallable;
  private FlowSummaryImpl::Private::SummaryNode receiver;

  SummaryCall() { this = MkSummaryCall(enclosingCallable, receiver) }

  override DataFlowCallable getEnclosingCallable() {
    result.asLibraryCallable() = enclosingCallable
  }

  override string toString() {
    result = "[summary] call to " + receiver + " in " + enclosingCallable
  }

  /** Gets the receiver node. */
  FlowSummaryImpl::Private::SummaryNode getReceiver() { result = receiver }

  FlowSummaryImpl::Public::SummarizedCallable getSummarizedCallable() { result = enclosingCallable }
}

/**
 * A call that invokes a lambda with nothing but its self-reference node.
 *
 * This is to help ensure captured variables can flow into the lambda in cases where
 * we can't find its call sites.
 */
private class ImpliedLambdaCall extends DataFlowCall, MkImpliedLambdaCall {
  private Function function;

  ImpliedLambdaCall() { this = MkImpliedLambdaCall(function) }

  override string toString() { result = "[implied lambda call] " + function }

  override Location getLocation() { result = function.getLocation() }

  override DataFlowCallable getEnclosingCallable() {
    result.asSourceCallable() = function.getEnclosingContainer()
  }
}

private int getMaxArity() {
  // TODO: account for flow summaries
  result =
    max(int n |
      n = any(InvokeExpr e).getNumArgument() or
      n = any(Function f).getNumParameter() or
      n = 10
    )
}

cached
newtype TParameterPosition =
  MkPositionalParameter(int n) { n = [0 .. getMaxArity()] } or
  MkPositionalLowerBound(int n) { n = [0 .. getMaxArity()] } or
  MkThisParameter() or
  MkFunctionSelfReferenceParameter() or
  MkStaticArgumentArray() or
  MkDynamicArgumentArray()

class ParameterPosition extends TParameterPosition {
  predicate isPositionalExact() { this instanceof MkPositionalParameter }

  predicate isPositionalLowerBound() { this instanceof MkPositionalLowerBound }

  predicate isPositionalLike() { this.isPositionalExact() or this.isPositionalLowerBound() }

  int asPositional() { this = MkPositionalParameter(result) }

  int asPositionalLowerBound() { this = MkPositionalLowerBound(result) }

  predicate isThis() { this = MkThisParameter() }

  predicate isFunctionSelfReference() { this = MkFunctionSelfReferenceParameter() }

  predicate isStaticArgumentArray() { this = MkStaticArgumentArray() }

  predicate isDynamicArgumentArray() { this = MkDynamicArgumentArray() }

  string toString() {
    result = this.asPositional().toString()
    or
    result = this.asPositionalLowerBound().toString() + ".."
    or
    this.isThis() and result = "this"
    or
    this.isFunctionSelfReference() and result = "function"
    or
    this.isStaticArgumentArray() and result = "static-argument-array"
    or
    this.isDynamicArgumentArray() and result = "dynamic-argument-array"
  }
}

class ArgumentPosition extends ParameterPosition { }

class DataFlowExpr = Expr;

Node exprNode(DataFlowExpr expr) { result = DataFlow::exprNode(expr) }

pragma[nomagic]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos = apos
  or
  apos.asPositional() >= ppos.asPositionalLowerBound()
  or
  ppos.asPositional() >= apos.asPositionalLowerBound()
  //
  // Note: for now, there is no need to match lower bounds agaist lower bounds since we
  // are only using these in cases where either the call or callee is generated by a flow summary.
}

pragma[inline]
DataFlowCallable viableCallable(DataFlowCall node) {
  // Note: we never include call edges externs here, as it negatively affects the field-flow branch limit,
  // particularly when the call can also target a flow summary.
  result.asSourceCallableNotExterns() = node.asOrdinaryCall().getACallee()
  or
  result.asSourceCallableNotExterns() =
    node.(PartialCall).getCallback().getAFunctionValue().getFunction()
  or
  exists(DataFlow::InvokeNode invoke, int boundArgs |
    invoke = node.asBoundCall(boundArgs) and
    FlowSteps::callsBound(invoke, result.asSourceCallableNotExterns(), boundArgs)
  )
  or
  result.asSourceCallableNotExterns() = node.asAccessorCall().getAnAccessorCallee().getFunction()
  or
  exists(LibraryCallable callable |
    result = MkLibraryCallable(callable) and
    node.asOrdinaryCall() =
      [
        callable.getACall(), callable.getACallSimple(),
        callable.(LibraryCallableInternal).getACallStage2()
      ]
  )
  or
  result.asSourceCallableNotExterns() = node.asImpliedLambdaCall()
}

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context.
 */
predicate mayBenefitFromCallContext(DataFlowCall call) { none() }

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }

bindingset[node, fun]
pragma[inline_late]
private predicate sameContainerAsEnclosingContainer(Node node, Function fun) {
  node.getContainer() = fun.getEnclosingContainer()
}

abstract private class BarrierGuardAdapter extends DataFlow::Node {
  // Note: avoid depending on DataFlow::FlowLabel here as it will cause these barriers to be re-evaluated
  predicate blocksExpr(boolean outcome, Expr e) { none() }
}

deprecated private class BarrierGuardAdapterSubclass extends BarrierGuardAdapter instanceof DataFlow::AdditionalBarrierGuardNode
{
  override predicate blocksExpr(boolean outcome, Expr e) { super.blocks(outcome, e) }
}

/**
 * Holds if `node` should be a barrier in all data flow configurations due to custom subclasses
 * of `AdditionalBarrierGuardNode`.
 *
 * The standard library contains no subclasses of that class; this is for backwards compatibility only.
 */
pragma[nomagic]
private predicate legacyBarrier(DataFlow::Node node) {
  node = MakeBarrierGuard<BarrierGuardAdapter>::getABarrierNode()
}

/**
 * Holds if `node` should be removed from the local data flow graph, for compatibility with legacy code.
 */
pragma[nomagic]
private predicate isBlockedLegacyNode(Node node) {
  // Ignore captured variable nodes for those variables that are handled by the captured-variable library.
  // Note that some variables, such as top-level variables, are still modelled with these nodes (which will result in jump steps).
  exists(LocalVariable variable |
    node = TCapturedVariableNode(variable) and
    variable = any(VariableCaptureConfig::CapturedVariable v).asLocalVariable()
  )
  or
  legacyBarrier(node)
}

/**
 * Holds if `thisNode` represents a value of `this` that is being tracked by the
 * variable capture library.
 *
 * In this case we need to suppress the default flow steps between `thisNode` and
 * the `ThisExpr` nodes; especially those that would become jump steps.
 *
 * Note that local uses of `this` are sometimes tracked by the local SSA library, but we should
 * not block local def-use flow, since we only switch to use-use flow after a post-update.
 */
pragma[nomagic]
private predicate isThisNodeTrackedByVariableCapture(DataFlow::ThisNode thisNode) {
  exists(StmtContainer container | thisNode = TThisNode(container) |
    any(VariableCaptureConfig::CapturedVariable v).asThisContainer() = container
  )
}

/**
 * Holds if there should be flow from `postUpdate` to `target` because of a variable/this value
 * that is captured but not tracked precisely by the variable-capture library.
 */
pragma[nomagic]
private predicate imprecisePostUpdateStep(DataFlow::PostUpdateNode postUpdate, DataFlow::Node target) {
  exists(LocalVariableOrThis var, DataFlow::Node use |
    // 'var' is captured but not tracked precisely
    var.isCaptured() and
    not var instanceof VariableCaptureConfig::CapturedVariable and
    (
      use = TValueNode(var.asLocalVariable().getAnAccess())
      or
      use = TValueNode(var.getAThisExpr())
      or
      use = TImplicitThisUse(var.getAThisUse(), false)
    ) and
    postUpdate.getPreUpdateNode() = use and
    target = use.getALocalSource()
  )
}

/**
 * Holds if there is a value-preserving steps `node1` -> `node2` that might
 * be cross function boundaries.
 */
private predicate valuePreservingStep(Node node1, Node node2) {
  node1.getASuccessor() = node2 and
  not isBlockedLegacyNode(node1) and
  not isBlockedLegacyNode(node2) and
  not isThisNodeTrackedByVariableCapture(node1)
  or
  imprecisePostUpdateStep(node1, node2)
  or
  FlowSteps::propertyFlowStep(node1, node2)
  or
  FlowSteps::globalFlowStep(node1, node2)
  or
  node2 = FlowSteps::getThrowTarget(node1)
  or
  FlowSummaryPrivate::Steps::summaryLocalStep(node1.(FlowSummaryNode).getSummaryNode(),
    node2.(FlowSummaryNode).getSummaryNode(), true, _) // TODO: preserve 'model'
}

predicate knownSourceModel(Node sink, string model) { none() }

predicate knownSinkModel(Node sink, string model) { none() }

private predicate samePhi(SsaPhiNode legacyPhi, Ssa2::PhiNode newPhi) {
  exists(BasicBlock bb, LocalVariableOrThis v |
    newPhi.definesAt(v, bb, _) and
    legacyPhi.definesAt(bb, _, v.asLocalVariable())
  )
}

cached
Node getNodeFromSsa2(Ssa2::Node node) {
  result = TSsaUseNode(node.(Ssa2::ExprNode).getExpr())
  or
  result = TExprPostUpdateNode(node.(Ssa2::ExprPostUpdateNode).getExpr())
  or
  exists(ImplicitThisUse use |
    node.(Ssa2::ExprPostUpdateNode).getExpr() = use and
    result = TImplicitThisUse(use, true)
  )
  or
  result = TSsaPhiReadNode(node.(Ssa2::SsaDefinitionExtNode).getDefinitionExt())
  or
  result = TSsaInputNode(node.(Ssa2::SsaInputNode))
  or
  exists(SsaPhiNode legacyPhi, Ssa2::PhiNode ssaPhi |
    node.(Ssa2::SsaDefinitionExtNode).getDefinitionExt() = ssaPhi and
    samePhi(legacyPhi, ssaPhi) and
    result = TSsaDefNode(legacyPhi)
  )
}

private predicate useUseFlow(Node node1, Node node2) {
  exists(Ssa2::DefinitionExt def, Ssa2::Node ssa1, Ssa2::Node ssa2 |
    Ssa2::localFlowStep(def, ssa1, ssa2, _) and
    node1 = getNodeFromSsa2(ssa1) and
    node2 = getNodeFromSsa2(ssa2) and
    not node1.getTopLevel().isExterns()
  )
  or
  exists(Expr use |
    node1 = TSsaUseNode(use) and
    node2 = TValueNode(use)
  )
  or
  exists(ImplicitThisUse use |
    node1 = TSsaUseNode(use) and
    node2 = TImplicitThisUse(use, false)
  )
}

predicate simpleLocalFlowStep(Node node1, Node node2, string model) {
  simpleLocalFlowStep(node1, node2) and model = ""
}

predicate simpleLocalFlowStep(Node node1, Node node2) {
  valuePreservingStep(node1, node2) and
  nodeGetEnclosingCallable(pragma[only_bind_out](node1)) =
    nodeGetEnclosingCallable(pragma[only_bind_out](node2))
  or
  useUseFlow(node1, node2)
  or
  exists(FlowSummaryImpl::Private::SummaryNode input, FlowSummaryImpl::Private::SummaryNode output |
    FlowSummaryPrivate::Steps::summaryStoreStep(input, MkAwaited(), output) and
    node1 = TFlowSummaryNode(input) and
    (
      node2 = TFlowSummaryNode(output) and
      not node2 instanceof PostUpdateNode // When doing a store-back, do not add the local flow edge
      or
      node2 = TFlowSummaryIntermediateAwaitStoreNode(input)
    )
    or
    FlowSummaryPrivate::Steps::summaryReadStep(input, MkAwaited(), output) and
    node1 = TFlowSummaryNode(input) and
    node2 = TFlowSummaryNode(output)
    or
    // Add flow through optional barriers. This step is then blocked by the barrier for queries that choose to use the barrier.
    FlowSummaryPrivate::Steps::summaryReadStep(input, MkOptionalBarrier(_), output) and
    node1 = TFlowSummaryNode(input) and
    node2 = TFlowSummaryNode(output)
  )
  or
  VariableCaptureOutput::localFlowStep(getClosureNode(node1), getClosureNode(node2))
  or
  // NOTE: For consistency with readStep/storeStep, we do not translate these steps to jump steps automatically.
  DataFlow::AdditionalFlowStep::step(node1, node2)
  or
  exists(InvokeExpr invoke |
    // When the first argument is a spread argument, flow into the argument array as a local flow step
    // to ensure we preserve knowledge about array indices
    node1 = TValueNode(invoke.getArgument(0).stripParens().(SpreadElement).getOperand()) and
    node2 = TDynamicArgumentArrayNode(invoke)
  )
  or
  exists(Function f |
    // When the first parameter is a rest parameter, flow into the rest parameter as a local flow step
    // to ensure we preserve knowledge about array indices
    node1 = TStaticParameterArrayNode(f) or node1 = TDynamicParameterArrayNode(f)
  |
    // rest parameter at initial position
    exists(Parameter rest |
      rest = f.getParameter(0) and
      rest.isRestParameter() and
      node2 = TValueNode(rest)
    )
    or
    // 'arguments' array
    node2 = TReflectiveParametersNode(f)
  )
  or
  // Prepare to store non-spread arguments after a spread into the dynamic arguments array
  exists(InvokeExpr invoke, int n, Expr argument, Content storeContent |
    invoke.getArgument(n) = argument and
    not argument instanceof SpreadElement and
    n > firstSpreadArgumentIndex(invoke) and
    node1 = TValueNode(argument) and
    node2 = TDynamicArgumentStoreNode(invoke, storeContent) and
    storeContent.isUnknownArrayElement()
  )
}

predicate localMustFlowStep(Node node1, Node node2) { node1 = node2.getImmediatePredecessor() }

/**
 * Holds if `node1 -> node2` should be removed as a jump step.
 *
 * Currently this is done as a workaround for the local steps generated from IIFEs.
 */
private predicate excludedJumpStep(Node node1, Node node2) {
  exists(ImmediatelyInvokedFunctionExpr iife |
    iife.argumentPassing(node2.asExpr(), node1.asExpr())
    or
    node1 = iife.getAReturnedExpr().flow() and
    node2 = iife.getInvocation().flow()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` through a non-local step
 * that does not follow a call edge. For example, a step through a global
 * variable.
 */
predicate jumpStep(Node node1, Node node2) {
  valuePreservingStep(node1, node2) and
  node1.getContainer() != node2.getContainer() and
  not excludedJumpStep(node1, node2)
  or
  FlowSummaryPrivate::Steps::summaryJumpStep(node1.(FlowSummaryNode).getSummaryNode(),
    node2.(FlowSummaryNode).getSummaryNode())
  or
  DataFlow::AdditionalFlowStep::jumpStep(node1, node2)
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `c`.  Thus,
 * `node1` references an object with a content `c.getAReadContent()` whose
 * value ends up in `node2`.
 */
predicate readStep(Node node1, ContentSet c, Node node2) {
  exists(DataFlow::PropRead read |
    node1 = read.getBase() and
    node2 = read
  |
    exists(PropertyName name | read.getPropertyName() = name |
      not exists(name.asArrayIndex()) and
      c = ContentSet::property(name)
      or
      c = ContentSet::arrayElementKnown(name.asArrayIndex())
    )
    or
    not exists(read.getPropertyName()) and
    c = ContentSet::arrayElement()
  )
  or
  exists(ContentSet contentSet |
    FlowSummaryPrivate::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(), contentSet,
      node2.(FlowSummaryNode).getSummaryNode())
  |
    not isSpecialContentSet(contentSet) and
    c = contentSet
    or
    contentSet = MkAwaited() and
    c = ContentSet::promiseValue()
  )
  or
  // For deep reads, generate read edges with a self-loop
  exists(Node origin, ContentSet contentSet |
    FlowSummaryPrivate::Steps::summaryReadStep(origin.(FlowSummaryNode).getSummaryNode(),
      contentSet, node2.(FlowSummaryNode).getSummaryNode()) and
    node1 = [origin, node2]
  |
    contentSet = MkAnyPropertyDeep() and
    c = ContentSet::anyProperty()
    or
    contentSet = MkArrayElementDeep() and
    c = ContentSet::arrayElement()
  )
  or
  exists(LocalVariableOrThis variable |
    VariableCaptureOutput::readStep(getClosureNode(node1), variable, getClosureNode(node2)) and
    c.asSingleton() = MkCapturedContent(variable)
  )
  or
  DataFlow::AdditionalFlowStep::readStep(node1, c, node2)
  or
  // Pass dynamic arguments into plain parameters
  exists(Function function, Parameter param, int n |
    param = function.getParameter(n) and
    not param.isRestParameter() and
    node1 = TDynamicParameterArrayNode(function) and
    node2 = TValueNode(param) and
    c = ContentSet::arrayElementFromInt(n)
  )
  or
  // Prepare to store dynamic and static arguments into the rest parameter array when it isn't the first parameter
  exists(Function function, Content content, int restIndex |
    restIndex = function.getRestParameter().getIndex() and
    restIndex > 0 and
    (node1 = TStaticParameterArrayNode(function) or node1 = TDynamicParameterArrayNode(function)) and
    node2 = TRestParameterStoreNode(function, content)
  |
    // shift known array indices
    c.asSingleton().asArrayIndex() = content.asArrayIndex() + restIndex
    or
    content.isUnknownArrayElement() and
    c = ContentSet::arrayElementUnknown()
  )
  or
  // Prepare to store spread arguments into the dynamic arguments array, when it isn't the initial argument
  exists(InvokeExpr invoke, int n, Expr argument, Content storeContent |
    invoke.getArgument(n).stripParens().(SpreadElement).getOperand() = argument and
    n > 0 and // n=0 is handled as a value step
    node1 = TValueNode(argument) and
    node2 = TDynamicArgumentStoreNode(invoke, storeContent) and
    if n > firstSpreadArgumentIndex(invoke)
    then
      c = ContentSet::arrayElement() and // unknown start index when not the first spread operator
      storeContent.isUnknownArrayElement()
    else (
      storeContent.asArrayIndex() = n + c.asSingleton().asArrayIndex()
      or
      storeContent.isUnknownArrayElement() and c.asSingleton() = storeContent
    )
  )
  or
  exists(FlowSummaryNode parameter, ParameterPosition pos |
    FlowSummaryImpl::Private::summaryParameterNode(parameter.getSummaryNode(), pos) and
    node1 = TFlowSummaryDynamicParameterArrayNode(parameter.getSummarizedCallable()) and
    node2 = parameter and
    (
      c.asSingleton().asArrayIndex() = pos.asPositional()
      or
      c = ContentSet::arrayElementLowerBound(pos.asPositionalLowerBound())
    )
  )
}

/** Gets the post-update node for which `node` is the corresponding pre-update node. */
private Node getPostUpdateForStore(Node base) {
  exists(Expr expr |
    base = TValueNode(expr) and
    result = TExprPostUpdateNode(expr)
  |
    // When object/array literal appears as an argument to a call, we would generally need two post-update nodes:
    // - one for the stores coming from the properties or array elements (which happen before the call and must flow into the call)
    // - one for the argument position, to propagate the updates that happened during the call
    //
    // However, the first post-update is not actually needed since we are storing into a brand new object, so in the first case
    // we just target the expression directly. In the second case we use the ExprPostUpdateNode.
    not expr instanceof ObjectExpr and
    not expr instanceof ArrayExpr
  )
  or
  exists(ImplicitThisUse use |
    base = TImplicitThisUse(use, false) and
    result = TImplicitThisUse(use, true)
  )
}

/** Gets node to target with a store to the given `base` object.. */
pragma[inline]
private Node getStoreTarget(DataFlow::Node base) {
  result = getPostUpdateForStore(base)
  or
  not exists(getPostUpdateForStore(base)) and
  result = base
}

pragma[nomagic]
private int firstSpreadArgumentIndex(InvokeExpr expr) {
  result = min(int i | expr.isSpreadArgument(i))
}

/**
 * Holds if data can flow from `node1` to `node2` via a store into `c`.  Thus,
 * `node2` references an object with a content `c.getAStoreContent()` that
 * contains the value of `node1`.
 */
predicate storeStep(Node node1, ContentSet c, Node node2) {
  exists(DataFlow::PropWrite write |
    node1 = write.getRhs() and
    c.asPropertyName() = write.getPropertyName() and
    // Target the post-update node if one exists (for object literals we do not generate post-update nodes)
    node2 = getStoreTarget(write.getBase())
  )
  or
  FlowSummaryPrivate::Steps::summaryStoreStep(node1.(FlowSummaryNode).getSummaryNode(), c,
    node2.(FlowSummaryNode).getSummaryNode()) and
  not isSpecialContentSet(c)
  or
  // Store into Awaited
  exists(FlowSummaryImpl::Private::SummaryNode input, FlowSummaryImpl::Private::SummaryNode output |
    FlowSummaryPrivate::Steps::summaryStoreStep(input, MkAwaited(), output) and
    node1 = TFlowSummaryIntermediateAwaitStoreNode(input) and
    node2 = TFlowSummaryNode(output) and
    c = ContentSet::promiseValue()
  )
  or
  exists(LocalVariableOrThis variable |
    VariableCaptureOutput::storeStep(getClosureNode(node1), variable, getClosureNode(node2)) and
    c.asSingleton() = MkCapturedContent(variable)
  )
  or
  DataFlow::AdditionalFlowStep::storeStep(node1, c, node2)
  or
  exists(Function f, Content storeContent |
    node1 = TRestParameterStoreNode(f, storeContent) and
    node2 = TValueNode(f.getRestParameter()) and
    c.asSingleton() = storeContent
  )
  or
  exists(InvokeExpr invoke, Content storeContent |
    node1 = TDynamicArgumentStoreNode(invoke, storeContent) and
    node2 = TDynamicArgumentArrayNode(invoke) and
    c.asSingleton() = storeContent
  )
  or
  exists(InvokeExpr invoke, int n |
    node1 = TValueNode(invoke.getArgument(n)) and
    node2 = TStaticArgumentArrayNode(invoke) and
    c.asSingleton().asArrayIndex() = n and
    not n >= firstSpreadArgumentIndex(invoke)
  )
  or
  exists(ApplyCallTaintNode taintNode |
    node1 = taintNode and
    node2 = taintNode.getArrayNode() and
    c = ContentSet::arrayElementUnknown()
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) {
  FlowSummaryPrivate::Steps::summaryClearsContent(n.(FlowSummaryNode).getSummaryNode(), c)
  or
  // Clear promise content before storing into promise value, to avoid creating nested promises
  n = TFlowSummaryIntermediateAwaitStoreNode(_) and
  c = MkPromiseFilter()
  or
  // After reading from Awaited, the output must not be stored in a promise content
  FlowSummaryPrivate::Steps::summaryReadStep(_, MkAwaited(), n.(FlowSummaryNode).getSummaryNode()) and
  c = MkPromiseFilter()
  or
  any(AdditionalFlowInternal flow).clearsContent(n, c)
  or
  // When a function `f` captures itself, all its access paths can be prefixed by an arbitrary number of `f.f.f...`.
  // When multiple functions `f,g` capture each other, these prefixes can become interleaved, like `f.g.f.g...`.
  // To avoid creating these trivial prefixes, we never allow two consecutive captured variables in the access path.
  // We implement this rule by clearing any captured-content before storing into another captured-content.
  VariableCaptureOutput::storeStep(getClosureNode(n), _, _) and
  c = MkAnyCapturedContent()
  or
  // Block flow into the "window.location" property, as any assignment/mutation to this causes a page load and stops execution.
  // The use of clearsContent here ensures we also block assignments like `window.location.href = ...`
  exists(DataFlow::PropRef ref |
    ref = DataFlow::globalObjectRef().getAPropertyReference("location") and
    n = ref.getBase().getPostUpdateNode() and
    c = ContentSet::property("location")
  )
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) {
  FlowSummaryPrivate::Steps::summaryExpectsContent(n.(FlowSummaryNode).getSummaryNode(), c)
  or
  // After storing into Awaited, the result must be stored in a promise-content.
  // There is a value step from the input directly to this node, hence the need for expectsContent.
  FlowSummaryPrivate::Steps::summaryStoreStep(_, MkAwaited(), n.(FlowSummaryNode).getSummaryNode()) and
  c = MkPromiseFilter()
  or
  any(AdditionalFlowInternal flow).expectsContent(n, c)
  or
  c = ContentSet::arrayElement() and
  n instanceof TDynamicParameterArrayNode
}

abstract class NodeRegion extends Unit {
  NodeRegion() { none() }

  /** Holds if this region contains `n`. */
  predicate contains(Node n) { none() }

  int totalOrder() { none() }
}

/**
 * Holds if the node `n` is unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(NodeRegion n, DataFlowCall call) {
  none() // TODO: could be useful, but not currently implemented for JS
}

int accessPathLimit() { result = 2 }

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) {
  exists(DataFlowCallable callable, ParameterPosition pos |
    isParameterNodeImpl(p, callable, pos) and
    FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(callable.asLibraryCallable(), pos)
  )
  or
  exists(Function f |
    VariableCaptureOutput::heuristicAllowInstanceParameterReturnInSelf(f) and
    p = TFunctionSelfReferenceNode(f)
  )
}

class LambdaCallKind = Unit;

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  creation.(DataFlow::FunctionNode).getFunction() = c.asSourceCallable() and exists(kind)
}

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  call.isSummaryCall(_, receiver.(FlowSummaryNode).getSummaryNode()) and exists(kind)
  or
  receiver = call.asOrdinaryCall().getCalleeNode() and
  exists(kind) and
  receiver.getALocalSource() instanceof DataFlow::ParameterNode
}

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

class ArgumentNode extends DataFlow::Node {
  ArgumentNode() { isArgumentNodeImpl(this, _, _) }

  predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
    isArgumentNodeImpl(this, call, pos)
  }
}

class ParameterNode extends DataFlow::Node {
  ParameterNode() { isParameterNodeImpl(this, _, _) }
}

cached
private module OptionalSteps {
  cached
  predicate optionalStep(Node node1, string name, Node node2) {
    FlowSummaryPrivate::Steps::summaryReadStep(node1.(FlowSummaryNode).getSummaryNode(),
      MkOptionalStep(name), node2.(FlowSummaryNode).getSummaryNode())
  }

  cached
  predicate optionalBarrier(Node node, string name) {
    FlowSummaryPrivate::Steps::summaryReadStep(_, MkOptionalBarrier(name),
      node.(FlowSummaryNode).getSummaryNode())
  }
}

import OptionalSteps
