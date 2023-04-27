/**
 * @name Hard-coded encryption key
 * @description Using hardcoded keys for encryption is not secure, because potential attackers can easily guess them.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.1
 * @precision high
 * @id swift/hardcoded-key
 * @tags security
 *       external/cwe/cwe-321
 */

import swift
import codeql.swift.security.HardcodedEncryptionKeyQuery
import HardcodedKeyFlow::PathGraph

from HardcodedKeyFlow::PathNode sourceNode, HardcodedKeyFlow::PathNode sinkNode
where HardcodedKeyFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The key '" + sinkNode.getNode().toString() +
    "' has been initialized with hard-coded values from $@.", sourceNode,
  sourceNode.getNode().toString()
