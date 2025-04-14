/**
 * @name Manually checking http verb instead of using built in rails routes and protections
 * @description Manually checking HTTP verbs is an indication that multiple requests are routed to the same controller action. This could lead to bypassing necessary authorization methods and other protections, like CSRF protection. Prefer using different controller actions for each HTTP method and relying Rails routing to handle mapping resources and verbs to specific methods.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision low
 * @id rb/manually-checking-http-verb
 * @tags security
 *       experimental
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.controlflow.CfgNodes
import codeql.ruby.frameworks.ActionController
import codeql.ruby.TaintTracking

// any `request` calls in an action method
class Request extends DataFlow::CallNode {
  Request() {
    this.getMethodName() = "request" and
    this.asExpr().getExpr().getEnclosingMethod() instanceof ActionControllerActionMethod
  }
}

// `request.env`
class RequestEnvMethod extends DataFlow::CallNode {
  RequestEnvMethod() {
    this.getMethodName() = "env" and
    any(Request r).flowsTo(this.getReceiver())
  }
}

// `request.request_method`
class RequestRequestMethod extends DataFlow::CallNode {
  RequestRequestMethod() {
    this.getMethodName() = "request_method" and
    any(Request r).flowsTo(this.getReceiver())
  }
}

// `request.method`
class RequestMethod extends DataFlow::CallNode {
  RequestMethod() {
    this.getMethodName() = "method" and
    any(Request r).flowsTo(this.getReceiver())
  }
}

// `request.raw_request_method`
class RequestRawRequestMethod extends DataFlow::CallNode {
  RequestRawRequestMethod() {
    this.getMethodName() = "raw_request_method" and
    any(Request r).flowsTo(this.getReceiver())
  }
}

// `request.request_method_symbol`
class RequestRequestMethodSymbol extends DataFlow::CallNode {
  RequestRequestMethodSymbol() {
    this.getMethodName() = "request_method_symbol" and
    any(Request r).flowsTo(this.getReceiver())
  }
}

// `request.get?`
class RequestGet extends DataFlow::CallNode {
  RequestGet() {
    this.getMethodName() = "get?" and
    any(Request r).flowsTo(this.getReceiver())
  }
}

private module HttpVerbConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RequestMethod or
    source instanceof RequestRequestMethod or
    source instanceof RequestEnvMethod or
    source instanceof RequestRawRequestMethod or
    source instanceof RequestRequestMethodSymbol or
    source instanceof RequestGet
  }

  predicate isSink(DataFlow::Node sink) {
    exists(ExprNodes::ConditionalExprCfgNode c | c.getCondition() = sink.asExpr()) or
    exists(ExprNodes::CaseExprCfgNode c | c.getValue() = sink.asExpr())
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

private module HttpVerbFlow = TaintTracking::Global<HttpVerbConfig>;

import HttpVerbFlow::PathGraph

from HttpVerbFlow::PathNode source, HttpVerbFlow::PathNode sink
where HttpVerbFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Manually checking HTTP verbs is an indication that multiple requests are routed to the same controller action. This could lead to bypassing necessary authorization methods and other protections, like CSRF protection. Prefer using different controller actions for each HTTP method and relying Rails routing to handle mapping resources and verbs to specific methods."
