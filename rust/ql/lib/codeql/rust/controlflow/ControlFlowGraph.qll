/** Provides classes representing the control flow graph. */

private import rust
private import internal.ControlFlowGraphImpl
private import internal.Completion
private import internal.SuccessorType
private import internal.Scope as Scope
private import BasicBlocks

final class CfgScope = Scope::CfgScope;

final class SuccessorType = SuccessorTypeImpl;

final class NormalSuccessor = NormalSuccessorImpl;

final class ConditionalSuccessor = ConditionalSuccessorImpl;

final class BooleanSuccessor = BooleanSuccessorImpl;

final class MatchSuccessor = MatchSuccessorImpl;

final class BreakSuccessor = BreakSuccessorImpl;

final class ContinueSuccessor = ContinueSuccessorImpl;

final class ReturnSuccessor = ReturnSuccessorImpl;

/**
 * A control flow node.
 *
 * A control flow node is a node in the control flow graph (CFG). There is a
 * many-to-one relationship between CFG nodes and AST nodes.
 *
 * Only nodes that can be reached from an entry point are included in the CFG.
 */
final class CfgNode extends Node {
  /** Gets the file of this control flow node. */
  File getFile() { result = this.getLocation().getFile() }

  /** Gets a successor node of a given type, if any. */
  CfgNode getASuccessor(SuccessorType t) { result = super.getASuccessor(t) }

  /** Gets an immediate successor, if any. */
  CfgNode getASuccessor() { result = this.getASuccessor(_) }

  /** Gets an immediate predecessor node of a given flow type, if any. */
  CfgNode getAPredecessor(SuccessorType t) { result.getASuccessor(t) = this }

  /** Gets an immediate predecessor, if any. */
  CfgNode getAPredecessor() { result = this.getAPredecessor(_) }

  /** Gets the basic block that this control flow node belongs to. */
  BasicBlock getBasicBlock() { result.getANode() = this }
}
