/**
 * @name Cleartext storage of sensitive information in a local database
 * @description Storing sensitive information in a non-encrypted
 *              database can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id swift/cleartext-storage-database
 * @tags security
 *       external/cwe/cwe-312
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.CleartextStorageDatabaseQuery
import CleartextStorageFlow::PathGraph

/**
 * Gets a prettier node to use in the results.
 */
DataFlow::Node cleanupNode(DataFlow::Node n) {
  result = n.(DataFlow::PostUpdateNode).getPreUpdateNode()
  or
  not n instanceof DataFlow::PostUpdateNode and
  result = n
}

from
  CleartextStorageFlow::PathNode sourceNode, CleartextStorageFlow::PathNode sinkNode,
  DataFlow::Node cleanSink
where
  CleartextStorageFlow::flowPath(sourceNode, sinkNode) and
  cleanSink = cleanupNode(sinkNode.getNode())
select cleanSink, sourceNode, sinkNode,
  "This operation stores '" + cleanSink.toString() +
    "' in a database. It may contain unencrypted sensitive data from $@.", sourceNode,
  sourceNode.getNode().toString()
