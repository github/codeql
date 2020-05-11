/**
 * @name Except block handles 'BaseException'
 * @description Handling 'BaseException' means that system exits and keyboard interrupts may be mis-handled.
 * @kind problem
 * @tags reliability
 *       readability
 *       convention
 *       external/cwe/cwe-396
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/catch-base-exception
 */

import python

predicate doesnt_reraise(ExceptStmt ex) { ex.getAFlowNode().getBasicBlock().reachesExit() }

predicate catches_base_exception(ExceptStmt ex) {
  ex.getType().pointsTo(ClassValue::baseException())
  or
  not exists(ex.getType())
}

from ExceptStmt ex
where
  catches_base_exception(ex) and
  doesnt_reraise(ex)
select ex, "Except block directly handles BaseException."
