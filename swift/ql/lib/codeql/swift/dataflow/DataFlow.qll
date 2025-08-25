/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */
module DataFlow {
  private import internal.DataFlowImplSpecific
  private import codeql.dataflow.DataFlow
  private import codeql.swift.elements.Location
  import DataFlowMake<Location, SwiftDataFlow>
  import Public
}
