/**
 * @name Loop iteration skipped due to shifting
 * @description Removing elements from an array while iterating over it can cause the loop to skip over some elements,
 *              unless the loop index is decremented accordingly.
 * @kind problem
 * @problem.severity warning
 * @id js/loop-iteration-skipped-due-to-shifting
 * @tags correctness
 * @precision high
 */

import javascript

/**
 * An operation that inserts or removes elements from an array while shifting all elements
 * occuring after the insertion/removal point.
 *
 * Does not include `push` and `pop` since these never shift any elements.
 */
class ArrayShiftingCall extends DataFlow::MethodCallNode {
  string name;

  ArrayShiftingCall() {
    name = getMethodName() and
    (name = "splice" or name = "shift" or name = "unshift")
  }

  DataFlow::SourceNode getArray() { result = getReceiver().getALocalSource() }
}

/**
 * A call to `splice` on an array.
 */
class SpliceCall extends ArrayShiftingCall {
  SpliceCall() { name = "splice" }

  /**
   * Gets the index from which elements are removed and possibly new elemenst are inserted.
   */
  DataFlow::Node getIndex() { result = getArgument(0) }

  /**
   * Gets the number of removed elements.
   */
  int getNumRemovedElements() {
    result = getArgument(1).asExpr().getIntValue() and
    result >= 0
  }

  /**
   * Gets the number of inserted elements.
   */
  int getNumInsertedElements() {
    result = getNumArgument() - 2 and
    result >= 0
  }
}

/**
 * A `for` loop iterating over the indices of an array, in increasing order.
 */
class ArrayIterationLoop extends ForStmt {
  DataFlow::SourceNode array;
  LocalVariable indexVariable;

  ArrayIterationLoop() {
    exists(RelationalComparison compare | compare = getTest() |
      compare.getLesserOperand() = indexVariable.getAnAccess() and
      compare.getGreaterOperand() = array.getAPropertyRead("length").asExpr()
    ) and
    getUpdate().(IncExpr).getOperand() = indexVariable.getAnAccess()
  }

  /**
   * Gets the variable holding the loop variable and current array index.
   */
  LocalVariable getIndexVariable() { result = indexVariable }

  /**
   * Gets the loop entry point.
   */
  ReachableBasicBlock getLoopEntry() {
    result = getTest().getFirstControlFlowNode().getBasicBlock()
  }

  /**
   * Gets a call that potentially shifts the elements of the given array.
   */
  ArrayShiftingCall getAnArrayShiftingCall() { result.getArray() = array }

  /**
   * Gets a call to `splice` that removes elements from the looped-over array at the current index
   *
   * The `splice` call is not guaranteed to be inside the loop body.
   */
  SpliceCall getACandidateSpliceCall() {
    result = getAnArrayShiftingCall() and
    result.getIndex().asExpr() = getIndexVariable().getAnAccess() and
    result.getNumRemovedElements() > result.getNumInsertedElements()
  }

  /**
   * Holds if `cfg` modifies the index variable or shifts array elements, disturbing the
   * relationship between the array and the index variable.
   */
  predicate hasIndexingManipulation(ControlFlowNode cfg) {
    cfg.(VarDef).getAVariable() = getIndexVariable() or
    cfg = getAnArrayShiftingCall().asExpr()
  }

  /**
   * Holds if there is a `loop entry -> cfg` path that does not involve index manipulation or a successful index equality check.
   */
  predicate hasPathTo(ControlFlowNode cfg) {
    exists(getACandidateSpliceCall()) and // restrict size of predicate
    cfg = getLoopEntry().getFirstNode()
    or
    hasPathTo(cfg.getAPredecessor()) and
    getLoopEntry().dominates(cfg.getBasicBlock()) and
    not hasIndexingManipulation(cfg) and
    // Ignore splice calls guarded by an index equality check.
    // This indicates that the index of an element is the basis for removal, not its value,
    // which means it may be okay to skip over elements.
    not exists(ConditionGuardNode guard, EqualityTest test | cfg = guard |
      test = guard.getTest() and
      test.getAnOperand() = getIndexVariable().getAnAccess() and
      guard.getOutcome() = test.getPolarity()
    ) and
    // Block flow after inspecting an array element other than that at the current index.
    // For example, if the splice happens after inspecting `array[i + 1]`, then the next
    // element has already been "looked at" and so it doesn't matter if we skip it.
    not exists(IndexExpr index | cfg = index |
      array.flowsToExpr(index.getBase()) and
      not index.getIndex() = getIndexVariable().getAnAccess()
    )
  }

  /**
   * Holds if there is a `loop entry -> splice -> cfg` path that does not involve index manipulation,
   * other than the `splice` call.
   */
  predicate hasPathThrough(SpliceCall splice, ControlFlowNode cfg) {
    splice = getACandidateSpliceCall() and
    cfg = splice.asExpr() and
    hasPathTo(cfg.getAPredecessor())
    or
    hasPathThrough(splice, cfg.getAPredecessor()) and
    getLoopEntry().dominates(cfg.getBasicBlock()) and
    not hasIndexingManipulation(cfg)
  }
}

from ArrayIterationLoop loop, SpliceCall splice
where loop.hasPathThrough(splice, loop.getUpdate().getFirstControlFlowNode())
select splice,
  "Removing an array item without adjusting the loop index '" + loop.getIndexVariable().getName() +
    "' causes the subsequent array item to be skipped."
