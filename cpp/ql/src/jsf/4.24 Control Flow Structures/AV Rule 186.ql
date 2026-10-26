/**
 * @name AV Rule 186
 * @description There shall be no unreachable code.
 * @kind problem
 * @id cpp/jsf/av-rule-186
 * @problem.severity recommendation
 * @tags maintainability
 *       useless-code
 *       external/jsf
 */

import cpp

// whether f is to be considered an API entry point, and hence reachable by default
predicate isApi(Function f) {
  f.hasName("main") or
  f.(MemberFunction).hasSpecifier("public")
}

predicate unusedFunction(Function f) {
  not isApi(f) and
  not exists(FunctionCall c | c.getTarget() = f) and
  not exists(Access acc | acc.getTarget() = f) and
  f.hasDefinition()
}

predicate unreachableStmt(Stmt s) { not s.getControlFlowScope().getBlock().getASuccessor*() = s }

from ControlFlowNode n
where unreachableStmt(n) or unusedFunction(n)
select n, "AV Rule 186: There shall be no unreachable code."
