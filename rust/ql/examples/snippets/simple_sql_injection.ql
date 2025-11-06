/**
 * @name Database query built from user-controlled sources
 * @description Finds places where a value from a remote or local user input
 *              is used as an argument to the `sqlx_core::query::query`
 *              function.
 * @id rust/examples/simple-sql-injection
 * @tags example
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.Concepts

module SqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node node) {
    exists(CallExpr call |
      call.getStaticTarget().getCanonicalPath() = "sqlx_core::query::query" and
      call.getArg(0) = node.asExpr().getExpr()
    )
  }
}

module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;

from DataFlow::Node sourceNode, DataFlow::Node sinkNode
where SqlInjectionFlow::flow(sourceNode, sinkNode)
select sinkNode, "This query depends on a $@.", sourceNode, "user-provided value"
