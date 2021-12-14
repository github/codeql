/**
 * @name AV Rule 193
 * @description Every non-empty case clause in a switch statement
 *              shall be terminated with a break statement.
 * @kind problem
 * @id cpp/jsf/av-rule-193
 * @problem.severity warning
 * @tags correctness
 *       readability
 *       external/jsf
 */

import cpp

/*
 * Interpretation:
 *   - return statements should be okay too; if not desired another rule should catch it
 *   - the default case should be excluded, as long as it is at the end
 * We don't allow the last case to omit the break/return, because that seems to violate the
 * spirit of the rule (what if another case was added?)
 */

predicate lastDefaultCase(SwitchCase sc) {
  sc.isDefault() and
  not exists(SwitchCase sc2 |
    sc2.getSwitchStmt() = sc.getSwitchStmt() and sc2.getChildNum() > sc.getChildNum()
  )
}

from SwitchCase sc
where
  sc.fromSource() and
  exists(sc.getAStmt()) and
  not lastDefaultCase(sc) and
  not sc.terminatesInBreakStmt() and
  not sc.terminatesInReturnStmt()
select sc,
  "AV Rule 193: Every non-empty case clause in a switch statement shall be terminated with a break statement."
