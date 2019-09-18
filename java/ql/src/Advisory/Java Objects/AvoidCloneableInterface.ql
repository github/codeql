/**
 * @name Use of Cloneable interface
 * @description Using the 'Cloneable' interface is bad practice. Copying an object using the
 *              'Cloneable interface' and 'Object.clone' is error-prone.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/use-of-cloneable-interface
 * @tags reliability
 */

import java

from RefType t
where
  t.fromSource() and
  t.getASupertype() instanceof TypeCloneable
select t, "This type implements or extends Cloneable, which should be avoided."
