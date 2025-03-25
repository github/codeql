/**
 * @id java/junit5-missing-nested-annotation
 * @previous-id java/junit5-non-static-inner-class-missing-nested-annotation
 * @name Missing `@Nested` annotation on JUnit 5 inner test class
 * @description A JUnit 5 inner test class that is missing a `@Nested` annotation will be
 *              excluded from execution and may indicate a mistake from the
 *              programmer.
 * @kind problem
 * @precision very-high
 * @problem.severity warning
 * @tags quality
 *       maintainability
 *       correctness
 *       testability
 *       frameworks/junit
 */

import java

from JUnit5InnerTestClass testClass
where not testClass.hasAnnotation("org.junit.jupiter.api", "Nested")
select testClass, "This JUnit 5 inner test class lacks a '@Nested' annotation."
