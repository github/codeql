/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */
module TaintTracking {
  import codeql.ruby.dataflow.internal.TaintTrackingPublic
  private import codeql.ruby.dataflow.internal.DataFlowImplSpecific
  private import codeql.ruby.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  private import codeql.Locations
  import TaintFlowMake<Location, RubyDataFlow, RubyTaintTracking>
}
