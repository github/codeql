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

from MethodAccess ma, Method random
where
  random.getDeclaringType().hasQualifiedName("java.util", "Random") and
  ma.getMethod() = random and
  ma.getQualifier() instanceof ClassInstanceExpr
select ma, "Random object created and used only once."
