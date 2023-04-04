/**
 * @name Cleartext storage of sensitive information in an application preference store
 * @description Storing sensitive information in a non-encrypted store can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id swift/cleartext-storage-preferences
 * @tags security
 *       external/cwe/cwe-312
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.CleartextStoragePreferencesQuery
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
  "This operation stores '" + cleanSink.toString() + "' in " +
    sinkNode.getNode().(CleartextStoragePreferencesSink).getStoreName() +
    ". It may contain unencrypted sensitive data from $@.", sourceNode,
  sourceNode.getNode().toString()
