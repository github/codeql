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

predicate classIsCheckableFor(Class c, string op) {
  oppositeOperators(op, _) and
  if exists(Class templ | c.isConstructedFrom(templ))
  then // If we are an instantiation, then we can't check `op` if the
       // template has it but we don't (because that member wasn't
       // instantiated)
       exists(Class templ | c.isConstructedFrom(templ) and
                            (templ.getAMember().hasName(op) implies
                             exists(Function f | f = c.getAMember() and
                                                 f.hasName(op) and
                                                 f.isDefined())))
  else any()
}

from Class c, string op, string opp, Operator rator
where c.fromSource() and
      not c instanceof TemplateClass and
      oppositeOperators(op, opp) and
      classIsCheckableFor(c, op) and
      classIsCheckableFor(c, opp) and
      rator = c.getAMember() and
      rator.hasName(op) and
      forex(Operator aRator |
            aRator = c.getAMember() and aRator.hasName(op) |
            not exists(Operator oprator |
                       oprator = c.getAMember() and
                       oprator.hasName(opp) and
                       (   implementedAsNegationOf(aRator, oprator)
                        or implementedAsNegationOf(oprator, aRator))))
select c, "When two operators are opposites, both should be defined and one should be defined in terms of the other. Operator " + op +
          " is declared on line " + rator.getLocation().getStartLine().toString() + ", but it is not defined in terms of its opposite operator " + opp + "."
