/**
 * @id java/label-in-switch
 * @name Non-case label in switch statement
 * @description A non-case label appearing in a switch statement
 *              is confusing to read or may even indicate a bug.
 * @previous-id java/label-in-case
 * @kind problem
 * @precision very-high
 * @problem.severity recommendation
 * @tags quality
 *       maintainability
 *       readability
 */

import java

from LabeledStmt l, SwitchStmt s, string alert
where
  l = s.getAStmt+() and
  if exists(JumpStmt jump | jump.getTargetLabel() = l)
  then alert = "Confusing non-case label in switch statement."
  else
    alert =
      "Possibly erroneous non-case label in switch statement. The case keyword might be missing."
select l, alert
