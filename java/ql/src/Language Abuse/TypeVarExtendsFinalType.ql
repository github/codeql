/**
 * @name Type bound extends a final class
 * @description If 'C' is a final class, a type bound such as '? extends C'
 *              is confusing because it implies that 'C' has subclasses, but
 *              a final class has no subclasses.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/type-bound-extends-final
 * @tags maintainability
 *       readability
 *       types
 */

import java

from TypeVariable v, RefType bound
where
  v.getATypeBound().getType() = bound and
  bound.isFinal()
select v,
  "Type '" + bound + "' is final, so <" + v.getName() + " extends " + bound + "> is confusing."
