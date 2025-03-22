/**
 * @id java/junit5-missing-nested-annotation
 * @name Missing `@Nested` annotation on JUnit 5 inner test class
 * @description A JUnit 5 inner test class that is missing a `@Nested` annotation will be
 *              excluded from execution and it may indicate a misunderstanding from the
 *              programmer.
 * @kind problem
 * @precision very-high
 * @problem.severity warning
 * @tags quality
 *       maintainability
 *       correctness
 *       previous-id:java/junit5-non-static-inner-class-missing-nested-annotation
 */

import java

from JUnit5TestClass testClass
where
  // `InnerClass` is a non-static, nested class.
  testClass instanceof InnerClass and
  not testClass.hasAnnotation("org.junit.jupiter.api", "Nested") and
  // An abstract class should not have a `@Nested` annotation
  not testClass.isAbstract()
select testClass, "This JUnit 5 inner test class lacks a '@Nested' annotation."
