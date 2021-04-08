/**
 * @name Opposite operator definition
 * @description When two operators are opposites, both should be defined and one should be defined in terms of the other.
 * @kind problem
 * @id cpp/jsf/av-rule-85
 * @problem.severity warning
 * @tags maintainability
 *       reliability
 *       external/jsf
 */

import cpp

predicate oppositeOperators(string op1, string op2) {
  op1 = "operator<" and op2 = "operator>="
  or
  op1 = "operator<=" and op2 = "operator>"
  or
  op1 = "operator==" and op2 = "operator!="
  or
  oppositeOperators(op2, op1)
}

/**
 * Holds if `op1` is implemented as the negation of `op2`.
 *
 * This match is very syntactic: we simply check that `op1` is defined as
 * `!op2(_, _)`.
 */
predicate implementedAsNegationOf(Operator op1, Operator op2) {
  exists(BlockStmt b, ReturnStmt r, NotExpr n, Expr o |
    b = op1.getBlock() and
    b.getNumStmt() = 1 and
    r = b.getStmt(0) and
    n = r.getExpr() and
    o = n.getOperand() and
    (
      o instanceof LTExpr and op2.hasName("operator<")
      or
      o instanceof LEExpr and op2.hasName("operator<=")
      or
      o instanceof GTExpr and op2.hasName("operator>")
      or
      o instanceof GEExpr and op2.hasName("operator>=")
      or
      o instanceof EQExpr and op2.hasName("operator==")
      or
      o instanceof NEExpr and op2.hasName("operator!=")
      or
      o.(FunctionCall).getTarget() = op2
    )
  )
}

predicate classIsCheckableFor(Class c, string op) {
  oppositeOperators(op, _) and
  // We check the template, not its instantiations
  not c instanceof ClassTemplateInstantiation and
  // Member functions of templates are not necessarily instantiated, so
  // if the function we want to check exists, then make sure that its
  // body also exists
  (
    c instanceof TemplateClass
    implies
    forall(Function f | f = c.getAMember() and f.hasName(op) | exists(f.getEntryPoint()))
  )
}

from Class c, string op, string opp, Operator rator
where
  c.fromSource() and
  oppositeOperators(op, opp) and
  classIsCheckableFor(c, op) and
  classIsCheckableFor(c, opp) and
  rator = c.getAMember() and
  rator.hasName(op) and
  forex(Operator aRator | aRator = c.getAMember() and aRator.hasName(op) |
    not exists(Operator oprator |
      oprator = c.getAMember() and
      oprator.hasName(opp) and
      (
        implementedAsNegationOf(aRator, oprator) or
        implementedAsNegationOf(oprator, aRator)
      )
    )
  )
select c,
  "When two operators are opposites, both should be defined and one should be defined in terms of the other. Operator "
    + op + " is declared on line " + rator.getLocation().getStartLine().toString() +
    ", but it is not defined in terms of its opposite operator " + opp + "."
