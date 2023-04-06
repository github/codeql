/**
 * @name Constant password
 * @description Using constant passwords is not secure, because potential attackers can easily recover them from the source code.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.8
 * @precision high
 * @id swift/constant-password
 * @tags security
 *       external/cwe/cwe-259
 */

import swift
import codeql.swift.security.ConstantPasswordQuery
import ConstantPasswordFlow::PathGraph

from ConstantPasswordFlow::PathNode sourceNode, ConstantPasswordFlow::PathNode sinkNode
where ConstantPasswordFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The value '" + sourceNode.getNode().toString() + "' is used as a constant password."
