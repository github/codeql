/**
 * @name Hot Polymorphic Methods
 * @description Identifies frequently called polymorphic methods that could benefit from optimization
 * @kind table
 * @tags polymorphism
 *       performance
 *       optimization
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.PolymorphismOptimization

/**
 * Find methods that are called frequently and are polymorphic
 */
from MethodCall call, int callCount
where
  // Count how many times this method is called
  callCount = count(MethodCall same |
    same.getMethodName() = call.getMethodName()
  ) and
  // Method is polymorphic (multiple implementations)
  count(Class c | exists(c.getMethod(call.getMethodName()))) > 1 and
  callCount > 5  // At least 5 calls
select call.getMethodName() as method_name,
  callCount as call_count,
  count(Class c | exists(c.getMethod(call.getMethodName()))) as implementation_count
order by call_count desc
