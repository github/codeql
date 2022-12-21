/**
 * @name Omittable 'exists' variable
 * @description Writing 'exists(x | pred(x))' is bad practice and can be omitted.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id ql/omittable-exists
 * @tags maintainability
 */

import ql

from VarDecl existsArgument, VarAccess use
where
  existsArgument = any(Exists e).getAnArgument() and
  use = unique( | | existsArgument.getAnAccess()) and
  exists(Call c, int argPos | c.getArgument(argPos) = use |
    existsArgument.getType() = c.getTarget().getParameterType(argPos).getASuperType*()
  )
select existsArgument, "This exists variable can be omitted by using a don't-care expression $@.",
  use, "in this argument"
