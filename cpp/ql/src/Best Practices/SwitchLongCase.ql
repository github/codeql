/**
 * @name Long switch case
 * @description A switch statement with too much code in its cases can make the control flow hard to follow. Consider wrapping the code for each case in a function and just using the switch statement to invoke the appropriate function in each case.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/long-switch
 * @tags maintainability
 *       readability
 */

import cpp

predicate switchCaseStartLine(SwitchCase sc, int start) { sc.getLocation().getStartLine() = start }

predicate switchStmtEndLine(SwitchStmt s, int start) { s.getLocation().getEndLine() = start }

predicate switchCaseLength(SwitchCase sc, int length) {
  exists(SwitchCase next, int l1, int l2 |
    next = sc.getNextSwitchCase() and
    switchCaseStartLine(next, l1) and
    switchCaseStartLine(sc, l2) and
    length = l1 - l2 - 1
  )
  or
  not exists(sc.getNextSwitchCase()) and
  exists(int l1, int l2 |
    switchStmtEndLine(sc.getSwitchStmt(), l1) and
    switchCaseStartLine(sc, l2) and
    length = l1 - l2 - 1
  )
}

predicate tooLong(SwitchCase sc) { exists(int n | switchCaseLength(sc, n) and n > 30) }

from SwitchStmt switch, SwitchCase sc, int lines
where
  sc = switch.getASwitchCase() and
  tooLong(sc) and
  switchCaseLength(sc, lines)
select switch, "Switch has at least one case that is too long: $@", sc,
  sc.getExpr().toString() + " (" + lines.toString() + " lines)"
