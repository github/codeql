/**
 * @name Forcible JVM termination
 * @description Calling 'System.exit', 'Runtime.halt', or 'Runtime.exit' may make code harder to
 *              reuse and prevent important cleanup steps from running.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/jvm-exit
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-382
 */

import java

from Method m, MethodAccess sysexitCall, Method sysexit, Class system
where
  sysexitCall = m.getACallSite(sysexit) and
  (sysexit.hasName("exit") or sysexit.hasName("halt")) and
  sysexit.getDeclaringType() = system and
  (
    system.hasQualifiedName("java.lang", "System") or
    system.hasQualifiedName("java.lang", "Runtime")
  ) and
  m.fromSource() and
  not m instanceof MainMethod
select sysexitCall,
  "Avoid calls to " + sysexit.getDeclaringType().getName() + "." + sysexit.getName() +
    "() as this makes code harder to reuse."
