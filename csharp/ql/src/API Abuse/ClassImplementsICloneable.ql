/**
 * @name Class implements ICloneable
 * @description Implementing 'ICloneable' is discouraged due to its imprecise semantics
 *              and its viral effect on your code base.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cs/class-implements-icloneable
 * @tags reliability
 *       maintainability
 */

import csharp

from ValueOrRefType c
where
  c.fromSource() and
  c.getABaseInterface+().hasFullyQualifiedName("System", "ICloneable") and
  not c.isSealed() and
  exists(Method m | m.getDeclaringType() = c and m.hasName("Clone"))
select c, "Class '" + c.getName() + "' implements 'ICloneable'."
