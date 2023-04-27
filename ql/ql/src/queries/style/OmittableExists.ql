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
import codeql_ql.style.ConjunctionParent

/**
 * Holds if `existsArgument` is the declaration of a variable in an `exists` formula,
 * and `use` is both its only use and an argument of a predicate that doesn't restrict
 * the corresponding parameter type.
 */
predicate omittableExists(VarDecl existsArgument, VarAccess use) {
  existsArgument = any(Exists e).getAnArgument() and
  use = unique( | | existsArgument.getAnAccess()) and
  exists(Call c, int argPos, Type paramType |
    c.getArgument(argPos) = use and paramType = c.getTarget().getParameterType(argPos)
  |
    existsArgument.getType() = paramType.getASuperType*() and
    not paramType instanceof DatabaseType
  )
}

/** Holds if `p` is an exists variable (either declaration or use) that can be omitted. */
predicate omittableExistsNode(AstNode p) { omittableExists(p, _) or omittableExists(_, p) }

from VarDecl existsArgument, VarAccess use
where
  omittableExists(existsArgument, use) and
  ConjunctionParent<omittableExistsNode/1>::getConjunctionParent(existsArgument) =
    ConjunctionParent<omittableExistsNode/1>::getConjunctionParent(use)
select existsArgument, "This exists variable can be omitted by using a don't-care expression $@.",
  use, "in this argument"
