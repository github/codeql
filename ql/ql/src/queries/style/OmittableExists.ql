/**
 * @name Omittable 'exists' argument
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
  strictcount(existsArgument.getAnAccess()) = 1 and
  use = existsArgument.getAnAccess() and
  exists(Call c, int argPos | c.getArgument(argPos) = use |
    not existsArgument.getType().getASuperType+() = c.getTarget().getParameterType(argPos)
  )
select existsArgument, "This exists argument can be omitted by using a don't-care expression $@.",
  use, "in this argument"
