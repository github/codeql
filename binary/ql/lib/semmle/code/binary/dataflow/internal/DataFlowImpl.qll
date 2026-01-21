private import codeql.util.Void
private import codeql.util.Unit
private import codeql.util.Boolean
private import semmle.code.binary.ast.ir.IR
private import SsaImpl as SsaImpl
private import codeql.dataflow.DataFlow
private import codeql.dataflow.internal.DataFlowImpl
private import Node
private import Content

final class ReturnKind extends TNormalReturnKind {
  string toString() { result = "return" }
}

final class DataFlowCallable extends TDataFlowCallable {
  /**
   * Gets the underlying CFG scope, if any.
   */
  Function asFunction() { this = TDataFlowFunction(result) }

  /** Gets a textual representation of this callable. */
  string toString() { result = this.asFunction().toString() }

  /** Gets the location of this callable. */
  Location getLocation() { result = this.asFunction().getLocation() }
}

final class DataFlowCall extends TDataFlowCall {
  /** Gets the underlying call in the CFG, if any. */
  CallInstruction asCallInstruction() { this = TCall(result) }

  DataFlowCallable getEnclosingCallable() {
    result.asFunction() = this.asCallInstruction().getEnclosingFunction()
  }

  string toString() { result = this.asCallInstruction().toString() }

  Location getLocation() { result = this.asCallInstruction().getLocation() }
}

final class ParameterPosition extends TPosition {
  /** Gets the underlying integer position, if any. */
  int getPosition() { this = TMkPosition(result) }

  /** Gets a textual representation of this position. */
  string toString() { result = this.getPosition().toString() }
}

final class ArgumentPosition extends TPosition {
  /** Gets the argument of `call` at this position, if any. */
  Instruction getArgument(CallInstruction call) { none() }

  string toString() { none() }
}

module SsaFlow {
  private module SsaFlow = SsaImpl::DataFlowIntegration;

  SsaFlow::Node asNode(Node n) {
    n = TSsaNode(result)
    or
    result.(SsaFlow::ExprNode).getExpr().asOperand() = n.asOperand()
    or
    exists(BasicBlock bb, int i |
      result.(SsaFlow::SsaDefinitionNode).getDefinition().definesAt(_, bb, i) and
      n.asInstruction() = bb.getNode(i).asInstruction()
    )
  }

  predicate localFlowStep(
    SsaImpl::SsaInput::SourceVariable v, Node nodeFrom, Node nodeTo, boolean isUseStep
  ) {
    SsaFlow::localFlowStep(v, asNode(nodeFrom), asNode(nodeTo), isUseStep)
  }
}

module LocalFlow {
  predicate localFlowStepCommon(Node nodeFrom, Node nodeTo) {
    nodeTo.asInstruction().(CopyInstruction).getOperand() = nodeFrom.asOperand()
    or
    exists(StoreInstruction store |
      nodeFrom.asOperand() = store.getValueOperand() and
      nodeTo.asOperand() = store.getAddressOperand()
    )
    or
    exists(LoadInstruction load |
      nodeFrom.asOperand() = load.getOperand() and
      nodeTo.asInstruction() = load
    )
  }
}

class LambdaCallKind = Unit;

private module Aliases {
  class DataFlowCallableAlias = DataFlowCallable;

  class ReturnKindAlias = ReturnKind;

  class DataFlowCallAlias = DataFlowCall;

  class ParameterPositionAlias = ParameterPosition;

  class ArgumentPositionAlias = ArgumentPosition;

  class ContentAlias = Content;

  class ContentSetAlias = ContentSet;

  class LambdaCallKindAlias = LambdaCallKind;
}

module BinaryDataFlow implements InputSig<Location> {
  private import Aliases
  private import semmle.code.binary.dataflow.DataFlow
  private import Node as Node

  /**
   * An element, viewed as a node in a data flow graph. Either an expression
   * (`ExprNode`) or a parameter (`ParameterNode`).
   */
  class Node = DataFlow::Node;

