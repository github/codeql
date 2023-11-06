/**
 * @name Direct call to a run() method
 * @description Directly calling a 'Thread' object's 'run' method does not start a separate thread
 *              but executes the method within the current thread.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/call-to-thread-run
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-572
 */

import java

class RunMethod extends Method {
  RunMethod() {
    this.hasName("run") and
    this.hasNoParameters() and
    this.getDeclaringType().getAnAncestor().hasQualifiedName("java.lang", "Thread")
  }
}

from MethodCall m, RunMethod run
where
  m.getMethod() = run and
  not m.getEnclosingCallable() instanceof RunMethod
select m, "Calling 'Thread.run()' rather than 'Thread.start()' will not spawn a new thread."
