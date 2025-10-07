/**
 * @name Cleartext storage of sensitive information in a database
 * @description Storing sensitive information in a non-encrypted
 *              database can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id rust/cleartext-storage-database
 * @tags security
 *       external/cwe/cwe-312
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.CleartextStorageDatabaseExtensions

/**
 * A taint configuration from sensitive information to expressions that are
 * stored in a database.
 */
module CleartextStorageDatabaseConfig implements DataFlow::ConfigSig {
  import CleartextStorageDatabase

  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // flow from `a` to `&a`
    node2.asExpr().getExpr().(RefExpr).getExpr() = node1.asExpr().getExpr()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module CleartextStorageDatabaseFlow = TaintTracking::Global<CleartextStorageDatabaseConfig>;

import CleartextStorageDatabaseFlow::PathGraph

from
  CleartextStorageDatabaseFlow::PathNode sourceNode, CleartextStorageDatabaseFlow::PathNode sinkNode
where CleartextStorageDatabaseFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This database operation may read or write unencrypted sensitive data from $@.", sourceNode,
  sourceNode.getNode().toString()
