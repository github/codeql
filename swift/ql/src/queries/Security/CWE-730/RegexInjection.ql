/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without first being escaped,
 *              otherwise a malicious user may be able to provide a regex that could require
 *              exponential time on certain inputs.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id swift/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.regex.RegexInjectionQuery
import RegexInjectionFlow::PathGraph

from RegexInjectionFlow::PathNode sourceNode, RegexInjectionFlow::PathNode sinkNode
where RegexInjectionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This regular expression is constructed from a $@.", sourceNode.getNode(), "user-provided value"
