/**
 * @name Overriding definition of finalize()
 * @description Overriding 'Object.finalize' is not a reliable way to terminate use of resources.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/override-of-finalize-method
 * @tags reliability
 */

import java

class ObjectFinalizeMethod extends Method {
  ObjectFinalizeMethod() {
    this.getDeclaringType() instanceof TypeObject and
    this.getName() = "finalize" and
    this.hasNoParameters()
  }
}

from Method m, ObjectFinalizeMethod finalize
where
  m.fromSource() and
  m.overrides(finalize)
select m, "Overriding the Object.finalize() method should be avoided."
