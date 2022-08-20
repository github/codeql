import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote

query predicate remoteFlowSourceMembers(TaintTracking::TaintedMember m) { m.fromSource() }

query predicate remoteFlowSources(AspNetCoreRemoteFlowSource s) {
  s.getEnclosingCallable().fromSource()
}
