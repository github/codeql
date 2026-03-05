/**
 * @name URL redirect from remote source
 * @description Using user-controlled data in a redirect header may allow an
 *              attacker to redirect clients to a malicious URL.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision medium
 * @id php/open-redirect
 * @tags security
 *       external/cwe/cwe-601
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
 * A sink that redirects the user via `header()`.
 */
class RedirectSink extends DataFlow::ExprNode {
  RedirectSink() {
    exists(FunctionCallExpr call |
      call.getFunctionName() = "header" and
      this.asExpr() = call.getArgument(0)
    )
  }
}

module OpenRedirectConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UserInputSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof RedirectSink }
}

module OpenRedirectFlow = TaintTracking::Global<OpenRedirectConfig>;

import OpenRedirectFlow::PathGraph

from OpenRedirectFlow::PathNode source, OpenRedirectFlow::PathNode sink
where OpenRedirectFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This redirect URL depends on a $@.", source.getNode(),
  "user-provided value"
