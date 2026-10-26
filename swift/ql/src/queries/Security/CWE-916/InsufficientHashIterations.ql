/**
 * @name Insufficient hash iterations
 * @description Using hash functions with fewer than 120,000 iterations is insufficient to protect passwords because a cracking attack will require a low level of computational effort.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id swift/insufficient-hash-iterations
 * @tags security
 *       external/cwe/cwe-916
 */

import swift
import codeql.swift.security.InsufficientHashIterationsQuery
import InsufficientHashIterationsFlow::PathGraph

from
  InsufficientHashIterationsFlow::PathNode sourceNode,
  InsufficientHashIterationsFlow::PathNode sinkNode
where InsufficientHashIterationsFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The value '" + sourceNode.getNode().toString() +
    "' is an insufficient number of iterations for secure password hashing."
