/**
 * @id java/junit5-non-static-inner-class-missing-nested-annotation
 * @name J-T-004: Non-static inner class defined in a JUnit5 test is missing a `@Nested` annotation
 * @description A non-static inner class defined in a JUnit5 test missing a `@Nested` annotation
 *              will be excluded from execution and it may indicate a misunderstanding from the
 *              programmer.
 * @kind problem
 * @precision very-high
 * @problem.severity warning
 * @tags maintainability
 *       correctness
 */

import java

class JUnit5TestClass extends Class {
  JUnit5TestClass() {
    this.getAMethod().getAnAnnotation().getType().hasQualifiedName("org.junit.jupiter.api", "Test")
  }
}

from JUnit5TestClass testClass // `TestClass` by definition should have at least one @Test method.
where
  not testClass.isStatic() and
  testClass instanceof InnerClass and // `InnerClass` is by definition a non-static nested class.
  not exists(Annotation annotation |
    annotation.getType().hasQualifiedName("org.junit.jupiter.api", "Nested") and
    annotation.getAnnotatedElement() = testClass
  )
select testClass, "This JUnit5 inner test class lacks a @Nested annotation."
