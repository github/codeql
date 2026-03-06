/** Provides classes representing the control flow graph. */

import codeql.controlflow.SuccessorType
private import codeql.php.AST
private import codeql.php.controlflow.BasicBlocks
private import internal.ControlFlowGraphImpl as CfgImpl
private import internal.Completion

/**
 * An AST node with an associated control-flow graph.
 *
 * Functions, methods, closures, arrow functions, and programs are CFG scopes.
 */
class CfgScope extends AstNode instanceof CfgImpl::CfgScopeImpl { }

/**
 * A control flow node.
 *
 * A control flow node is a node in the control flow graph (CFG). There is a
 * many-to-one relationship between CFG nodes and AST nodes.
 *
 * Only nodes that can be reached from an entry point are included in the CFG.
 */
class CfgNode extends CfgImpl::Node {
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

  /** Gets the AST node associated with this CFG node. */
  AstNode getAstNode() { result = super.getAstNode() }

  /** Gets the CFG scope that this node belongs to. */
  CfgScope getScope() { result = super.getScope() }
}
