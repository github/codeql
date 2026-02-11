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

private import codeql.ruby.AST
private import codeql.ruby.security.CodeInjectionQuery
import DataFlow::DeduplicatePathGraph<CodeInjectionFlow::PathNode, CodeInjectionFlow::PathGraph>

from PathNode source, PathNode sink
where CodeInjectionFlow::flowPath(source.getAnOriginalPathNode(), sink.getAnOriginalPathNode())
select sink.getNode(), source, sink, "This code execution depends on a $@.", source.getNode(),
  "user-provided value"
