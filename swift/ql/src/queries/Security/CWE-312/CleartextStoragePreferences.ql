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
import DataFlow::PathGraph

/**
 * Gets a prettier node to use in the results.
 */
DataFlow::Node cleanupNode(DataFlow::Node n) {
  result = n.(DataFlow::PostUpdateNode).getPreUpdateNode()
  or
  not n instanceof DataFlow::PostUpdateNode and
  result = n
}

from CleartextStorageConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select cleanupNode(sinkNode.getNode()), sourceNode, sinkNode,
  "This operation stores '" + sinkNode.getNode().toString() + "' in " +
    sinkNode.getNode().(CleartextStoragePreferencesSink).getStoreName() +
    ". It may contain unencrypted sensitive data from $@.", sourceNode,
  sourceNode.getNode().toString()
