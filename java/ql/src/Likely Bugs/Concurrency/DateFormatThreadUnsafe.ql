/**
 * @name Thread-unsafe use of DateFormat
 * @description Static fields of type 'DateFormat' (or its descendants) should be avoided
 *              because the class 'DateFormat' is not thread-safe.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/thread-unsafe-dateformat
 * @tags reliability
 *       correctness
 *       concurrency
 */

import java

from Field f, Class dateFormat
where
  f.isStatic() and
  (f.isPublic() or f.isProtected()) and
  dateFormat.hasQualifiedName("java.text", "DateFormat") and
  f.getType().(RefType).hasSupertype*(dateFormat) and
  exists(MethodCall m | m.getQualifier().(VarAccess).getVariable() = f)
select f,
  "Found static field of type " + f.getType().getName() + " in " + f.getDeclaringType().getName() +
    "."
