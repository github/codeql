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

class AggregateOrForQuantifier extends AstNode {
  AggregateOrForQuantifier() {
    this instanceof FullAggregate or this instanceof Forex or this instanceof Forall
  }
}

from VarDecl existsArgument, VarAccess use
where
  existsArgument = any(Exists e).getAnArgument() and
  use = unique( | | existsArgument.getAnAccess()) and
  exists(Call c, int argPos, Type paramType |
    c.getArgument(argPos) = use and paramType = c.getTarget().getParameterType(argPos)
  |
    existsArgument.getType() = paramType.getASuperType*() and
    not paramType instanceof DatabaseType
  ) and
  not use.getParent*() instanceof AggregateOrForQuantifier
select existsArgument, "This exists variable can be omitted by using a don't-care expression $@.",
  use, "in this argument"
