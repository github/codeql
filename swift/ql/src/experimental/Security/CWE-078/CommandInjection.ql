/**
 * @name System command built from user-controlled sources
 * @description Building a system command from user-controlled sources may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id swift/command-line-injection
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.CommandInjectionQuery
import CommandInjectionFlow::PathGraph

from CommandInjectionFlow::PathNode sourceNode, CommandInjectionFlow::PathNode sinkNode
where CommandInjectionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This command depends on a $@.",
  sourceNode.getNode(), "user-provided value"
