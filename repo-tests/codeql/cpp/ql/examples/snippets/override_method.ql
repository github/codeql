/**
 * @id cpp/examples/override-method
 * @name Override of method
 * @description Finds methods that override `std::exception::what()`
 * @tags function
 *       method
 *       override
 */

import cpp

from MemberFunction override, MemberFunction base
where
  base.getName() = "what" and
  base.getDeclaringType().getName() = "exception" and
  base.getDeclaringType().getNamespace().getName() = "std" and
  override.overrides+(base)
select override
