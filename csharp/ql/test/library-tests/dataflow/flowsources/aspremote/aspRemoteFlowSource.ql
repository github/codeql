import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote

query predicate remoteFlowSourceMembers(TaintTracking::TaintedMember m) { m.fromSource() }

query predicate remoteFlowSources(AspNetCoreRemoteFlowSource s) {
  s.getEnclosingCallable().fromSource()
}

// Accessor bodies of generic types are only extracted for the unbound declaration.
query predicate genericCandidateMembers(CandidateMemberToTaint m) {
  m.getDeclaringType().getName().matches("GenericModel%")
}
