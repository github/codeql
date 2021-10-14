import cpp
import semmle.code.cpp.dataflow.TaintTracking

class TaintedFormatConfig extends TaintTracking::Configuration {
  TaintedFormatConfig() { this = "TaintedFormatConfig" }
  override predicate isSource(DataFlow::Node source) { /* TBD */ }
  override predicate isSink(DataFlow::Node sink) { /* TBD */ }
}

from TaintedFormatConfig cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, "This format string may be derived from a $@.",
              source, "user-controlled value"
