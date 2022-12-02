/**
 * @name Uncontrolled format string
 * @description Using external input in format strings can lead to exceptions or information leaks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id swift/uncontrolled-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.UncontrolledFormatStringQuery
import DataFlow::PathGraph

from TaintedFormatConfiguration config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This format string depends on $@.",
  sourceNode.getNode(), "this user-provided value"
