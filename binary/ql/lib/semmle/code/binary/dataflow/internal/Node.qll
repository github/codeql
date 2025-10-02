private import codeql.dataflow.DataFlow
private import codeql.dataflow.internal.DataFlowImpl
private import binary
private import SsaImpl as SsaImpl
private import DataFlowImpl

class NodePublic extends TNode {
  cached
  abstract Location getLocation();

  cached
  abstract string toString();

  final Instruction asExpr() { this = TExprNode(result) }
}

abstract class Node extends NodePublic {
  DataFlowCallable getEnclosingCallable() { result.asFunction() = this.getFunction() }

  abstract Function getFunction();
}

class ExprNode extends Node, TExprNode {
  Instruction instr;

  ExprNode() { this = TExprNode(instr) }

  final Instruction getInstruction() { result = instr }

  final override Function getFunction() { result = instr.getEnclosingFunction() }

  final override Location getLocation() { result = instr.getLocation() }

  final override string toString() { result = instr.toString() }
}

abstract class ParameterNode extends Node {
  abstract predicate isParameterOf(DataFlowCallable c, ParameterPosition pos);
}

abstract class ArgumentNode extends Node {
  abstract predicate isArgumentOf(DataFlowCall call, BinaryDataFlow::ArgumentPosition pos);
}

abstract class ReturnNode extends Node {
  abstract ReturnKind getKind();
}

abstract class OutNode extends Node {
  abstract DataFlowCall getCall(ReturnKind kind);
}

abstract class PostUpdateNodePublic extends NodePublic {
  /** Gets the node before the state update. */
  abstract NodePublic getPreUpdateNode();
}

abstract class PostUpdateNode extends PostUpdateNodePublic, Node {
  override string toString() { result = "[post] " + this.getPreUpdateNode().toString() }
}

final class CastNode extends ExprNode {
  CastNode() { none() }
}

cached
newtype TNode =
  TExprNode(Instruction instr) or
  TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node)
