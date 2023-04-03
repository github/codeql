/**
 * @name Static initialization vector for encryption
 * @description Using a static initialization vector (IV) for encryption is not secure. To maximize encryption and prevent dictionary attacks, IVs should be unique and unpredictable.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id swift/static-initialization-vector
 * @tags security
 *       external/cwe/cwe-329
 *       external/cwe/cwe-1204
 */

import swift
import codeql.swift.security.StaticInitializationVectorQuery
import StaticInitializationVectorFlow::PathGraph

from
  StaticInitializationVectorFlow::PathNode sourceNode,
  StaticInitializationVectorFlow::PathNode sinkNode
where StaticInitializationVectorFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The static value '" + sourceNode.getNode().toString() +
    "' is used as an initialization vector for encryption."
