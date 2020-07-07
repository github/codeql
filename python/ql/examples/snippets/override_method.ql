/**
 * @id py/examples/override-method
 * @name Override of method
 * @description Finds methods that overide MyClass.methodName
 * @tags method
 *       override
 */

import python

from FunctionObject override, FunctionObject base
where
  base.getQualifiedName() = "MyClass.methodName" and
  override.overrides(base)
select override
