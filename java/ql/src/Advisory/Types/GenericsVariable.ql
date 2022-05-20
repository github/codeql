/**
 * @name Non-parameterized variable
 * @description Declaring a field, parameter, or local variable as a parameterized type increases
 *              type safety and code readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/raw-variable
 * @tags maintainability
 */

import java

from Variable v
where
  v.fromSource() and
  v.getType() instanceof RawType
select v, "This declaration uses a non-parameterized type."
