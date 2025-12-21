/**
 * @name Polymorphism Metrics and Analysis
 * @description Provides metrics on polymorphic method usage and complexity
 * @kind metric
 * @tags polymorphism
 *       analysis
 *       metrics
 */

import php
import codeql.php.polymorphism.Polymorphism

/**
 * Count polymorphic method calls (methods with multiple implementations)
 */
select count(MethodCall call |
  count(Class c | exists(c.getMethod(call.getMethodName()))) > 1
) as polymorphic_calls,
count(MethodCall call) as total_calls
