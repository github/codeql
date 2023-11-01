/**
 * @name Database query built from user-controlled sources
 * @description Finds places where a value from a remote or local user input
 *              is used as an argument to the SQLite ``Connection.execute(_:)``
 *              function.
 * @id swift/examples/simple-sql-injection
 * @tags example
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources

module SqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) {
    exists(CallExpr call |
      call.getStaticTarget().(Method).hasQualifiedName("Connection", "execute(_:)") and
      call.getArgument(0).getExpr() = node.asExpr()
    )
  }
}

module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;

from DataFlow::Node sourceNode, DataFlow::Node sinkNode
where SqlInjectionFlow::flow(sourceNode, sinkNode)
select sinkNode, "This query depends on a $@.", sourceNode, "user-provided value"
