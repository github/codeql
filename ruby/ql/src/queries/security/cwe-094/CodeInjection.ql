/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user to perform arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @sub-severity high
 * @precision high
 * @id rb/code-injection
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-116
 */

import ruby
import codeql.ruby.security.CodeInjectionQuery
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink, Source sourceNode
where
  config.hasFlowPath(source, sink) and
  sourceNode = source.getNode()
select sink.getNode(), source, sink, "$@ flows to here and is interpreted as code.",
  source.getNode(), "User-provided value"
