/**
 * @name Opposite operator definition
 * @description When two operators are opposites, both should be defined and one should be defined in terms of the other.
 * @kind problem
 * @id cpp/jsf/av-rule-85
 * @problem.severity warning
 * @tags reliability
 */
import cpp

predicate oppositeOperators(string op1, string op2) {
     op1="operator<"  and op2="operator>="
  or op1="operator<=" and op2="operator>"
  or op1="operator==" and op2="operator!="
  or oppositeOperators(op2, op1)
}

// whether op1 is implemented as the negation of op2
/* this match is very syntactic: we simply check that op1 is defined as
   !op2(_, _) */
predicate implementedAsNegationOf(Operator op1, Operator op2) {
  exists(Block b, ReturnStmt r, NotExpr n, FunctionCall c |
    b = op1.getBlock() and
    b.getNumStmt() = 1 and
    r = b.getStmt(0) and
    n = r.getExpr() and
    c = n.getOperand() and
    c.getTarget() = op2)
}

from Class c, string op, string opp, Operator rator
where c.fromSource() and
      oppositeOperators(op, opp) and
      rator = c.getAMember() and
      rator.hasName(op) and
      not exists(Operator oprator | oprator = c.getAMember() and
                                    oprator.hasName(opp) and
                                    (   implementedAsNegationOf(rator, oprator)
                                     or implementedAsNegationOf(oprator, rator)))
select c, "When two operators are opposites, both should be defined and one should be defined in terms of the other. Operator " + op +
          " is declared on line " + rator.getLocation().getStartLine().toString() + ", but it is not defined in terms of its opposite operator " + opp + "."
