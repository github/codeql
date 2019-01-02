/**
 * @name Useless type test
 * @description There is no need to test whether or not an instance of a derived type is also an instance of a base type - it always is.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/useless-type-test
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-561
 */

import csharp

from IsTypeExpr ise, ValueOrRefType t, ValueOrRefType ct
where
  t = ise.getExpr().getType() and
  ct = ise.getCheckedType() and
  ct = t.getABaseType+()
select ise,
  "There is no need to test whether an instance of $@ is also an instance of $@ - it always is.", t,
  t.getName(), ct, ct.getName()
