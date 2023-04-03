/**
 * @name Use of constant salts
 * @description Using constant salts for password hashing is not secure because potential attackers can precompute the hash value via dictionary attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id swift/constant-salt
 * @tags security
 *       external/cwe/cwe-760
 */

import swift
import codeql.swift.security.ConstantSaltQuery
import ConstantSaltFlow::PathGraph

from ConstantSaltFlow::PathNode sourceNode, ConstantSaltFlow::PathNode sinkNode
where ConstantSaltFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The value '" + sourceNode.getNode().toString() +
    "' is used as a constant salt, which is insecure for hashing passwords."
