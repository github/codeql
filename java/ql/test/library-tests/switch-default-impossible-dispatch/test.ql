import java
import semmle.code.java.dataflow.DataFlow

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() = any(MethodCall mc | mc.getMethod().getName() = "source")
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(MethodCall mc | mc.getMethod().getName() = "sink").getAnArgument()
  }
}

module Flow = DataFlow::Global<TestConfig>;

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
