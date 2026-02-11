/**
 * @name Duplicate switch case
 * @description If two cases in a switch statement have the same label, the second case
 *              will never be executed.
 * @kind problem
 * @problem.severity error
 * @id go/duplicate-switch-case
 * @tags quality
 *       reliability
 *       correctness
 *       external/cwe/cwe-561
 * @precision very-high
 */

import go

/** Gets the global value number of `e`, which is the `i`th case label of `switch`. */
GVN switchCaseGvn(SwitchStmt switch, int i, Expr e) {
  e = switch.getCase(i).getExpr(0) and result = e.getGlobalValueNumber()
}

from SwitchStmt switch, int i, Expr e, int j, Expr f
where switchCaseGvn(switch, i, e) = switchCaseGvn(switch, j, f) and i < j
select f, "This case is a duplicate of an $@.", e, "earlier case"
