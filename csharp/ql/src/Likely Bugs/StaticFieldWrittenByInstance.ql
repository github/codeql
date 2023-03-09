/**
 * @name Static field written by instance method
 * @description Finds instance methods and properties that write to static fields.
 *              This is tricky to get right if multiple instances are being manipulated,
 *              and generally bad practice.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/static-field-written-by-instance
 * @tags reliability
 *       maintainability
 *       modularity
 */

import csharp

from FieldWrite fw, Field f, Callable c
where
  fw.getTarget() = f and
  f.isStatic() and
  c = fw.getEnclosingCallable() and
  not [c.(Member), c.(Accessor).getDeclaration()].isStatic() and
  f.getDeclaringType() = c.getDeclaringType() and
  c.fromSource()
select fw.(VariableAccess), "Write to static field from instance method, property, or constructor."
