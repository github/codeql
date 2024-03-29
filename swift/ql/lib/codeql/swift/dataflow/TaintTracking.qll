/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */
module TaintTracking {
  import codeql.swift.dataflow.internal.tainttracking1.TaintTrackingParameter::Public
  private import codeql.swift.dataflow.internal.DataFlowImplSpecific
  private import codeql.swift.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  private import codeql.swift.elements.Location
  import TaintFlowMake<Location, SwiftDataFlow, SwiftTaintTracking>
  import codeql.swift.dataflow.internal.tainttracking1.TaintTrackingImpl
}
