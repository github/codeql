/**
 * Provides a library for local (intra-procedural) and global (inter-procedural)
 * data flow analysis: deciding whether data can flow from a _source_ to a
 * _sink_.
 *
 * Unless configured otherwise, _flow_ means that the exact value of
 * the source may reach the sink.
 *
 * To use global (interprocedural) data flow, extend the class
 * `DataFlow::Configuration` as documented on that class. To use local
 * (intraprocedural) data flow between expressions, call
 * `DataFlow::localExprFlow`. For more general cases of local data flow, call
 * `DataFlow::localFlow` or `DataFlow::localFlowStep` with arguments of type
 * `DataFlow::Node`.
 */

import cpp

/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */
module DataFlow {
  import semmle.code.cpp.dataflow.old.internal.DataFlowImpl
}
