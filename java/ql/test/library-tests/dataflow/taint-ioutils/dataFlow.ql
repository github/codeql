import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UserInput }

  predicate isSink(DataFlow::Node sink) { any() }
}

module Flow = TaintTracking::Global<Config>;

from UserInput u, DataFlow::Node e
where Flow::flow(u, e) and e.getEnclosingCallable().hasName("ioutils")
select e
