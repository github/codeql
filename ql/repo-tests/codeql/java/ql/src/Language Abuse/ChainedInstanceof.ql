/**
 * @name Chain of 'instanceof' tests
 * @description Long sequences of type tests on a variable are difficult to maintain.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/chained-type-tests
 * @tags maintainability
 *       language-features
 */

import java

int instanceofCountForIfChain(IfStmt is) {
  exists(int rest |
    (
      if is.getElse() instanceof IfStmt
      then rest = instanceofCountForIfChain(is.getElse())
      else rest = 0
    ) and
    (if is.getCondition() instanceof InstanceOfExpr then result = 1 + rest else result = rest)
  )
}

from IfStmt is, int n
where
  n = instanceofCountForIfChain(is) and
  n > 5 and
  not exists(IfStmt other | is = other.getElse())
select is,
  "This if block performs a chain of " + n +
    " type tests - consider alternatives, e.g. polymorphism or the visitor pattern."
