/**
 * @name Database query built from user-controlled sources
 * @description Building a database query from user-controlled sources is vulnerable to insertion of malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id swift/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.SqlInjectionQuery
import DataFlow::PathGraph

from SqlInjectionConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This query depends on a $@.",
  sourceNode.getNode(), "user-provided value"
