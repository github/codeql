/**
 * @id cs/examples/override-method
 * @name Override of method
 * @description Finds methods that directly override 'Object.ToString'.
 * @tags method
 *       override
 */

import csharp

from Method override, Method base
where
  base.hasName("ToString") and
  base.getDeclaringType().hasFullyQualifiedName("System", "Object") and
  base.getAnOverrider() = override
select override
