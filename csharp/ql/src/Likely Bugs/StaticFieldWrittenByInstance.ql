/**
 * @name Static field written by instance method
 * @description Finds instance methods that write static fields.
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

from FieldWrite fw, Field f, Callable m
where
  fw.getTarget() = f and
  f.isStatic() and
  m = fw.getEnclosingCallable() and
  not m.(Member).isStatic() and
  f.getDeclaringType() = m.getDeclaringType() and
  m.fromSource()
select fw.(VariableAccess), "Write to static field from instance method or constructor."
