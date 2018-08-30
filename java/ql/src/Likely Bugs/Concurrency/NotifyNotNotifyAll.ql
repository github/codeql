/**
 * @name notify instead of notifyAll
 * @description Calling 'notify' instead of 'notifyAll' may fail to wake up the correct thread and
 *              cannot wake up multiple threads.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/notify-instead-of-notify-all
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-662
 */

import java

class InvokeInterfaceOrVirtualMethodAccess extends MethodAccess {
  InvokeInterfaceOrVirtualMethodAccess() {
    this.getMethod().getDeclaringType() instanceof Interface or
    not this.hasQualifier() or
    not this.getQualifier() instanceof SuperAccess
  }
}

from InvokeInterfaceOrVirtualMethodAccess ma, Method m
where
  ma.getMethod() = m and
  m.hasName("notify") and
  m.hasNoParameters()
select ma, "Using notify rather than notifyAll."
