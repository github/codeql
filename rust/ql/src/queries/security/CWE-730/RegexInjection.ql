/**
 * @name Regular expression injection
 * @description
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id rust/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

private import codeql.rust.security.regex.RegexInjectionQuery
private import RegexInjectionFlow::PathGraph

from RegexInjectionFlow::PathNode sourceNode, RegexInjectionFlow::PathNode sinkNode
where RegexInjectionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "This regular expression is constructed from a $@.", sourceNode.getNode(), "user-provided value"
