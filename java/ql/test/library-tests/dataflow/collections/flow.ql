import java
import semmle.code.java.dataflow.TaintTracking

class Conf extends TaintTracking::Configuration {
  Conf() { this = "conf" }

  override predicate isSource(DataFlow::Node src) {
    (
      src.asExpr().(VarAccess).getVariable().hasName("tainted")
      or
      src.asParameter().getCallable().hasName("taintSteps")
      or
      src.asExpr() = any(MethodAccess ma | ma.getMethod().hasName("source")).getAnArgument()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getAnArgument() and
      ma.getMethod().hasName("sink")
      or
      sink.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = ma and
      ma.getMethod().hasName("mkSink")
    )
  }
}

from Conf c, DataFlow::Node src, DataFlow::Node sink
where c.hasFlow(src, sink)
select src, sink
