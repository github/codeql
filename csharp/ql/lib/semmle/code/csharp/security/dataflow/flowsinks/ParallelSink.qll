/**
 * Provides class representing parallel sink nodes.
 */

import csharp
private import FlowSinks

/**
 * A data flow sink node for parallel execution.
 */
abstract class ParallelSink extends ApiSinkNode { }

/**
 * A data flow sink node for lambda parallel sink.
 */
class LambdaParallelSink extends ParallelSink {
  LambdaParallelSink() {
    exists(Class c, Method m, MethodCall mc, Expr e | e = this.asExpr() |
      c.getABaseType*().hasFullyQualifiedName("System.Threading.Tasks", "Parallel") and
      c.getAMethod() = m and
      m.getName() = "Invoke" and
      m.getACall() = mc and
      mc.getAnArgument() = e
    )
  }
}

/**
 * A data flow sink node for thread start parallel sink.
 */
class ThreadStartParallelSink extends ParallelSink {
  ThreadStartParallelSink() {
    exists(DelegateCreation dc, Expr e | e = this.asExpr() |
      dc.getArgument() = e and
      dc.getType().getName().matches("%Start")
    )
  }
}
