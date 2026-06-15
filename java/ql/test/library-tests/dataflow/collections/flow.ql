import java
import semmle.code.java.dataflow.TaintTracking

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    (
      src.asExpr().(VarAccess).getVariable().hasName("tainted")
      or
      src.asParameter().getCallable().hasName("taintSteps")
      or
      src.asExpr() = any(MethodCall ma | ma.getMethod().hasName("source")).getAnArgument()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      sink.asExpr() = ma.getAnArgument() and
      ma.getMethod().hasName("sink")
      or
      sink.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = ma and
      ma.getMethod().hasName("mkSink")
    )
  }
}

module Flow = TaintTracking::Global<Config>;

from DataFlow::Node src, DataFlow::Node sink
where Flow::flow(src, sink)
select src, sink
