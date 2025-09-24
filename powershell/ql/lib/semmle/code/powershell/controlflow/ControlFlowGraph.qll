/** Provides classes representing the control flow graph. */

import codeql.controlflow.SuccessorType
private import powershell
private import BasicBlocks
private import internal.ControlFlowGraphImpl as CfgImpl
private import internal.Splitting as Splitting
private import internal.Completion

/**
 * An AST node with an associated control-flow graph.
 *
 * Top-levels, methods, blocks, and lambdas are all CFG scopes.
 *
 * Note that module declarations are not themselves CFG scopes, as they are part of
 * the CFG of the enclosing top-level or callable.
 */
class CfgScope extends Scope instanceof CfgImpl::CfgScope {
  final CfgScope getOuterCfgScope() {
    exists(Ast parent |
      parent = this.getParent() and
      result = CfgImpl::getCfgScope(parent)
    )
  }

  Parameter getAParameter() { result = super.getAParameter() }
}

/**
 * A control flow node.
 *
 * A control flow node is a node in the control flow graph (CFG). There is a
 * many-to-one relationship between CFG nodes and AST nodes.
 *
 * Only nodes that can be reached from an entry point are included in the CFG.
 */
class CfgNode extends CfgImpl::Node {
  /** Gets the name of the primary QL class for this node. */
  string getAPrimaryQlClass() { none() }

  /** Gets the file of this control flow node. */
  final File getFile() { result = this.getLocation().getFile() }

  /** Gets a successor node of a given type, if any. */
  final CfgNode getASuccessor(SuccessorType t) { result = super.getASuccessor(t) }

  /** Gets an immediate successor, if any. */
  final CfgNode getASuccessor() { result = this.getASuccessor(_) }

  /** Gets an immediate predecessor node of a given flow type, if any. */
  final CfgNode getAPredecessor(SuccessorType t) { result.getASuccessor(t) = this }

  /** Gets an immediate predecessor, if any. */
  final CfgNode getAPredecessor() { result = this.getAPredecessor(_) }

  /** Gets the basic block that this control flow node belongs to. */
  BasicBlock getBasicBlock() { result.getANode() = this }
}

class Split = Splitting::Split;

/** Provides different kinds of control flow graph splittings. */
module Split {
  class ConditionalCompletionSplit = Splitting::ConditionalCompletionSplit;
}
