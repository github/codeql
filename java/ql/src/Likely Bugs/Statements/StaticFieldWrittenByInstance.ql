/**
 * @name Static field written by instance method
 * @description Writing to a static field from an instance method is prone to race conditions
 *              unless you use synchronization. In addition, it makes it difficult to keep the
 *              static state consistent and affects code readability.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/static-field-written-by-instance
 * @tags reliability
 *       maintainability
 */

import java

from FieldWrite fw, Field f, Callable c, string kind
where
  fw.getField() = f and
  f.isStatic() and
  c = fw.getSite() and
  not c.isStatic() and
  f.getDeclaringType() = c.getDeclaringType() and
  c.fromSource() and
  if c instanceof Constructor then kind = "constructor for" else kind = "instance method"
select fw, "Write to static field " + f.getName() + " in " + kind + " " + c.getName() + "."
