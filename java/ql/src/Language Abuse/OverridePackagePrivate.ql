/**
 * @name Confusing non-overriding of package-private method
 * @description A method that appears to override another method but does not, because the
 *              declaring classes are in different packages, is potentially confusing.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/non-overriding-package-private
 * @tags maintainability
 *       readability
 */

import java

from Method superMethod, Method method
where
  overridesIgnoringAccess(method, _, superMethod, _) and
  not method.overrides(superMethod) and
  not superMethod.isPublic() and
  not superMethod.isProtected() and
  not superMethod.isPrivate()
select method, "This method does not override $@ because it is private to another package.",
  superMethod, superMethod.getDeclaringType().getName() + "." + superMethod.getName()
