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

from MethodAccess ma, Method m
where
  m = ma.getMethod() and
  m instanceof CloneMethod and
  // But ignore direct calls to Object.clone
  not m.getDeclaringType() instanceof TypeObject
select ma, "Invoking a method that overrides clone() should be avoided."
