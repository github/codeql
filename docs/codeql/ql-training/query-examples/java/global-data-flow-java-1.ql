import java
import semmle.code.java.dataflow.TaintTracking

module TaintedOGNLConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { /* TBD */ }

  predicate isSink(DataFlow::Node sink) { /* TBD */ }
}

module TaintedOGNLFlow = TaintTracking::Global<TaintedOGNLConfig>;

from DataFlow::Node source, DataFlow::Node sink
where TaintedOGNLFlow::flow(source, sink)
select source, "This untrusted input is evaluated as an OGNL expression $@.", sink, "here"
