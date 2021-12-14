import python

/** A basic block which terminates in a condition, splitting the subsequent control flow */
class ConditionBlock extends BasicBlock {
  ConditionBlock() {
    exists(ControlFlowNode succ |
      succ = this.getATrueSuccessor() or succ = this.getAFalseSuccessor()
    )
  }

  /** Basic blocks controlled by this condition, i.e. those BBs for which the condition is testIsTrue */
  pragma[nomagic]
  predicate controls(BasicBlock controlled, boolean testIsTrue) {
    /*
     * For this block to control the block 'controlled' with 'testIsTrue' the following must be true:
     * Execution must have passed through the test i.e. 'this' must strictly dominate 'controlled'.
     * Execution must have passed through the 'testIsTrue' edge leaving 'this'.
     *
     * Although "passed through the true edge" implies that this.getATrueSuccessor() dominates 'controlled',
     * the reverse is not true, as flow may have passed through another edge to get to this.getATrueSuccessor()
     * so we need to assert that this.getATrueSuccessor() dominates 'controlled' *and* that
     * all predecessors of this.getATrueSuccessor() are either this or dominated by this.getATrueSuccessor().
     *
     * For example, in the following python snippet:
     * <code>
     *    if x:
     *        controlled
     *    false_successor
     *    uncontrolled
     * </code>
     * false_successor dominates uncontrolled, but not all of its predecessors are this (if x)
     * or dominated by itself. Whereas in the following code:
     * <code>
     *    if x:
     *        while controlled:
     *            also_controlled
     *    false_successor
     *    uncontrolled
     * </code>
     * the block 'while controlled' is controlled because all of its predecessors are this (if x)
     * or (in the case of 'also_controlled') dominated by itself.
     *
     * The additional constraint on the predecessors of the test successor implies
     * that `this` strictly dominates `controlled` so that isn't necessary to check
     * directly.
     */

    exists(BasicBlock succ |
      testIsTrue = true and succ = this.getATrueSuccessor()
      or
      testIsTrue = false and succ = this.getAFalseSuccessor()
    |
      succ.dominates(controlled) and
      forall(BasicBlock pred | pred.getASuccessor() = succ | pred = this or succ.dominates(pred))
    )
  }

  /** Holds if this condition controls the edge `pred->succ`, i.e. those edges for which the condition is `testIsTrue`. */
  predicate controlsEdge(BasicBlock pred, BasicBlock succ, boolean testIsTrue) {
    this.controls(pred, testIsTrue) and succ = pred.getASuccessor()
    or
    pred = this and
    (
      testIsTrue = true and succ = this.getATrueSuccessor()
      or
      testIsTrue = false and succ = this.getAFalseSuccessor()
    )
  }
}
