import java
import semmle.code.java.dataflow.TaintTracking

class TaintedOGNLConfig extends TaintTracking::Configuration {
  TaintedOGNLConfig() { this = "TaintedOGNLConfig" }
  override predicate isSource(DataFlow::Node source) { /* TBD */ }
  override predicate isSink(DataFlow::Node sink) { /* TBD */ }
}

from TaintedOGNLConfig cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select source,
       "This untrusted input is evaluated as an OGNL expression $@.",
       sink, "here"