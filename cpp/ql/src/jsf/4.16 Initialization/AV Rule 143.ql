/**
 * @name AV Rule 143
 * @description Variables will not be introduced until they can be initialized
 *              with meaningful values.
 * @kind problem
 * @id cpp/jsf/av-rule-143
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

// whether s defines variable v (conservative)
predicate defines(VariableAccess va, Variable lv) { va.getTarget() = lv and va.isLValue() }

// whether s uses variable v (conservative)
predicate uses(ControlFlowNode s, Variable lv) {
  exists(VariableAccess va |
    va = s and
    va.getTarget() = lv and
    va.isRValue() and
    not va.getParent+() instanceof SizeofOperator
  )
}

// whether there is a path from the declaration of lv to n such that lv is definitely not used or defined
// before n
predicate noDefUsePath(LocalVariable lv, ControlFlowNode n) {
  n.(DeclStmt).getADeclaration() = lv
  or
  exists(ControlFlowNode p |
    noDefUsePath(lv, p) and
    n = p.getASuccessor() and
    not defines(p, lv) and
    not uses(p, lv)
  )
}

predicate neighbouringStmts(Stmt s1, Stmt s2) {
  exists(BlockStmt b, int i |
    i in [0 .. b.getNumStmt() - 2] and
    s1 = b.getStmt(i) and
    s2 = b.getStmt(i + 1)
  )
}

from LocalVariable lv, VariableAccess def, DeclStmt d
where
  lv.fromSource() and
  d.getADeclaration() = lv and
  noDefUsePath(lv, def) and
  defines(def, lv) and
  not neighbouringStmts(d, def.getEnclosingStmt()) and
  not exists(ControlFlowNode use | noDefUsePath(lv, use) and uses(use, lv))
select def,
  "AV Rule 143: Variables will not be introduced until they can be initialized with meaningful values."
