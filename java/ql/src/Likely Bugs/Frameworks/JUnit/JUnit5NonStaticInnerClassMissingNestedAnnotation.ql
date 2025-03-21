/**
 * @id java/junit5-non-static-inner-class-missing-nested-annotation
 * @name Non-static inner class defined in a JUnit 5 test is missing a `@Nested` annotation
 * @description A non-static inner class defined in a JUnit 5 test missing a `@Nested` annotation
 *              will be excluded from execution and it may indicate a misunderstanding from the
 *              programmer.
 * @kind problem
 * @precision very-high
 * @problem.severity warning
 * @tags quality
 *       maintainability
 *       correctness
 */

import java

from JUnit5TestClass testClass
where
  // `InnerClass` is a non-static, nested class.
  testClass instanceof InnerClass and
  not testClass.hasAnnotation("org.junit.jupiter.api", "Nested")
select testClass, "This JUnit5 inner test class lacks a '@Nested' annotation."
