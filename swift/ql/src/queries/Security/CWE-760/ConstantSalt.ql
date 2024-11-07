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

from
  ConstantSaltFlow::PathNode sourcePathNode, ConstantSaltFlow::PathNode sinkPathNode,
  DataFlow::Node sourceNode
where
  ConstantSaltFlow::flowPath(sourcePathNode, sinkPathNode) and sourceNode = sourcePathNode.getNode()
select sinkPathNode.getNode(), sourcePathNode, sinkPathNode,
  "The value $@ is used as a constant, which is insecure for hashing passwords.", sourceNode,
  sourceNode.toString()
