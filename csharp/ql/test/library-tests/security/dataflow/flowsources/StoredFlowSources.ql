import semmle.code.csharp.security.dataflow.flowsources.Stored

module StoredConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node s) { s instanceof StoredFlowSource }

  predicate isSink(DataFlow::Node s) { s.asExpr().fromSource() }
}

module Stored = TaintTracking::Global<StoredConfig>;

from DataFlow::Node sink
where Stored::flow(any(StoredFlowSource sfs), sink)
select sink
