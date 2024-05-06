private import semmle.javascript.Locations
private import DataFlowImplSpecific
private import codeql.dataflow.DataFlow as SharedDataFlow
private import codeql.dataflow.TaintTracking as SharedTaintTracking

module JSDataFlow implements SharedDataFlow::InputSig<Location> {
  import Private
  import Public

  // Explicitly implement signature members that have a default
  predicate typeStrongerThan = Private::typeStrongerThan/2;

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;

  predicate accessPathLimit = Private::accessPathLimit/0;

  predicate viableImplInCallContext = Private::viableImplInCallContext/2;
}

module JSTaintFlow implements SharedTaintTracking::InputSig<Location, JSDataFlow> {
  import semmle.javascript.dataflow.internal.TaintTrackingPrivate
}
