/**
 * @name Non-parameterized method return type
 * @description Using a parameterized instance of a generic type for a method return type increases
 *              type safety and code readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/raw-return-type
 * @tags maintainability
 */

import java

from Method m
where
  m.fromSource() and
  m.getReturnType() instanceof RawType
select m, "This method has a non-parameterized return type."
