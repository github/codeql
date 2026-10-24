private import unified
private import AllDataFlow
private import AllDataFlow as D
private import codeql.dataflow.DataFlow
private import codeql.util.Void
private import codeql.util.Unit

module DataFlowInput implements InputSig<Location> {
  class Node = D::Node;

  //
  // Contents
  //
  class Content = D::Content;

  class ContentSet = D::ContentSet;

  class ContentApprox = Content; // TODO

  ContentApprox getContentApprox(Content c) { result = c } // TODO

  //
  // Parameter, argument, return, and out nodes and their positions/kinds
  //
  private predicate isReturnNode(Node n, ReturnKind kind) {
    n.isReturnNode(_) and kind.isStandardReturnValue()
    or
    FlowSummaryOutput::summaryReturnNode(getSummaryNode(n), kind)
  }

  class ReturnNode extends Node {
    ReturnNode() { isReturnNode(this, _) }

    ReturnKind getKind() { isReturnNode(this, result) }
  }

  private predicate isOutNode(Node n, DataFlowCall call, ReturnKind kind) {
    n.asExpr() = call.asExplicitCall() and kind.isStandardReturnValue()
    or
    exists(FlowSummaryOutput::SummaryNode callee |
      FlowSummaryOutput::summaryOutNode(callee, getSummaryNode(n), kind) and
      call.isSummaryCall(_, callee)
    )
    or
    exists(Expr access |
      call.asGetterCall() = access and
      n.isResultValue(access) and
      kind.isStandardReturnValue()
    )
  }

  class OutNode extends Node {
    OutNode() { isOutNode(this, _, _) }
  }

  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { isOutNode(result, call, kind) }

  class ReturnKind extends Unit {
    /** Holds if this is the standard return value */
    predicate isStandardReturnValue() { any() }
  }

  import ParameterPositions
  //
  // Calls and callables
  //
  import DataFlowCall
  import DataFlowCallable
  import CallGraph

  DataFlowCallable nodeGetEnclosingCallable(Node node) { result = node.getEnclosingCallableEx() }

  private predicate isParameterNodeImpl(Node p, DataFlowCallable c, ParameterPosition pos) {
    exists(Parameter param |
      p.asExpr() = param.getPattern() and
      c.asSourceCallable() = param.getEnclosingCallable()
    |
      pos.asPositional() = param.getPositionalIndex()
      or
      pos.asNamed() = param.getExternalName()
    )
    or
    p.(BuilderNode).isImplicitParameter(c, pos)
    or
    FlowSummaryOutput::summaryParameterNode(getSummaryNode(p), pos) and
    c = p.getEnclosingCallableEx()
  }

