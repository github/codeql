/**
 * @name Manually checking http verb instead of using built in rails routes and protections
 * @description Manually checking HTTP verbs is an indication that multiple requests are routed to the same controller action. This could lead to bypassing necessary authorization methods and other protections, like CSRF protection. Prefer using different controller actions for each HTTP method and relying Rails routing to handle mappting resources and verbs to specific methods.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision medium
 * @id rb/manually-checking-http-verb
 * @tags security
 */

import ruby
import codeql.ruby.DataFlow

class ManuallyCheckHttpVerb extends DataFlow::CallNode {
  ManuallyCheckHttpVerb() {
    this instanceof CheckGetRequest or
    this instanceof CheckPostRequest or
    this instanceof CheckPatchRequest or
    this instanceof CheckPostRequest or
    this instanceof CheckDeleteRequest or
    this instanceof CheckHeadRequest or
    this instanceof CheckRequestMethodFromEnv
  }
}

class CheckRequestMethodFromEnv extends DataFlow::CallNode {
  CheckRequestMethodFromEnv() {
    // is this node an instance of `env["REQUEST_METHOD"]
    this.getExprNode().getNode() instanceof GetRequestMethodFromEnv and
    (
      // and is this node a param of a call to `.include?`
      exists(MethodCall call | call.getAnArgument() = this.getExprNode().getNode() |
        call.getMethodName() = "include?"
      )
      or
      exists(DataFlow::Node node |
        node.asExpr().getExpr().(MethodCall).getMethodName() = "include?"
      |
        node.getALocalSource() = this
      )
      or
      // or is this node on either size of an equality comparison
      exists(EqualityOperation eq | eq.getAChild() = this.getExprNode().getNode())
    )
  }
}

class GetRequestMethodFromEnv extends ElementReference {
  GetRequestMethodFromEnv() {
    this.getAChild+().toString() = "REQUEST_METHOD" and
    this.getAChild+().toString() = "env"
  }
}

class CheckGetRequest extends DataFlow::CallNode {
  CheckGetRequest() { this.getMethodName() = "get?" }
}

class CheckPostRequest extends DataFlow::CallNode {
  CheckPostRequest() { this.getMethodName() = "post?" }
}

class CheckPutRequest extends DataFlow::CallNode {
  CheckPutRequest() { this.getMethodName() = "put?" }
}

class CheckPatchRequest extends DataFlow::CallNode {
  CheckPatchRequest() { this.getMethodName() = "patch?" }
}

class CheckDeleteRequest extends DataFlow::CallNode {
  CheckDeleteRequest() { this.getMethodName() = "delete?" }
}

class CheckHeadRequest extends DataFlow::CallNode {
  CheckHeadRequest() { this.getMethodName() = "head?" }
}

from ManuallyCheckHttpVerb check
select check,
  "Manually checking HTTP verbs is an indication that multiple requests are routed to the same controller action. This could lead to bypassing necessary authorization methods and other protections, like CSRF protection. Prefer using different controller actions for each HTTP method and relying Rails routing to handle mappting resources and verbs to specific methods."
