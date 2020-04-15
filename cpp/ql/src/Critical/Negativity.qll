import cpp

/**
 * Holds if `val` is an access to the variable `v`, or if `val`
 * is an assignment with an access to `v` on the left-hand side.
 */
predicate valueOfVar(Variable v, Expr val) {
  val = v.getAnAccess() or
  val.(AssignExpr).getLValue() = v.getAnAccess()
}

/**
 * Holds if either:
 * - `cond` is an (in)equality expression that compares the variable `v` to the value `-1`, or
 * - `cond` is a relational expression that compares the variable `v` to a constant.
 */
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

/**
 * Holds if `node` is an expression in a conditional statement and `succ` is an
 * immediate successor of `node` that may be reached after evaluating `node`.
 * For example, given
 * ```
 * if (a < 10 && b) func1();
 * else func2();
 * ```
 * this predicate holds when either:
 * - `node` is `a < 10` and `succ` is `func2()` or `b`, or
 * - `node` is `b` and `succ` is `func1()` or `func2()`
 */
predicate conditionalSuccessor(ControlFlowNode node, ControlFlowNode succ) {
  if node.isCondition()
  then succ = node.getATrueSuccessor() or succ = node.getAFalseSuccessor()
  else
    exists(BinaryLogicalOperation binop |
      binop.getAnOperand() = node and conditionalSuccessor(binop, succ)
    )
}

/**
 * Holds if the current value of the variable `v` at control-flow
 * node `n` has been used either in:
 * - an (in)equality comparison with the value `-1`, or
 * - a relational comparison that compares `v` to a constant.
 */
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

/**
 * Holds if `cond` compares `v` to some common error values. Specifically, this
 * predicate holds when:
 * - `cond` checks that `v` is equal to `-1`, or
 * - `cond` checks that `v` is less than `0`, or
 * - `cond` checks that `v` is less than or equal to `-1`, or
 * - `cond` checks that `v` is not some common success value (see `successCondition`).
 */
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

/**
 * Holds if `cond` compares `v` to some common success values. Specifically, this
 * predicate holds when:
 * - `cond` checks that `v` is not equal to `-1`, or
 * - `cond` checks that `v` is greater than or equal than `0`, or
 * - `cond` checks that `v` is greater than `-1`, or
 * - `cond` checks that `v` is not some common error value (see `errorCondition`).
 */
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

/**
 * Holds if there exists a comparison operation that checks whether `v`
 * represents some common *error* values, and `n` may be reached
 * immediately following the comparison operation.
 */
predicate errorSuccessor(Variable v, ControlFlowNode n) {
  exists(Expr cond |
    errorCondition(v, cond) and n = cond.getATrueSuccessor()
    or
    successCondition(v, cond) and n = cond.getAFalseSuccessor()
  )
}

/**
 * Holds if there exists a comparison operation that checks whether `v`
 * represents some common *success* values, and `n` may be reached
 * immediately following the comparison operation.
 */
predicate successSuccessor(Variable v, ControlFlowNode n) {
  exists(Expr cond |
    successCondition(v, cond) and n = cond.getATrueSuccessor()
    or
    errorCondition(v, cond) and n = cond.getAFalseSuccessor()
  )
}

/**
 * Holds if the current value of the variable `v` at control-flow node
 * `n` may have been checked against a common set of *error* values.
 */
predicate checkedError(Variable v, ControlFlowNode n) {
  errorSuccessor(v, n)
  or
  exists(ControlFlowNode mid |
    checkedError(v, mid) and
    n = mid.getASuccessor() and
    not definitionBarrier(v, mid)
  )
}

/**
 * Holds if the current value of the variable `v` at control-flow node
 * `n` may have been checked against a common set of *success* values.
 */
predicate checkedSuccess(Variable v, ControlFlowNode n) {
  successSuccessor(v, n)
  or
  exists(ControlFlowNode mid |
    checkedSuccess(v, mid) and
    n = mid.getASuccessor() and
    not definitionBarrier(v, mid)
  )
}
