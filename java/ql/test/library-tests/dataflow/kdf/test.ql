import java
import semmle.code.java.dataflow.TaintTracking

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    exists(ArrayAccess aa |
      aa.getArray().(VarAccess).getVariable().hasName("args") and
      n.asExpr() = aa
    )
  }

  predicate isSink(DataFlow::Node n) {
    exists(MethodCall ma |
      ma.getMethod().hasName("sink") and
      n.asExpr() = ma.getAnArgument()
    )
  }
}

module Flow = TaintTracking::Global<Config>;

from DataFlow::Node src, DataFlow::Node sink
where Flow::flow(src, sink)
select src, sink
