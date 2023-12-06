/**
 * @name Dangerous runFinalizersOnExit
 * @description Calling 'System.runFinalizersOnExit' or 'Runtime.runFinalizersOnExit'
 *              may cause finalizers to be run on live objects, leading to erratic behavior or
 *              deadlock.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/run-finalizers-on-exit
 * @tags reliability
 *       maintainability
 */

import java

from MethodCall ma, Method runfinalizers, Class c
where
  ma.getMethod() = runfinalizers and
  runfinalizers.hasName("runFinalizersOnExit") and
  runfinalizers.getDeclaringType() = c and
  (
    c.hasName("Runtime") or
    c.hasName("System")
  ) and
  c.getPackage().hasName("java.lang")
select ma, "Call to runFinalizersOnExit."
