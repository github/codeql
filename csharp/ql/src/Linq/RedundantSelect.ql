/**
 * @name Redundant Select
 * @description Writing 'seq.Select(e => e)' or 'from e in seq select e' is redundant.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/linq/useless-select
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-561
 */

import csharp
import Linq.Helpers

predicate isIdentityFunction(AnonymousFunctionExpr afe) {
  afe.getNumberOfParameters() = 1 and
  afe.getExpressionBody() = afe.getParameter(0).getAnAccess()
}

from SelectCall sc
where isIdentityFunction(sc.getFunctionExpr())
select sc, "This LINQ selection is redundant and can be removed."
