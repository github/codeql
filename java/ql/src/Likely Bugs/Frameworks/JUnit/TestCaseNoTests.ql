/**
 * @name Test case has no tests
 * @description A test case class whose test methods are not recognized by JUnit 3.8 as valid
 *              declarations is not used.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/test-case-without-tests
 * @tags testability
 *       maintainability
 *       frameworks/junit
 */

import java

// `suite()` methods in `TestCase`s also count as test methods.
class SuiteMethod extends Method {
  SuiteMethod() {
    this.getDeclaringType() instanceof JUnit38TestClass and
    this.isPublic() and
    this.isStatic() and
    this.hasNoParameters()
  }
}

from JUnit38TestClass j
where
  j.fromSource() and
  not j.getAnAnnotation().getType().hasQualifiedName("org.junit", "Ignore") and
  not j.isAbstract() and
  not exists(TestMethod t | t.getDeclaringType() = j) and
  not exists(SuiteMethod s | s.getDeclaringType() = j)
select j, "TestCase has no tests."
