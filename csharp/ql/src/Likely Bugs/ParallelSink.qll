import csharp
import semmle.code.csharp.dataflow.DataFlow

abstract class ParallelSink extends DataFlow::Node {
}

class LambdaParallelSink extends ParallelSink {
  LambdaParallelSink() {
    exists( Class c, Method m, MethodCall mc, Expr e | 
        e = this.asExpr() |
        c.getABaseType*().hasQualifiedName("System.Threading.Tasks", "Parallel")
        and c.getAMethod() = m
        and m.getName() = "Invoke"
        and m.getACall() = mc
        and mc.getAnArgument() = e
      )
  }
}
