/**
 * @name Bad suite method
 * @description A 'suite' method in a JUnit 3.8 test that does not match the expected signature is not
 *              detected by JUnit.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/wrong-junit-suite-signature
 * @tags testability
 *       maintainability
 *       frameworks/junit
 */

import java

from TypeJUnitTestCase junitTestCase, TypeJUnitTest junitTest, Method m
where
  m.hasName("suite") and
  m.hasNoParameters() and
  m.getDeclaringType().hasSupertype+(junitTestCase) and
  (
    not m.isPublic() or
    not m.isStatic() or
    not m.getReturnType().(RefType).getAnAncestor() = junitTest
  )
select m, "Bad declaration for suite method."
