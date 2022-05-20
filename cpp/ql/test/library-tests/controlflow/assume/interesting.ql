import cpp

predicate interesting(ControlFlowNode n) {
  n instanceof AssumeExpr or
  n instanceof FunctionCall
}

predicate ptrUnassigned(ControlFlowNode n) {
  // declaration of `ptr`
  n.(DeclStmt).getADeclaration().getName() = "ptr"
  or
  // flow
  exists(ControlFlowNode pred |
    ptrUnassigned(pred) and
    pred.getASuccessor() = n and
    not pred.(AssignExpr).getLValue().(Access).getTarget().getName() = "ptr"
  )
}

from ControlFlowNode n, string r, string p
where
  interesting(n) and
  (if reachable(n) then r = "reachable" else r = "") and
  if ptrUnassigned(n) then p = "unassigned ptr" else p = ""
select n, count(n.getAPredecessor()), count(n.getASuccessor()), r, p
