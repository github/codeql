/**
 * @name Too many 'ref' parameters
 * @description Methods with large numbers of 'ref' parameters can be hard to understand - consider using
 *              a wrapper object instead.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cs/too-many-ref-parameters
 * @tags testability
 *       readability
 */

import csharp

from Method m, int n
where
  m.isSourceDeclaration() and
  n = count(Parameter p | p = m.getAParameter() and p.isRef()) and
  n > 2
select m,
  "Method '" + m.getName() + "' has " + n + " 'ref' parameters and might be hard to understand."
