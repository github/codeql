/**
 * @name Overriding definition of clone()
 * @description Overriding 'Object.clone' is bad practice. Copying an object using the 'Cloneable
 *              interface' and 'Object.clone' is error-prone.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/override-of-clone-method
 * @tags reliability
 */

import java

class ObjectCloneMethod extends CloneMethod {
  ObjectCloneMethod() { this.getDeclaringType() instanceof TypeObject }
}

from Method m, ObjectCloneMethod clone
where
  m.fromSource() and
  // Only consider direct overrides of Object.clone
  m.overrides(clone)
select m, "Overriding the Object.clone() method should be avoided."
