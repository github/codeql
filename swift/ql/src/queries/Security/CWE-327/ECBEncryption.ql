/**
 * @name Encryption using ECB
 * @description Using the ECB encryption mode makes code vulnerable to replay attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id swift/ecb-encryption
 * @tags security
 *       external/cwe/cwe-327
 */

import swift
import codeql.swift.security.ECBEncryptionQuery
import EcbEncryptionFlow::PathGraph

from EcbEncryptionFlow::PathNode sourceNode, EcbEncryptionFlow::PathNode sinkNode
where EcbEncryptionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The initialization of the cipher '" + sinkNode.getNode().toString() +
    "' uses the insecure ECB block mode from $@.", sourceNode, sourceNode.getNode().toString()
