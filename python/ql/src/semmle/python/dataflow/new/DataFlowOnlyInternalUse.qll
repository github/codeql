/**
 * INTERNAL: Do not use.
 *
 * This copy exists to allow internal non-query usage of global data-flow analyses. If
 * we used the same copy as was used in multiple queries (A, B, C), then all internal
 * non-query configurations would have to be re-evaluated for _each_ query, which is
 * expensive. By having a separate copy, we avoid this re-evaluation.
 *
 * Provides a library for local (intra-procedural) and global (inter-procedural)
 * data flow analysis: deciding whether data can flow from a _source_ to a
 * _sink_.
 *
 * Unless configured otherwise, _flow_ means that the exact value of
 * the source may reach the sink. We do not track flow across pointer
 * dereferences or array indexing. To track these types of flow, where the
 * exact value may not be preserved, import
 * `semmle.python.dataflow.new.TaintTracking`.
 *
 * To use global (interprocedural) data flow, extend the class
 * `DataFlow::Configuration` as documented on that class. To use local
 * (intraprocedural) data flow, call `DataFlow::localFlow` or
 * `DataFlow::localFlowStep` with arguments of type `DataFlow::Node`.
 */

private import python

/**
 * INTERNAL: Do not use.
 *
 * This copy exists to allow internal non-query usage of global data-flow analyses. If
 * we used the same copy as was used in multiple queries (A, B, C), then all internal
 * non-query configurations would have to be re-evaluated for _each_ query, which is
 * expensive. By having a separate copy, we avoid this re-evaluation.
 *
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */
module DataFlowOnlyInternalUse {
  import semmle.python.dataflow.new.internal.DataFlowImplOnlyInternalUse
}
