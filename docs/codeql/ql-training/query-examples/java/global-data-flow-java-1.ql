import java
import semmle.code.java.dataflow.TaintTracking

module TaintedOgnlConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { /* TBD */ }

  predicate isSink(DataFlow::Node sink) { /* TBD */ }
}

module TaintedOgnlFlow = TaintTracking::Global<TaintedOgnlConfig>;

from DataFlow::Node source, DataFlow::Node sink
where TaintedOgnlFlow::flow(source, sink)
select source, "This untrusted input is evaluated as an OGNL expression $@.", sink, "here"
