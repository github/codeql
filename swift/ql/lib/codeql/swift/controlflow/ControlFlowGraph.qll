/** Provides classes representing the control flow graph. */

private import swift
private import BasicBlocks
private import SuccessorTypes
private import internal.ControlFlowGraphImpl as CfgImpl
private import internal.Completion
private import internal.Scope
private import internal.ControlFlowElements

/** An AST node with an associated control-flow graph. */
class CfgScope extends Scope instanceof CfgImpl::CfgScope::Range_ {
  /** Gets the CFG scope that this scope is nested under, if any. */
  final CfgScope getOuterCfgScope() {
    exists(ControlFlowElement parent |
      parent.asAstNode() = getParentOfAst(this) and
      result = CfgImpl::getCfgScope(parent)
    )
  }
}

/**
 * A control flow node.
 *
 * A control flow node is a node in the control flow graph (CFG). There is a
 * many-to-one relationship between CFG nodes and AST nodes.
 *
 * Only nodes that can be reached from an entry point are included in the CFG.
 */
class ControlFlowNode extends CfgImpl::Node {
  /** Gets the AST node that this node corresponds to, if any. */
  ControlFlowElement getNode() { none() }

  /** Gets the file of this control flow node. */
  final File getFile() { result = this.getLocation().getFile() }

  /** Holds if this control flow node has conditional successors. */
  final predicate isCondition() { exists(this.getASuccessor(any(BooleanSuccessor bs))) }

  /** Gets the scope of this node. */
  final CfgScope getScope() { result = this.getBasicBlock().getScope() }

  /** Gets the basic block that this control flow node belongs to. */
  BasicBlock getBasicBlock() { result.getANode() = this }

  /** Gets a successor node of a given type, if any. */
  final ControlFlowNode getASuccessor(SuccessorType t) { result = super.getASuccessor(t) }

  /** Gets an immediate successor, if any. */
  final ControlFlowNode getASuccessor() { result = this.getASuccessor(_) }

  /** Gets an immediate predecessor node of a given flow type, if any. */
  final ControlFlowNode getAPredecessor(SuccessorType t) { result.getASuccessor(t) = this }

  /** Gets an immediate predecessor, if any. */
  final ControlFlowNode getAPredecessor() { result = this.getAPredecessor(_) }

  /** Holds if this node has more than one predecessor. */
  final predicate isJoin() { strictcount(this.getAPredecessor()) > 1 }

  /** Holds if this node has more than one successor. */
  final predicate isBranch() { strictcount(this.getASuccessor()) > 1 }
}

/** The type of a control flow successor. */
class SuccessorType extends CfgImpl::TSuccessorType {
  /** Gets a textual representation of successor type. */
  string toString() { none() }
}

/** Provides different types of control flow successor types. */
module SuccessorTypes {
  /** A normal control flow successor. */
  class NormalSuccessor extends SuccessorType, CfgImpl::TSuccessorSuccessor {
    final override string toString() { result = "successor" }
  }

  /** A conditional control flow successor. */
  abstract class ConditionalSuccessor extends SuccessorType {
    boolean value;

    bindingset[value]
    ConditionalSuccessor() { any() }

    /** Gets the Boolean value of this successor. */
    final boolean getValue() { result = value }

    override string toString() { result = this.getValue().toString() }
  }

  /** A Boolean control flow successor. */
  class BooleanSuccessor extends ConditionalSuccessor, CfgImpl::TBooleanSuccessor {
    BooleanSuccessor() { this = CfgImpl::TBooleanSuccessor(value) }
  }

  class BreakSuccessor extends SuccessorType, CfgImpl::TBreakSuccessor {
    final override string toString() { result = "break" }
  }

  class ContinueSuccessor extends SuccessorType, CfgImpl::TContinueSuccessor {
    final override string toString() { result = "continue" }
  }

  class ReturnSuccessor extends SuccessorType, CfgImpl::TReturnSuccessor {
    final override string toString() { result = "return" }
  }

  class MatchingSuccessor extends ConditionalSuccessor, CfgImpl::TMatchingSuccessor {
    MatchingSuccessor() { this = CfgImpl::TMatchingSuccessor(value) }

    /** Holds if this is a match successor. */
    predicate isMatch() { value = true }

    override string toString() { if this.isMatch() then result = "match" else result = "no-match" }
  }

  class FallthroughSuccessor extends SuccessorType, CfgImpl::TFallthroughSuccessor {
    final override string toString() { result = "fallthrough" }
  }

  class EmptinessSuccessor extends ConditionalSuccessor, CfgImpl::TEmptinessSuccessor {
    EmptinessSuccessor() { this = CfgImpl::TEmptinessSuccessor(value) }

    predicate isEmpty() { value = true }

    override string toString() { if this.isEmpty() then result = "empty" else result = "non-empty" }
  }

  class ExceptionSuccessor extends SuccessorType, CfgImpl::TExceptionSuccessor {
    override string toString() { result = "exception" }
  }
}
