/**
 * @name Unmanaged code
 * @description Finds "extern" methods, implemented by unmanaged code.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/unmanaged-code
 * @tags reliability
 *       maintainability
 */

import csharp

from Class c, Method m
where
  m.isExtern() and
  m.getDeclaringType() = c
select m, "Minimise the use of unmanaged code."
