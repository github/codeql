/**
 * @name Inefficient primitive constructor
 * @description Calling the constructor of a boxed type is inefficient.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/inefficient-boxed-constructor
 * @tags efficiency
 *       maintainability
 */

import java

from ClassInstanceExpr call, BoxedType type
where
  type = call.getType() and
  not call.getEnclosingCallable().getDeclaringType() = type
select call,
  "Inefficient constructor for " + type.getPrimitiveType().getName() + " value, use " +
    type.getName() + ".valueOf(...) instead."
