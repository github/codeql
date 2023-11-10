/**
 * @name Call to obsolete method
 * @description Calls to methods marked as [Obsolete] should be replaced because the method is
 *              no longer maintained and may be removed in the future.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/call-to-obsolete-method
 * @tags changeability
 *       maintainability
 *       external/cwe/cwe-477
 */

import csharp

class ObsoleteAttribute extends Attribute {
  ObsoleteAttribute() { this.getType().hasFullyQualifiedName("System", "ObsoleteAttribute") }
}

from MethodCall c, Method m
where
  m = c.getTarget() and
  m.getAnAttribute() instanceof ObsoleteAttribute and
  not c.getEnclosingCallable().(Attributable).getAnAttribute() instanceof ObsoleteAttribute
select c, "Call to obsolete method $@.", m, m.getName()
