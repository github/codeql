import cpp

predicate valueOfVar(Variable v, Expr val) {
  val = v.getAnAccess() or
  val.(AssignExpr).getLValue() = v.getAnAccess()
}

predicate boundsCheckExpr(Variable v, Expr cond) {
  exists(EQExpr eq |
    cond = eq and
    eq.getAnOperand().getValue() = "-1" and
    valueOfVar(v, eq.getAnOperand())
  )
  or
  exists(NEExpr ne |
    cond = ne and
    ne.getAnOperand().getValue() = "-1" and
    valueOfVar(v, ne.getAnOperand())
  )
  or
  exists(LTExpr lt |
    cond = lt and
    valueOfVar(v, lt.getAnOperand()) and
    exists(lt.getAnOperand().getValue())
  )
  or
  exists(LEExpr le |
    cond = le and
    valueOfVar(v, le.getAnOperand()) and
    exists(le.getAnOperand().getValue())
  )
  or
  exists(GTExpr gt |
    cond = gt and
    valueOfVar(v, gt.getAnOperand()) and
    exists(gt.getAnOperand().getValue())
  )
  or
  exists(GEExpr ge |
    cond = ge and
    valueOfVar(v, ge.getAnOperand()) and
    exists(ge.getAnOperand().getValue())
  )
}

predicate conditionalSuccessor(ControlFlowNode node, ControlFlowNode succ) {
  if node.isCondition()
  then succ = node.getATrueSuccessor() or succ = node.getAFalseSuccessor()
  else
    exists(BinaryLogicalOperation binop |
      binop.getAnOperand() = node and conditionalSuccessor(binop, succ)
    )
}

predicate boundsChecked(Variable v, ControlFlowNode node) {
  exists(Expr test |
    boundsCheckExpr(v, test) and
    conditionalSuccessor(test, node)
  )
  or
  exists(ControlFlowNode mid |
    boundsChecked(v, mid) and mid = node.getAPredecessor() and not definitionBarrier(v, mid)
  )
}

predicate errorCondition(Variable v, Expr cond) {
  exists(EQExpr eq |
    cond = eq and
    eq.getAnOperand().getValue() = "-1" and
    eq.getAnOperand() = v.getAnAccess()
  )
  or
  exists(LTExpr lt |
    cond = lt and
    lt.getLeftOperand() = v.getAnAccess() and
    lt.getRightOperand().getValue() = "0"
  )
  or
  exists(LEExpr le |
    cond = le and
    le.getRightOperand() = v.getAnAccess() and
    le.getRightOperand().getValue() = "-1"
  )
  or
  exists(NotExpr ne |
    cond = ne and
    successCondition(v, ne.getOperand())
  )
}

predicate successCondition(Variable v, Expr cond) {
  exists(NEExpr ne |
    cond = ne and
    ne.getAnOperand().getValue() = "-1" and
    ne.getAnOperand() = v.getAnAccess()
  )
  or
  exists(GEExpr ge |
    cond = ge and
    ge.getLeftOperand() = v.getAnAccess() and
    ge.getRightOperand().getValue() = "0"
  )
  or
  exists(GTExpr gt |
    cond = gt and
    gt.getRightOperand() = v.getAnAccess() and
    gt.getRightOperand().getValue() = "-1"
  )
  or
  exists(NotExpr ne |
    cond = ne and
    errorCondition(v, ne.getOperand())
  )
}

predicate errorSuccessor(Variable v, ControlFlowNode n) {
  exists(Expr cond |
    errorCondition(v, cond) and n = cond.getATrueSuccessor()
    or
    successCondition(v, cond) and n = cond.getAFalseSuccessor()
  )
}

predicate successSuccessor(Variable v, ControlFlowNode n) {
  exists(Expr cond |
    successCondition(v, cond) and n = cond.getATrueSuccessor()
    or
    errorCondition(v, cond) and n = cond.getAFalseSuccessor()
  )
}

predicate checkedError(Variable v, ControlFlowNode n) {
  errorSuccessor(v, n)
  or
  exists(ControlFlowNode mid |
    checkedError(v, mid) and
    n = mid.getASuccessor() and
    not definitionBarrier(v, mid)
  )
}

predicate checkedSuccess(Variable v, ControlFlowNode n) {
  successSuccessor(v, n)
  or
  exists(ControlFlowNode mid |
    checkedSuccess(v, mid) and
    n = mid.getASuccessor() and
    not definitionBarrier(v, mid)
  )
}
