/**
 * @name Incorrect absolute value of random number
 * @description Calling 'Math.abs' to find the absolute value of a randomly generated integer is not
 *              guaranteed to return a non-negative integer.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/abs-of-random
 * @tags reliability
 *       maintainability
 */

import java
import semmle.code.java.security.RandomQuery

from MethodCall ma, Method abs, Method nextIntOrLong, RandomDataSource nma
where
  ma.getMethod() = abs and
  abs.hasName("abs") and
  abs.getDeclaringType().hasQualifiedName("java.lang", "Math") and
  ma.getAnArgument() = nma and
  nma.getMethod() = nextIntOrLong and
  nextIntOrLong.hasName(["nextInt", "nextLong"]) and
  not nma.resultMayBeBounded()
select ma, "Incorrect computation of abs of signed integral random value."
