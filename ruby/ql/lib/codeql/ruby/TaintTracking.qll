/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */
module TaintTracking {
  import codeql.ruby.dataflow.internal.tainttracking1.TaintTrackingParameter::Public
  private import codeql.ruby.dataflow.internal.DataFlowImplSpecific
  private import codeql.ruby.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  import TaintFlowMake<RubyDataFlow, RubyTaintTracking>
  import codeql.ruby.dataflow.internal.tainttracking1.TaintTrackingImpl
}
