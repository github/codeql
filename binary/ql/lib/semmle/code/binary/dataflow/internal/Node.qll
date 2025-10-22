private import codeql.dataflow.DataFlow
private import codeql.dataflow.internal.DataFlowImpl
private import semmle.code.binary.ast.ir.IR
private import SsaImpl as SsaImpl
private import DataFlowImpl

class NodePublic extends TNode {
  cached
  abstract Location getLocation();

  cached
  abstract string toString();

  final Instruction asInstruction() { this = TInstructionNode(result) }

  final Operand asOperand() { this = TOperandNode(result) }
}

abstract class Node extends NodePublic {
  DataFlowCallable getEnclosingCallable() { result.asFunction() = this.getFunction() }

  abstract Function getFunction();
}

class InstructionNode extends Node, TInstructionNode {
  Instruction instr;

  InstructionNode() { this = TInstructionNode(instr) }

  final Instruction getInstruction() { result = instr }

  final override Function getFunction() { result = instr.getEnclosingFunction() }

  final override Location getLocation() { result = instr.getLocation() }

  final override string toString() { result = instr.toString() }
}

class OperandNode extends Node, TOperandNode {
  Operand op;

  OperandNode() { this = TOperandNode(op) }

  final Operand getOperand() { result = op }

  final override Function getFunction() { result = op.getEnclosingFunction() }

  final override Location getLocation() { result = op.getLocation() }

  final override string toString() { result = op.toString() }
}

class SsaNode extends Node, TSsaNode {
  SsaImpl::DataFlowIntegration::SsaNode node;

  SsaNode() { this = TSsaNode(node) }

  override Function getFunction() { result = node.getBasicBlock().getEnclosingFunction() }

  /** Gets the definition this node corresponds to, if any. */
  SsaImpl::Definition asDefinition() {
    result = node.(SsaImpl::DataFlowIntegration::SsaDefinitionNode).getDefinition()
  }

  override Location getLocation() { result = node.getLocation() }

  override string toString() { result = "[SSA] " + node.toString() }
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

final class CastNode extends InstructionNode {
  CastNode() { none() }
}

cached
newtype TNode =
  TInstructionNode(Instruction instr) or
  TOperandNode(Operand op) or
  TSsaNode(SsaImpl::DataFlowIntegration::SsaNode node)
