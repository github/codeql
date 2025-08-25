/**
 * Provides a library for local (intra-procedural) and global (inter-procedural)
 * data flow analysis: deciding whether data can flow from a _source_ to a
 * _sink_.
 *
 * Unless configured otherwise, _flow_ means that the exact value of
 * the source may reach the sink. We do not track flow across pointer
 * dereferences or array indexing. To track these types of flow, where the
 * exact value may not be preserved, import
 * `experimental.dataflow.TaintTracking`.
 *
 * To use global (interprocedural) data flow, extend the class
 * `DataFlow::Configuration` as documented on that class. To use local
 * (intraprocedural) data flow, call `DataFlow::localFlow` or
 * `DataFlow::localFlowStep` with arguments of type `DataFlow::Node`.
 */

private import python

/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */
module DataFlow {
  private import internal.DataFlowImplSpecific
  private import codeql.dataflow.DataFlow
  import DataFlowMake<Location, PythonDataFlow>
  import Public
}
