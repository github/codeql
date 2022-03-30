/**
 * @name Unsafe use of getResource
 * @description Calling 'this.getClass().getResource()' may yield unexpected results if called from a
 *              subclass in another package.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/unsafe-get-resource
 * @tags reliability
 *       maintainability
 */

import java

from Class c, MethodAccess getResource, MethodAccess getClass
where
  getResource.getNumArgument() = 1 and
  (
    getResource.getMethod().hasName("getResource") or
    getResource.getMethod().hasName("getResourceAsStream")
  ) and
  getResource.getQualifier() = getClass and
  getClass.isOwnMethodAccess() and
  getClass.getNumArgument() = 0 and
  getClass.getMethod().hasName("getClass") and
  getResource.getEnclosingCallable().getDeclaringType() = c and
  c.isPublic()
select getResource, "The idiom getClass().getResource() is unsafe for classes that may be extended."
