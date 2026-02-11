/**
 * @id java/java-util-concurrent-scheduledthreadpoolexecutor
 * @name Zero threads set for `java.util.concurrent.ScheduledThreadPoolExecutor`
 * @description Setting `java.util.concurrent.ScheduledThreadPoolExecutor` to have 0 threads serves
 *              no purpose and may indicate programmer error.
 * @kind problem
 * @precision very-high
 * @problem.severity recommendation
 * @previous-id java/javautilconcurrentscheduledthreadpoolexecutor
 * @tags quality
 *       reliability
 *       correctness
 *       concurrency
 */

import java
import semmle.code.java.dataflow.DataFlow

/**
 * A `Call` that has the ability to set or modify the `corePoolSize` of the `java.util.concurrent.ScheduledThreadPoolExecutor` type.
 */
class Sink extends Call {
  Sink() {
    this.getCallee()
        .hasQualifiedName("java.util.concurrent", "ThreadPoolExecutor", "setCorePoolSize") or
    this.getCallee()
        .hasQualifiedName("java.util.concurrent", "ScheduledThreadPoolExecutor",
          "ScheduledThreadPoolExecutor")
  }
}

from IntegerLiteral zero, Sink set
where
  DataFlow::localFlow(DataFlow::exprNode(zero), DataFlow::exprNode(set.getArgument(0))) and
  zero.getIntValue() = 0
select set, "ScheduledThreadPoolExecutor.corePoolSize is set to have 0 threads."
