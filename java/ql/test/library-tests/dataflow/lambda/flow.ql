import java
import semmle.code.java.dataflow.TaintTracking

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    src.asExpr().(VarAccess).getVariable().hasName("args")
    or
    src.asExpr().(MethodCall).getMethod().hasName("source")
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr().(Argument).getCall() =
      any(MethodCall ma |
        ma.getMethod().hasName("exec") and
        ma.getQualifier().(MethodCall).getMethod().hasName("getRuntime")
      )
  }
}

module Flow = TaintTracking::Global<Config>;

from DataFlow::Node src, DataFlow::Node sink
where Flow::flow(src, sink)
select src, sink
