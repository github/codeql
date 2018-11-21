/**
 * @name Redefined default parameter
 * @description An inherited default parameter shall never be redefined. Default values are bound statically which is confusing when combined with dynamically bound function calls.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/redefined-default-parameter
 * @tags maintainability
 *       readability
 *       external/jsf
 */
import cpp

from Parameter p, Parameter superP, MemberFunction subF, MemberFunction superF, int i, string subValue, string superValue
where p.hasInitializer()
  and subF.getParameter(i) = p
   and superP.hasInitializer()
   and subF.overrides(superF)
   and superF.getParameter(i) = superP
   and subValue = p.getInitializer().getExpr().getValue()
   and superValue = superP.getInitializer().getExpr().getValue()
   and subValue != superValue
select p.getInitializer().getExpr(),
   "Parameter " + p.getName() +
   " redefines its default value to " + subValue +
   " from the inherited default value " + superValue +
   " (in " + superF.getDeclaringType().getName() +
   ").\nThe default value will be resolved statically, not by dispatch, so this can cause confusion."
