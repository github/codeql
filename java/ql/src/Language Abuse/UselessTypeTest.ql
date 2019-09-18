/**
 * @name Useless type test
 * @description Testing whether a derived type is an instance of its base type is unnecessary.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/useless-type-test
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-561
 */

import java

from InstanceOfExpr ioe, RefType t, RefType ct
where
  t = ioe.getExpr().getType() and
  ct = ioe.getTypeName().getType() and
  ct = t.getASupertype+()
select ioe,
  "There is no need to test whether an instance of $@ is also an instance of $@ - it always is.", t,
  t.getName(), ct, ct.getName()
