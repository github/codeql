/**
 * @name Weak or direct parameter references are used
 * @description Directly checking request parameters without following a strong params pattern can lead to unintentional avenues for injection attacks.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision low
 * @id rb/weak-params
 * @tags security
 */

import ruby

class WeakParams extends AstNode {
  WeakParams() {
    this instanceof UnspecificParamsMethod or
    this instanceof ParamsReference
  }
}

class ControllerClass extends ModuleBase {
  ControllerClass() { this.getModule().getSuperClass+().toString() = "ApplicationController" }
}

class StrongParamsMethod extends Method {
  StrongParamsMethod() { this.getName().regexpMatch(".*_params") }
}

class UnspecificParamsMethod extends MethodCall {
  UnspecificParamsMethod() {
    (
      this.getMethodName() = "expose_all" or
      this.getMethodName() = "original_hash" or
      this.getMethodName() = "path_parametes" or
      this.getMethodName() = "query_parameters" or
      this.getMethodName() = "request_parameters" or
      this.getMethodName() = "GET" or
      this.getMethodName() = "POST"
    )
  }
}

class ParamsReference extends ElementReference {
  ParamsReference() { this.getAChild().toString() = "params" }
}

from WeakParams params
where
  not params.getEnclosingMethod() instanceof StrongParamsMethod and
  params.getEnclosingModule() instanceof ControllerClass
select params,
  "By exposing all keys in request parameters or by blindy accessing them, unintended parameters could be used and lead to mass-assignment or have other unexpected side-effects."
