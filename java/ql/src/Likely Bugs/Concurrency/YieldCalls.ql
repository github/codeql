/**
 * @name Call to Thread.yield()
 * @description Calling 'Thread.yield' may have no effect, and is not a reliable way to prevent a
 *              thread from taking up too much execution time.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/thread-yield-call
 * @tags reliability
 *       correctness
 *       concurrency
 */

import java

class YieldMethod extends Method {
  YieldMethod() {
    this.getName() = "yield" and
    this.getDeclaringType().hasQualifiedName("java.lang", "Thread")
  }
}

class YieldMethodCall extends MethodCall {
  YieldMethodCall() { this.getMethod() instanceof YieldMethod }
}

from YieldMethodCall yield
where yield.getCompilationUnit().fromSource()
select yield,
  "Do not use Thread.yield(). It is non-portable and will most likely not have the desired effect."
