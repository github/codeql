/**
 * @name Duplicate switch case
 * @description If two cases in a switch statement have the same label, the second case
 *              will never be executed.
 * @kind problem
 * @problem.severity error
 * @id go/duplicate-switch-case
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-561
 * @precision very-high
 */

import go

/** Gets the global value number of of `e`, which is the `i`th case label of `switch`. */
GVN switchCaseGVN(SwitchStmt switch, int i, Expr e) {
  e = switch.getCase(i).getExpr(0) and result = e.getGlobalValueNumber()
}

from SwitchStmt switch, int i, Expr e, int j, Expr f
where switchCaseGVN(switch, i, e) = switchCaseGVN(switch, j, f) and i < j
select f, "This case is a duplicate of $@.", e, "an earlier case"
