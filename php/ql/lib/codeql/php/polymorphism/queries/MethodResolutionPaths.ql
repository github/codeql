/**
 * @name Method Resolution Path Complexity
 * @description Identifies method calls with complex resolution paths
 * @kind problem
 * @problem.severity note
 * @tags polymorphism
 *       analysis
 *       complexity
 */

import php
import codeql.php.polymorphism.Polymorphism

/**
 * Find polymorphic method calls with many possible implementations
 */
from MethodCall call, int implementations
where
  implementations = count(Class c | exists(c.getMethod(call.getMethodName()))) and
  implementations > 3  // More than 3 possible implementations
select call,
  "Method " + call.getMethodName() + " has " + implementations +
    " possible implementations - high polymorphic complexity"
