import semmle.code.csharp.security.dataflow.flowsources.Remote

query predicate remoteFlowSourceMembers(TaintTracking::TaintedMember m) { m.fromSource() }

query predicate remoteFlowSources(RemoteFlowSource source, string type) {
  source.getLocation().getFile().fromSource() and type = source.getSourceType()
}
