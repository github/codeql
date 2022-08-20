/**
 * Provides a library for local (intra-procedural) and global (inter-procedural)
 * data flow analysis: deciding whether data can flow from a _source_ to a
 * _sink_. This library differs from the one in `semmle.code.cpp.dataflow` in that
 * this library uses the IR (Intermediate Representation) library, which provides
 * a more precise semantic representation of the program, whereas the other dataflow
 * library uses the more syntax-oriented ASTs. This library should provide more accurate
 * results than the AST-based library in most scenarios.
 *
 * Unless configured otherwise, _flow_ means that the exact value of
 * the source may reach the sink. We do not track flow across pointer
 * dereferences or array indexing.
 *
 * To use global (interprocedural) data flow, extend the class
 * `DataFlow::Configuration` as documented on that class. To use local
 * (intraprocedural) data flow between expressions, call
 * `DataFlow::localExprFlow`. For more general cases of local data flow, call
 * `DataFlow::localFlow` or `DataFlow::localFlowStep` with arguments of type
 * `DataFlow::Node`.
 */

import cpp

module DataFlow {
  import semmle.code.cpp.ir.dataflow.internal.DataFlowImpl
}
