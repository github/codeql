/**
 * @name Non-case label in switch statement
 * @description A non-case label appearing in a switch statement that is textually aligned with a case
 *              label is confusing to read, or may even indicate a bug.
 * @kind problem
 * @problem.severity warning
 * @id js/label-in-switch
 * @tags reliability
 *       readability
 * @precision very-high
 */

import javascript

int labelInCaseStartColumn(Case c, LabeledStmt l) {
  l = c.getAChildStmt+() and
  result = l.getLocation().getStartColumn()
}

from LabeledStmt l, Case c
where labelInCaseStartColumn(c, l) = c.getLocation().getStartColumn()
select l.getChildExpr(0), "Non-case labels in switch statements are confusing."