  class ParameterNode extends Node {
    ParameterNode() { isParameterNodeImpl(this, _, _) }
  }

  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    // This predicate is needed to implement the signature without empty recursion through ParameterNode
    isParameterNodeImpl(p, c, pos)
  }

  private predicate isArgumentNodeImpl(Node n, DataFlowCall call, ArgumentPosition pos) {
    exists(Argument arg |
      n.asExpr() = arg.getValue() and
      call.asExplicitCall().getAnArgument() = arg
    |
      pos.asPositional() = arg.getPositionalIndex()
      or
      pos.asNamed() = arg.getName()
    )
    or
    n.(BuilderNode).isImplicitArgument(call, pos, false)
    or
    exists(Expr access |
      call.asSetterCall() = access and
      n.isIncomingValue(access) and
      pos.asPositional() = 0
    )
    or
    exists(FlowSummaryOutput::SummaryNode callee |
      FlowSummaryOutput::summaryArgumentNode(callee, getSummaryNode(n), pos) and
      call.isSummaryCall(_, callee)
    )
  }

  class ArgumentNode extends Node {
    ArgumentNode() { isArgumentNodeImpl(this, _, _) }
  }

  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
    // This predicate is needed to implement the signature without empty recursion through ArgumentNode
    isArgumentNodeImpl(n, call, pos)
  }

  //
  // Post-update nodes
  //
  class PostUpdateNode extends Node {
    PostUpdateNode() { this = any(Node n).getPostUpdateNode() }

    Node getPreUpdateNode() { this = result.getPostUpdateNode() }
  }

  //
  // Types
  //
  class DataFlowType extends Unit {
    // TODO: track proper types
    string toString() { result = "" } // do not include "unit" type in path steps
  }

  class CastNode extends Node {
    CastNode() { none() } // TODO
  }

  DataFlowType getNodeType(Node node) { any() } // TODO

  predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() } // TODO

  predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { any() } // TODO

  //
  // Steps
  //
  pragma[nomagic]
  private Step valueStepEx() {
    result.value()
    or
    result.valueMustFlow()
    or
    exists(ContentSet contents | bypassContentSet(contents) |
      result.read(contents)
      or
      result.store(contents)
    )
  }

  predicate simpleLocalFlowStep(Node node1, Node node2, string model) {
    step(node1, valueStepEx(), node2) and model = ""
    or
    localSsaStep(node1, node2, _) and model = ""
    or
    captureSsaLocalFlowStep(node1, node2) and model = ""
    or
    FlowSummaryOutput::summaryLocalStep(node1, node2, true, model)
    or
    model = "" and
    exists(ContentSet contents | bypassContentSet(contents) |
      FlowSummaryOutput::summaryReadStep(getSummaryNode(node1), contents, getSummaryNode(node2))
      or
      FlowSummaryOutput::summaryStoreStep(getSummaryNode(node1), contents, getSummaryNode(node2))
    )
  }

  predicate jumpStep(Node node1, Node node2) {
    step(node1, any(Step s | s.jump()), node2) or
    FlowSummaryOutput::summaryJumpStep(node1, node2)
  }

  predicate readStep(Node node1, ContentSet c, Node node2) {
    (
      step(node1, any(Step s | s.read(c)), node2)
      or
      captureSsaReadStep(node1, c, node2)
      or
      FlowSummaryOutput::summaryReadStep(getSummaryNode(node1), c, getSummaryNode(node2))
    ) and
    not bypassContentSet(c)
  }

  predicate storeStep(Node node1, ContentSet c, Node node2) {
    (
      step(node1, any(Step s | s.store(c)), node2)
      or
      captureSsaStoreStep(node1, c, node2)
      or
      FlowSummaryOutput::summaryStoreStep(getSummaryNode(node1), c, getSummaryNode(node2))
    ) and
    not bypassContentSet(c)
  }

  predicate clearsContent(Node n, ContentSet c) {
    captureSsaClearsContent(n, c)
    or
    FlowSummaryOutput::summaryClearsContent(getSummaryNode(n), c) and
    not bypassContentSet(c)
  }

  predicate expectsContent(Node n, ContentSet c) {
    FlowSummaryOutput::summaryExpectsContent(getSummaryNode(n), c) and
    not bypassContentSet(c)
  }

  predicate localMustFlowStep(Node node1, Node node2) {
    step(node1, any(Step s | s.valueMustFlow()), node2) or
    localSsaMustFlowStep(node1, node2) or
    FlowSummaryOutput::summaryLocalMustFlowStep(getSummaryNode(node1), getSummaryNode(node2))
  }

  //
  // Misc
  //
  additional predicate nodeIsVisible(Node node) {
    exists(Expr e |
      node = TValueNode(e) and
      not e instanceof ExprPattern
    )
    or
    node instanceof TStrictlyIncomingValue
    or
    node instanceof TExprPostUpdateNode
  }

  predicate nodeIsHidden(Node node) { not nodeIsVisible(node) }

  predicate neverSkipInPathGraph(Node n) {
    n.isIncomingValue(_) or // Never skip assignment target
    n.asExpr() instanceof LocalVariableAccess or // Never skip a variable reference
    n.asExpr() = any(ReturnExpr e).getValue()
  }

  class DataFlowExpr = Expr;

  Node exprNode(DataFlowExpr e) { none() } // TODO

  predicate forceHighPrecision(Content c) { none() } // TODO

  class NodeRegion extends Void {
    NodeRegion() { none() } // TODO

    predicate contains(Node n) { none() } // TODO

    string toString() { none() } // TODO
  }

  predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() } // TODO

  predicate allowParameterReturnInSelf(ParameterNode p) {
    p.isReceiverParameter(_)
    or
    captureSsaAllowParameterReturnInSelf(p)
    or
    exists(DataFlowCallable c, ParameterPosition pos |
      FlowSummaryOutput::summaryAllowParameterReturnInSelf(c.asSummarizedCallable(), pos) and
      isParameterNodeImpl(p, c, pos)
    )
  }

  class LambdaCallKind extends Unit { }

  predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
    creation.isCallableEx(c) and
    exists(kind)
  }

  predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node callee) {
    callee.(BuilderNode).isImplicitArgument(call, any(ArgumentPosition p | p.isCallee()), false) and
    exists(kind)
    or
    call.isSummaryCall(_, getSummaryNode(callee)) and exists(kind)
  }

  predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) {
    none() // TODO
  }

  predicate knownSourceModel(Node source, string model) { none() } // TODO

  predicate knownSinkModel(Node sink, string model) { none() } // TODO

  class DataFlowSecondLevelScope extends Void {
    DataFlowSecondLevelScope() { none() } // TODO

    string toString() { none() } // TODO
  }
}

module DataFlowOutput = DataFlowMake<Location, DataFlowInput>;
