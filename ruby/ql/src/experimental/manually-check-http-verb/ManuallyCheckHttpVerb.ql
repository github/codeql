/**
 * @name Manually checking http verb instead of using built in rails routes and protections
 * @description Manually checking HTTP verbs is an indication that multiple requests are routed to the same controller action. This could lead to bypassing necessary authorization methods and other protections, like CSRF protection. Prefer using different controller actions for each HTTP method and relying Rails routing to handle mappting resources and verbs to specific methods.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision low
 * @id rb/manually-checking-http-verb
 * @tags security
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.controlflow.CfgNodes
import codeql.ruby.frameworks.ActionController

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

// A conditional expression where the condition uses `request.method`, `request.request_method`, `request.raw_request_method`, `request.request_method_symbol`, or `request.get?` in some way.
// e.g.
// ```
// r = request.request_method
// if r == "GET"
// ...
// ```
class RequestMethodConditional extends DataFlow::Node {
  RequestMethodConditional() {
    // We have to cast the dataflow node down to a specific CFG node (`ExprNodes::ConditionalExprCfgNode`) to be able to call `getCondition()`.
    // We then find the dataflow node corresponding to the condition CFG node,
    // and filter for just nodes where a request method accessor value flows to them.
    exists(DataFlow::Node conditionNode |
      conditionNode.asExpr() = this.asExpr().(ExprNodes::ConditionalExprCfgNode).getCondition()
    |
      (
        any(RequestMethod r).flowsTo(conditionNode) or
        any(RequestRequestMethod r).flowsTo(conditionNode) or
        any(RequestRawRequestMethod r).flowsTo(conditionNode) or
        any(RequestRequestMethodSymbol r).flowsTo(conditionNode) or
        any(RequestGet r).flowsTo(conditionNode)
      )
    )
  }
}

from RequestMethodConditional req
select req,
  "Manually checking HTTP verbs is an indication that multiple requests are routed to the same controller action. This could lead to bypassing necessary authorization methods and other protections, like CSRF protection. Prefer using different controller actions for each HTTP method and relying Rails routing to handle mappting resources and verbs to specific methods."
