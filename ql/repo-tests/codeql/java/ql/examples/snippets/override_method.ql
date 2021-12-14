/**
 * @id java/examples/override-method
 * @name Override of method
 * @description Finds methods that override com.example.Class.baseMethod
 * @tags method
 *       override
 */

import java

from Method override, Method base
where
  base.hasName("baseMethod") and
  base.getDeclaringType().hasQualifiedName("com.example", "Class") and
  override.overrides+(base)
select override
