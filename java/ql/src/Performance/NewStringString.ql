/**
 * @name Inefficient String constructor
 * @description Using the 'String(String)' constructor is less memory efficient than using the
 *              constructor argument directly.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/inefficient-string-constructor
 * @tags efficiency
 *       maintainability
 */

import java

from ClassInstanceExpr e
where
  e.getConstructor().getDeclaringType() instanceof TypeString and
  e.getArgument(0).getType() instanceof TypeString
select e, "Inefficient new String(String) constructor."
