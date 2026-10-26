import cpp
import semmle.code.cpp.dataflow.TaintTracking

module TaintedFormatConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { /* TBD */ }

  predicate isSink(DataFlow::Node sink) { /* TBD */ }
}

module TaintedFormatFlow = TaintTracking::Global<TaintedFormatConfig>;

from DataFlow::Node source, DataFlow::Node sink
where TaintedFormatFlow::flow(source, sink)
select sink, "This format string may be derived from a $@.", source, "user-controlled value"
