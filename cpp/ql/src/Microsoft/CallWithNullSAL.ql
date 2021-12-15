/**
 * @name SAL requires non-null argument
 * @description When null is passed to a function that is SAL-annotated to
 *              forbid this, undefined behavior may result.
 * @kind problem
 * @id cpp/call-with-null-sal
 * @problem.severity warning
 * @tags reliability
 */

import cpp
import SAL

from Parameter p, Call c, Expr arg
where
  any(SALNotNull a).getDeclaration() = p and
  c.getTarget() = p.getFunction() and
  arg = c.getArgument(p.getIndex()) and
  nullValue(arg)
select arg,
  "Argument (" + arg.toString() + ") for parameter $@ in call to " + c.getTarget().getName() +
    " may be null, but a SAL annotation forbids this.", p, p.getName()
