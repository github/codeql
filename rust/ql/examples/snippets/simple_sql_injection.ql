/**
 * @name Database query built from user-controlled sources
 * @description Finds places where a value from a remote or local user input
 *              is used as the first argument of a call to `sqlx_core::query::query`.
 * @id rust/examples/simple-sql-injection
 * @tags example
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.Concepts

/**
 * A data flow configuration for tracking flow from a user input (threat model
 * source) to the first argument of a call to `sqlx_core::query::query`.
 */
module SqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    // `node` is a user input (threat model source)
    node instanceof ActiveThreatModelSource
  }

  predicate isSink(DataFlow::Node node) {
    // `node` is the first argument of a call to `sqlx_core::query::query`
    exists(Call call |
      call.getStaticTarget().getCanonicalPath() = "sqlx_core::query::query" and
      call.getPositionalArgument(0) = node.asExpr()
    )
  }
}

// instantiate the data flow configuration as a global taint tracking module
module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;

// report flows from sources to sinks
from DataFlow::Node sourceNode, DataFlow::Node sinkNode
where SqlInjectionFlow::flow(sourceNode, sinkNode)
select sinkNode, "This query depends on a $@.", sourceNode, "user-provided value"
