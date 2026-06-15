/**
 * @name Escaping
 * @description In a thread-safe class, care should be taken to avoid exposing mutable state.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/escaping
 * @tags quality
 *       reliability
 *       concurrency
 */

import java
import semmle.code.java.ConflictingAccess

from Field f, ClassAnnotatedAsThreadSafe c
where
  f = c.getAField() and
  not f.isFinal() and // final fields do not change
  not f.isPrivate() and
  // We believe that protected fields are also dangerous
  // Volatile fields cannot cause data races, but it is dubious to allow changes.
  // For now, we ignore volatile fields, but there are likely bugs to be caught here.
  not f.isVolatile()
select f, "The class $@ is marked as thread-safe, but this field is potentially escaping.", c,
  c.getName()
