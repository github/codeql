/**
 * @name Use of clone() method
 * @description Calling a method that overrides 'Object.clone' is bad practice. Copying an object
 *              using the 'Cloneable interface' and 'Object.clone' is error-prone.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/use-of-clone-method
 * @tags reliability
 */

import java

class ObjectCloneMethod extends Method {
  ObjectCloneMethod() {
    this.getDeclaringType() instanceof TypeObject and
    this.getName() = "clone" and
    this.hasNoParameters()
  }
}

from MethodAccess ma, ObjectCloneMethod clone
where ma.getMethod().overrides(clone)
select ma, "Invoking a method that overrides clone() should be avoided."
