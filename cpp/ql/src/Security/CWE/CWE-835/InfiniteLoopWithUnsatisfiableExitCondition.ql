/**
 * @name Infinite loop with unsatisfiable exit condition
 * @description A loop with an unsatisfiable exit condition could
 *              prevent the program from terminating, making it
 *              vulnerable to a denial of service attack.
 * @kind problem
 * @id cpp/infinite-loop-with-unsatisfiable-exit-condition
 * @problem.severity warning
 * @security-severity 7.5
 * @tags security
 *       external/cwe/cwe-835
 */

import cpp
import semmle.code.cpp.controlflow.BasicBlocks
private import semmle.code.cpp.rangeanalysis.PointlessComparison
import semmle.code.cpp.controlflow.internal.ConstantExprs

/**
 * Holds if there is a control flow edge from `src` to `dst`, but
 * it can never be taken due to `cmp` always having value `value`.
 */
predicate impossibleEdge(ComparisonOperation cmp, boolean value, BasicBlock src, BasicBlock dst) {
  cmp = src.getEnd() and
  reachablePointlessComparison(cmp, _, _, value, _) and
  if value = true then dst = src.getAFalseSuccessor() else dst = src.getATrueSuccessor()
}

BasicBlock enhancedSucc(BasicBlock bb) {
  result = bb.getASuccessor() and not impossibleEdge(_, _, bb, result)
}

/**
 * Holds if `cmp` always has value `value`, and if that will cause
 * non-termination.
 *
 * It only holds if the function exit is reachable using
 * the standard `getASuccessor` relation, but not using
 * `enhancedSucc`. This means that it does not hold for
 * comparison operations which are trivially true or false, such as
 * ```
 * while (1) { ... }
 * ```
 * Since this loop is obviously infinite, we assume that it was written
 * intentionally.
 */
predicate impossibleEdgeCausesNonTermination(ComparisonOperation cmp, boolean value) {
  exists(BasicBlock src |
    impossibleEdge(cmp, value, src, _) and
    src.getASuccessor+() instanceof ExitBasicBlock and
    not enhancedSucc+(src) instanceof ExitBasicBlock and
    // Make sure that the source is reachable to reduce
    // false positives.
    exists(EntryBasicBlock entry | src = enhancedSucc+(entry))
  )
}

from ComparisonOperation cmp, boolean value
where impossibleEdgeCausesNonTermination(cmp, value)
select cmp,
  "Function exit is unreachable because this condition is always " + value.toString() + "."
