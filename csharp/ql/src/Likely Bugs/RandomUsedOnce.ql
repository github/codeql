/**
 * @name Random used only once
 * @description Creating an instance of 'Random' for each pseudo-random number required does not
 *              guarantee an evenly distributed sequence of random numbers.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/random-used-once
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-335
 */

import csharp

predicate generateRandomNumberMethod(string s) { s = "Next" or s = "NextBytes" or s = "NextDouble" }

from ObjectCreation c, MethodCall m
where
  c.getType().getSourceDeclaration().(ValueOrRefType).hasQualifiedName("System", "Random") and
  m.getQualifier() = c and
  generateRandomNumberMethod(m.getTarget().getName())
select m, "Random object created and used only once."
