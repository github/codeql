/**
 * @name Cleartext transmission of sensitive information
 * @description Transmitting sensitive information across a network in
 *              cleartext can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id swift/cleartext-transmission
 * @tags security
 *       external/cwe/cwe-319
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.CleartextTransmissionQuery
import CleartextTransmissionFlow::PathGraph

from CleartextTransmissionFlow::PathNode sourceNode, CleartextTransmissionFlow::PathNode sinkNode
where CleartextTransmissionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This operation transmits '" + sinkNode.getNode().toString() +
    "', which may contain unencrypted sensitive data from $@.", sourceNode,
  sourceNode.getNode().toString()
