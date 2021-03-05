/**
 * @name Random used only once
 * @description Creating an instance of 'Random' for each pseudo-random number required does not
 *              guarantee an evenly distributed sequence of random numbers.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/random-used-once
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-335
 */

import java
import semmle.code.java.security.Random

from MethodAccess ma, Method random
where
  random.getDeclaringType() instanceof RandomNumberGenerator and
  ma.getMethod() = random and
  ma.getQualifier() instanceof ClassInstanceExpr
select ma, "Random object created and used only once."
