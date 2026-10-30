/** Provides classes representing the control flow graph. */

private import internal.ControlFlowGraphImpl as CfgImpl
import codeql.controlflow.SuccessorType

final class CfgScope = CfgImpl::CfgScope;

/**
 * A node in the control flow graph.
 */
class CfgNode extends CfgImpl::ControlFlowNode {
  /** Gets the CFG scope containing this node. */
  CfgScope getScope() { result = this.getEnclosingCallable() }

  /** Holds if this node has conditional successors. */
  predicate isCondition() { exists(this.getASuccessor(any(ConditionalSuccessor t))) }

  /** Holds if this node has more than one predecessor. */
  predicate isJoin() { strictcount(this.getAPredecessor()) > 1 }

  /** Holds if this node has more than one successor. */
  predicate isBranch() { strictcount(this.getASuccessor()) > 1 }
}

module ControlFlow = CfgImpl::ControlFlow;
