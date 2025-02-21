import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.DataFlow

private predicate isSafe(Guard g, Expr checked, boolean branch) {
  exists(MethodCall mc | g = mc |
    mc.getMethod().hasName("isSafe") and
    checked = mc.getAnArgument() and
    branch = true
  )
}

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(MethodCall).getMethod().hasName("source")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc | mc.getMethod().hasName("sink") and mc.getAnArgument() = sink.asExpr())
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<isSafe/3>::getABarrierNode()
  }
}

module Flow = DataFlow::Global<TestConfig>;

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
