/**
 * @name Database query built from user-controlled sources
 * @description Building a database query from user-controlled sources is vulnerable to insertion of malicious code by attackers.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id rust/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.SqlInjectionExtensions

/**
 * A taint configuration for tainted data that reaches a SQL sink.
 */
module SqlInjectionConfig implements DataFlow::ConfigSig {
  import SqlInjection

  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;

import SqlInjectionFlow::PathGraph

from SqlInjectionFlow::PathNode sourceNode, SqlInjectionFlow::PathNode sinkNode
where SqlInjectionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This query depends on a $@.",
  sourceNode.getNode(), "user-provided value"
