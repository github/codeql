import java
import semmle.code.java.dataflow.TaintTracking

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest lambda" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().(VarAccess).getVariable().hasName("args")
    or
    src.asExpr().(MethodAccess).getMethod().hasName("source")
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr().(Argument).getCall() =
      any(MethodAccess ma |
        ma.getMethod().hasName("exec") and
        ma.getQualifier().(MethodAccess).getMethod().hasName("getRuntime")
      )
  }
}

from DataFlow::Node src, DataFlow::Node sink, Conf c
where c.hasFlow(src, sink)
select src, sink
