/** Provides classes representing basic blocks. */

private import codeql.actions.Cfg as Cfg

/**
 * A basic block, that is, a maximal straight-line sequence of control flow nodes
 * without branches or joins.
 */
class BasicBlock extends Cfg::BasicBlock {
  /** Gets an immediate successor of this basic block, if any. */
  BasicBlock getASuccessor() { result = super.getASuccessor() }

  /** Gets an immediate successor of this basic block of a given type, if any. */
  BasicBlock getASuccessor(Cfg::SuccessorType t) { result = super.getASuccessor(t) }

  /** Gets an immediate predecessor of this basic block, if any. */
  BasicBlock getAPredecessor() { result = super.getAPredecessor() }

  /** Gets an immediate predecessor of this basic block of a given type, if any. */
  BasicBlock getAPredecessor(Cfg::SuccessorType t) { result = super.getAPredecessor(t) }

  /** Gets the control flow node at a specific (zero-indexed) position in this basic block. */
  Cfg::Node getNode(int pos) { result = super.getNode(pos) }

  /** Gets a control flow node in this basic block. */
  Cfg::Node getANode() { result = super.getANode() }

  /** Gets the first control flow node in this basic block. */
  Cfg::Node getFirstNode() { result = super.getFirstNode() }

  /** Gets the last control flow node in this basic block. */
  Cfg::Node getLastNode() { result = super.getLastNode() }

  predicate immediatelyDominates(BasicBlock bb) { super.immediatelyDominates(bb) }

  predicate strictlyDominates(BasicBlock bb) { super.strictlyDominates(bb) }

  predicate dominates(BasicBlock bb) { super.dominates(bb) }

  predicate inDominanceFrontier(BasicBlock df) { super.inDominanceFrontier(df) }

  BasicBlock getImmediateDominator() { result = super.getImmediateDominator() }

  predicate strictlyPostDominates(BasicBlock bb) { super.strictlyPostDominates(bb) }

  predicate postDominates(BasicBlock bb) { super.postDominates(bb) }
}

/**
 * An entry basic block, that is, a basic block whose first node is
 * an entry node.
 */
class EntryBasicBlock extends BasicBlock, Cfg::EntryBasicBlock { }

/**
 * An annotated exit basic block, that is, a basic block that contains an
 * annotated exit node.
 */
class AnnotatedExitBasicBlock extends BasicBlock {
  AnnotatedExitBasicBlock() { this.getANode() instanceof Cfg::AnnotatedExitNode }

  /** Holds if this block represents a normal exit. */
  final predicate isNormal() { this.getANode() instanceof Cfg::NormalExitNode }
}

/**
 * An exit basic block, that is, a basic block whose last node is
 * an exit node.
 */
class ExitBasicBlock extends BasicBlock {
  ExitBasicBlock() { this.getLastNode() instanceof Cfg::ExitNode }
}

/** A basic block with more than one predecessor. */
class JoinBlock extends BasicBlock {
  JoinBlock() { strictcount(this.getFirstNode().getAPredecessor()) > 1 }

  /**
   * Gets the `i`th predecessor of this join block, with respect to some
   * arbitrary order.
   */
  JoinBlockPredecessor getJoinBlockPredecessor(int i) { none() }
}

/** A basic block that is an immediate predecessor of a join block. */
class JoinBlockPredecessor extends BasicBlock {
  JoinBlockPredecessor() { this.getASuccessor() instanceof JoinBlock }
}

/** A basic block that terminates in a condition, splitting the subsequent control flow. */
class ConditionBlock extends BasicBlock {
  ConditionBlock() {
    exists(this.getLastNode().getASuccessor(any(Cfg::BooleanSuccessor successor)))
  }

  /**
   * Holds if basic block `succ` is immediately controlled by this basic
   * block with conditional value `s`.
   */
  predicate immediatelyControls(BasicBlock succ, Cfg::BooleanSuccessor s) {
    succ = this.getASuccessor(s) and
    forall(BasicBlock pred | pred = succ.getAPredecessor() and pred != this | succ.dominates(pred))
  }

  /**
   * Holds if basic block `controlled` is controlled by this basic block with
   * conditional value `s`.
   */
  predicate controls(BasicBlock controlled, Cfg::BooleanSuccessor s) {
    exists(BasicBlock succ | this.immediatelyControls(succ, s) and succ.dominates(controlled))
  }
}
