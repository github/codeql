import semmle.code.csharp.security.dataflow.flowsources.Stored

class StoredConfig extends TaintTracking::Configuration {
  StoredConfig() { this = "stored" }

  override predicate isSource(DataFlow::Node s) { s instanceof StoredFlowSource }

  override predicate isSink(DataFlow::Node s) { s.asExpr().fromSource() }
}

from StoredConfig s, DataFlow::Node sink
where s.hasFlow(any(StoredFlowSource sfs), sink)
select sink