  final class ParameterNode = Node::ParameterNode;

  final class ArgumentNode = Node::ArgumentNode;

  final class ReturnNode = Node::ReturnNode;

  final class OutNode = Node::OutNode;

  class PostUpdateNode = DataFlow::PostUpdateNode;

  final class CastNode = Node::CastNode;

  /** Holds if `p` is a parameter of `c` at the position `pos`. */
  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    p.isParameterOf(c, pos)
  }

  /** Holds if `n` is an argument of `c` at the position `pos`. */
  predicate isArgumentNode(ArgumentNode n, DataFlowCall call, ArgumentPosition pos) {
    n.isArgumentOf(call, pos)
  }

  DataFlowCallable nodeGetEnclosingCallable(Node node) {
    result = node.(Node::Node).getEnclosingCallable()
  }

  DataFlowType getNodeType(Node node) { any() }

  predicate nodeIsHidden(Node node) { none() }

  predicate neverSkipInPathGraph(Node node) { none() }

  class DataFlowExpr = Instruction;

  /** Gets the node corresponding to `e`. */
  Node exprNode(DataFlowExpr e) { result.asInstruction() = e }

  final class DataFlowCall = DataFlowCallAlias;

  final class DataFlowCallable = DataFlowCallableAlias;

  final class ReturnKind = ReturnKindAlias;

  /** Gets a viable implementation of the target of the given `Call`. */
  DataFlowCallable viableCallable(DataFlowCall call) { none() }

  OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { none() }

  final class DataFlowType extends Unit {
    string toString() { result = "" }
  }

  predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

  predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

  class Content = ContentAlias;

  class ContentSet = ContentSetAlias;

  final class ContentApprox = Content;

  class LambdaCallKind = LambdaCallKindAlias;

  predicate forceHighPrecision(Content c) { none() }

  ContentApprox getContentApprox(Content c) { result = c }

  class ParameterPosition = ParameterPositionAlias;

  class ArgumentPosition = ArgumentPositionAlias;

  predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { ppos = apos }

  predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) { none() }

  predicate jumpStep(Node node1, Node node2) { none() }

  predicate readStep(Node node1, ContentSet cs, Node node2) { none() }

  predicate storeStep(Node node1, ContentSet cs, Node node2) { none() }

  predicate clearsContent(Node n, ContentSet cs) { none() }

  predicate expectsContent(Node n, ContentSet cs) { none() }

  class NodeRegion instanceof Void {
    string toString() { result = "NodeRegion" }

    predicate contains(Node n) { none() }
  }

  predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

  predicate allowParameterReturnInSelf(ParameterNode p) { none() }

  predicate localMustFlowStep(Node node1, Node node2) { none() }

  predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) { none() }

  predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() }

  predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

  predicate knownSourceModel(Node source, string model) { none() }

  predicate knownSinkModel(Node sink, string model) { none() }

  class DataFlowSecondLevelScope = Void;
}

import MakeImpl<Location, BinaryDataFlow>

cached
private module Cached {
  cached
  newtype TDataFlowCall = TCall(CallInstruction c)

  cached
  newtype TDataFlowCallable = TDataFlowFunction(Function scope)

  cached
  predicate localFlowStepImpl(Node nodeFrom, Node nodeTo) {
    LocalFlow::localFlowStepCommon(nodeFrom, nodeTo)
    or
    SsaFlow::localFlowStep(_, nodeFrom, nodeTo, _)
  }

  cached
  newtype TPosition = TMkPosition(int i) { none() }

  cached
  newtype TReturnKind = TNormalReturnKind()

  cached
  newtype TContentSet = TSingletonContentSet(Content c)

  cached
  predicate sourceNode(Node n, string kind) { none() }

  cached
  predicate sinkNode(Node n, string kind) { none() }
}

import Cached
