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
import CodeInjectionFlow::PathGraph

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink, Source sourceNode
where
  CodeInjectionFlow::flowPath(source, sink) and
  sourceNode = source.getNode() and
  // removing duplications of the same path, but different flow-labels.
  sink =
    min(CodeInjectionFlow::PathNode otherSink |
      CodeInjectionFlow::flowPath(any(CodeInjectionFlow::PathNode s | s.getNode() = sourceNode),
        otherSink) and
      otherSink.getNode() = sink.getNode()
    |
      otherSink order by otherSink.getState().getStringRepresentation()
    )
select sink.getNode(), source, sink, "This code execution depends on a $@.", sourceNode,
  "user-provided value"
