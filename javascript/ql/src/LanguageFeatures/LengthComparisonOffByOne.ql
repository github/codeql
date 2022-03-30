/**
 * @name Off-by-one comparison against length
 * @description An array index is compared to be less than or equal to the 'length' property,
 *              and then used in an indexing operation that could be out of bounds.
 * @kind problem
 * @problem.severity warning
 * @id js/index-out-of-bounds
 * @tags reliability
 *       correctness
 *       logic
 *       external/cwe/cwe-193
 * @precision high
 */

import javascript

/**
 * Gets an access to `array.length`.
 */
PropAccess arrayLen(Variable array) { result.accesses(array.getAnAccess(), "length") }

/**
 * Gets a condition that checks that `index` is less than or equal to `array.length`.
 */
ConditionGuardNode getLengthLEGuard(Variable index, Variable array) {
  exists(RelationalComparison cmp | cmp instanceof GEExpr or cmp instanceof LEExpr |
    cmp = result.getTest() and
    result.getOutcome() = true and
    cmp.getGreaterOperand() = arrayLen(array) and
    cmp.getLesserOperand() = index.getAnAccess()
  )
}

/**
 * Gets a condition that checks that `index` is not equal to `array.length`.
 */
ConditionGuardNode getLengthNEGuard(Variable index, Variable array) {
  exists(EqualityTest eq |
    eq = result.getTest() and
    result.getOutcome() = eq.getPolarity().booleanNot() and
    eq.hasOperands(index.getAnAccess(), arrayLen(array))
  )
}

/**
 * Holds if `ea` is a read from `array[index]` in basic block `bb`.
 */
predicate elementRead(IndexExpr ea, Variable array, Variable index, BasicBlock bb) {
  ea.getBase() = array.getAnAccess() and
  ea.getIndex() = index.getAnAccess() and
  ea instanceof RValue and
  bb = ea.getBasicBlock()
}

from ConditionGuardNode cond, Variable array, Variable index, IndexExpr ea, BasicBlock bb
where
  // there is a comparison `index <= array.length`
  cond = getLengthLEGuard(index, array) and
  // there is a read from `array[index]`
  elementRead(ea, array, index, bb) and
  // and the read is guarded by the comparison
  cond.dominates(bb) and
  // but the read is not guarded by another check that `index != array.length`
  not getLengthNEGuard(index, array).dominates(bb)
select cond.getTest(), "Off-by-one index comparison against length may lead to out-of-bounds $@.",
  ea, "read"
