/**
 * @name Thread safety
 * @description Calling Swing methods from a thread other than the event-dispatching thread may
 *              result in multi-threading errors.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/swing-thread-safety
 * @tags reliability
 *       maintainability
 *       frameworks/swing
 */

import java

from MethodCall ma, Method m, MainMethod main
where
  ma.getQualifier().getType().getCompilationUnit().getPackage().getName().matches("javax.swing%") and
  (
    m.hasName("show") and m.hasNoParameters()
    or
    m.hasName("pack") and m.hasNoParameters()
    or
    m.hasName("setVisible") and m.getNumberOfParameters() = 1
  ) and
  ma.getMethod() = m and
  ma.getEnclosingCallable() = main
select ma,
  "Call to swing method in " + main.getDeclaringType().getName() +
    " needs to be performed in Swing event thread."
