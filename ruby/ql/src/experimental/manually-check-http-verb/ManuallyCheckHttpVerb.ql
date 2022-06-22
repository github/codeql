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

class CheckNotGetRequest extends ConditionalExpr {
  CheckNotGetRequest() { this.getCondition() instanceof CheckGetRequest }
}

class CheckGetRequest extends MethodCall {
  CheckGetRequest() { this.getMethodName() = "get?" }
}

class ControllerClass extends ModuleBase {
  ControllerClass() { this.getModule().getSuperClass+().toString() = "ApplicationController" }
}

class CheckGetFromEnv extends AstNode {
  CheckGetFromEnv() {
    // is this node an instance of `env["REQUEST_METHOD"]
    this instanceof GetRequestMethodFromEnv and
    // check if env["REQUEST_METHOD"] is compared to GET
    exists(EqualityOperation eq | eq.getAChild() = this |
      eq.getAChild().(StringLiteral).toString() = "GET"
    )
  }
}

class GetRequestMethodFromEnv extends ElementReference {
  GetRequestMethodFromEnv() {
    this.getAChild+().toString() = "REQUEST_METHOD" and
    this.getAChild+().toString() = "env"
  }
}

from AstNode node
where
  (
    node instanceof CheckNotGetRequest or
    node instanceof CheckGetFromEnv
  ) and
  node.getEnclosingModule() instanceof ControllerClass
select node,
  "Manually checking HTTP verbs is an indication that multiple requests are routed to the same controller action. This could lead to bypassing necessary authorization methods and other protections, like CSRF protection. Prefer using different controller actions for each HTTP method and relying Rails routing to handle mappting resources and verbs to specific methods."
