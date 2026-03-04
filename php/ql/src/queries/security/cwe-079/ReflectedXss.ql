/**
 * @name Reflected cross-site scripting
 * @description Writing user input directly to a web page allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision medium
 * @id php/reflected-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import codeql.php.AST
import codeql.php.DataFlow
import codeql.php.TaintTracking

/**
 * A source of user input from PHP superglobals.
 */
class UserInputSource extends DataFlow::ExprNode {
  UserInputSource() {
    exists(VariableName v | v = this.asExpr() |
      v.getValue() = "$_GET" or
      v.getValue() = "$_POST" or
      v.getValue() = "$_REQUEST" or
      v.getValue() = "$_COOKIE"
    )
    or
    exists(SubscriptExpr sub, VariableName v |
      sub = this.asExpr() and
      v = sub.getObject() and
      (
        v.getValue() = "$_GET" or
        v.getValue() = "$_POST" or
        v.getValue() = "$_REQUEST" or
        v.getValue() = "$_COOKIE"
      )
    )
  }
}

/**
 * An output sink that writes directly to the response (echo, print, etc).
 */
class XssSink extends DataFlow::ExprNode {
  XssSink() {
    // echo statement arguments
    exists(EchoStmt echo | this.asExpr() = echo.getAnArgument())
    or
    // print expression
    exists(PrintExpr print | this.asExpr() = print.getArgument())
    or
    // printf/vprintf calls
    exists(FunctionCallExpr call |
      call.getFunctionName() = ["printf", "vprintf"] and
      this.asExpr() = call.getArgument(_)
    )
  }
}

module XssConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UserInputSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }

  predicate isBarrier(DataFlow::Node node) {
    // htmlspecialchars, htmlentities, strip_tags are sanitizers
    exists(FunctionCallExpr call |
      call.getFunctionName() = ["htmlspecialchars", "htmlentities", "strip_tags"] and
      node.asExpr() = call
    )
  }
}

module XssFlow = TaintTracking::Global<XssConfig>;

import XssFlow::PathGraph

from XssFlow::PathNode source, XssFlow::PathNode sink
where XssFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to a $@.",
  source.getNode(), "user-provided value"
