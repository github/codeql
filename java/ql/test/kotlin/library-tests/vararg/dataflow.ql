import java
import semmle.code.java.dataflow.DataFlow

class Config extends DataFlow::Configuration {
  Config() { this = "varargs-dataflow-test" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(CompileTimeConstantExpr).getEnclosingCallable().fromSource()
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr() = any(MethodAccess ma | ma.getMethod().getName() = "sink").getAnArgument()
  }
}

from DataFlow::Node source, DataFlow::Node sink, Config c
where c.hasFlow(source, sink)
select source, sink
