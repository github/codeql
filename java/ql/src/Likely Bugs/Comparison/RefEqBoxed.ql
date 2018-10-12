/**
 * @name Reference equality test of boxed types
 * @description Comparing two boxed primitive values using the == or != operator
 *              compares object identity, which may not be intended.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/reference-equality-of-boxed-types
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-595
 */

import java

from EqualityTest c
where
  c.getLeftOperand().getType() instanceof BoxedType and
  c.getRightOperand().getType() instanceof BoxedType and
  not c.getAnOperand().getType().(RefType).hasQualifiedName("java.lang", "Boolean")
select c, "Suspicious reference comparison of boxed numerical values."
