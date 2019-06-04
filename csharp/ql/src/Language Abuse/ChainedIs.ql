/**
 * @name Chain of 'is' tests
 * @description Long sequences of type tests on a variable are generally an indication of questionable design. They are hard to maintain
 *              and can cause performance problems.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/chained-type-tests
 * @tags changeability
 *       maintainability
 *       language-features
 */

import csharp

TypePatternExpr getTypeCondition(IfStmt is) { result = is.getCondition().(IsExpr).getPattern() }

int isCountForIfChain(IfStmt is) {
  exists(int rest |
    (if is.getElse() instanceof IfStmt then rest = isCountForIfChain(is.getElse()) else rest = 0) and
    (
      if getTypeCondition(is).getCheckedType().getSourceDeclaration().fromSource()
      then result = 1 + rest
      else result = rest
    )
  )
}

from IfStmt is, int n
where
  n = isCountForIfChain(is) and
  n > 5 and
  not exists(IfStmt other | is = other.getElse())
select is,
  "This if block performs a chain of " + n +
    " type tests - consider alternatives, e.g. polymorphism or the visitor pattern."
