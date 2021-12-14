/**
 * @id py/examples/catch-exception
 * @name Handle exception of given class
 * @description Finds places where we handle MyExceptionClass exceptions
 * @tags catch
 *       try
 *       exception
 */

import python

from ExceptStmt ex, ClassValue cls
where
  cls.getName() = "MyExceptionClass" and
  ex.getType().pointsTo(cls)
select ex
