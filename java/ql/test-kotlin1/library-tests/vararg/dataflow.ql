import java
import semmle.code.java.dataflow.DataFlow

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    n.asExpr().(CompileTimeConstantExpr).getEnclosingCallable().fromSource()
  }

  predicate isSink(DataFlow::Node n) {
    n.asExpr() = any(MethodCall ma | ma.getMethod().getName() = "sink").getAnArgument()
  }
}

module Flow = DataFlow::Global<Config>;

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
