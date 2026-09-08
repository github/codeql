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
  class ParameterNode extends Node {
    ParameterNode() { none() } // TODO
  }

  class ArgumentNode extends Node {
    ArgumentNode() { none() } // TODO
  }

  class ReturnNode extends Node {
    ReturnNode() { none() } // TODO

    ReturnKind getKind() { none() } // TODO
  }

  class OutNode extends Node {
    OutNode() { none() } // TODO
  }

  class ReturnKind = Unit;

  class ParameterPosition extends Void {
    ParameterPosition() { none() } // TODO

    bindingset[this]
    string toString() { none() } // TODO
  }

  class ArgumentPosition extends Void {
    ArgumentPosition() { none() } // TODO

    bindingset[this]
    string toString() { none() } // TODO
  }

  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { none() } // TODO

  //
  // Calls and callables
  //
  class DataFlowCall extends Void {
    Location getLocation() { none() } // TODO

    DataFlowCallable getEnclosingCallable() { none() } // TODO
  }

  class DataFlowCallable = Callable; // TODO: Use newtype

  DataFlowCallable viableCallable(DataFlowCall c) { none() } // TODO

  DataFlowCallable nodeGetEnclosingCallable(Node node) { result = node.getEnclosingCallable() }

  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    none() // TODO
  }

  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
    none() // TODO
  }

  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { none() } // TODO

  //
  // Post-update nodes
  //
  class PostUpdateNode extends Node {
    PostUpdateNode() { none() } // TODO

    Node getPreUpdateNode() { none() } // TODO
  }

  //
  // Types
  //
  class DataFlowType = Unit; // TODO: track types

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

  predicate localMustFlowStep(Node node1, Node node2) { none() } // TODO

  //
  // Misc
  //
  predicate nodeIsHidden(Node node) { none() } // TODO

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
