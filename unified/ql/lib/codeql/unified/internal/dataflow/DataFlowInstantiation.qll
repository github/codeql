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
  class ReturnNode extends Node {
    ReturnNode() {
      // TODO: Handle short-hand returns such as `func foo() -> Int { 5 }`
      this.asExpr() = any(ReturnExpr r).getValue()
    }

    ReturnKind getKind() { exists(result) }
  }

  class OutNode extends Node {
    OutNode() { this.asExpr() instanceof CallExpr }
  }

  class ReturnKind = Unit;

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
    p.isReceiverParameterEx(c) and
    pos.isReceiver()
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
    n.isReceiverArgumentEx(call) and
    pos.isReceiver()
  }

  class ArgumentNode extends Node {
    ArgumentNode() { isArgumentNodeImpl(this, _, _) }
  }

  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
    // This predicate is needed to implement the signature without empty recursion through ArgumentNode
    isArgumentNodeImpl(n, call, pos)
  }

  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
    result.asExpr() = call.asExplicitCall() and exists(kind)
  }

  //
  // Post-update nodes
  //
  class PostUpdateNode extends Node {
    PostUpdateNode() { this = getPostUpdateNode(_) }

    Node getPreUpdateNode() { this = getPostUpdateNode(result) }
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
  predicate simpleLocalFlowStep(Node node1, Node node2, string model) {
    step(node1, any(Step s | s.value()), node2) and model = ""
    or
    localSsaStep(node1, node2, _) and model = ""
  }

  predicate jumpStep(Node node1, Node node2) { step(node1, any(Step s | s.jump()), node2) }

  predicate readStep(Node node1, ContentSet c, Node node2) {
    step(node1, any(Step s | s.read(c)), node2)
  }

  predicate storeStep(Node node1, ContentSet c, Node node2) {
    step(node1, any(Step s | s.store(c)), node2)
  }

  predicate clearsContent(Node n, ContentSet c) { none() } // TODO

  predicate expectsContent(Node n, ContentSet c) { none() } // TODO

  predicate localMustFlowStep(Node node1, Node node2) { localSsaMustFlowStep(node1, node2) } // TODO

  //
  // Misc
  //
  additional predicate nodeIsVisible(Node node) {
    node instanceof TValueNode
    or
    node instanceof TStrictlyIncomingValue
    or
    node instanceof TExprPostUpdateNode
  }

  predicate nodeIsHidden(Node node) { not nodeIsVisible(node) }

  predicate neverSkipInPathGraph(Node n) {
    n.isIncomingValue(_) or // Never skip assignment target
    n.asExpr() instanceof LocalVariableAccess // Never skip a variable reference
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

  predicate allowParameterReturnInSelf(ParameterNode p) { none() } // TODO

  class LambdaCallKind extends Void {
    LambdaCallKind() { none() } // TODO

    string toString() { none() } // TODO
  }

  predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) { none() } // TODO

  predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() } // TODO

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
