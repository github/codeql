/**
 * @name Weak or direct parameter references are used
 * @description Directly checking request parameters without following a strong params pattern can lead to unintentional avenues for injection attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision medium
 * @id rb/weak-params
 * @tags security
 *       external/cwe/cwe-223
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import DataFlow::PathGraph

/**
 * A direct parameters reference that happens outside of a strong params method but inside
 * of a controller class
 */
class WeakParams extends Expr {
  WeakParams() {
    (
      allParamsAccess(this) or
      this instanceof ParamsReference
    ) and
    this.getEnclosingModule() instanceof ControllerClass and
    not this.getEnclosingMethod() instanceof StrongParamsMethod
  }
}

/**
 * A controller class, which extendsd `ApplicationController`
 */
class ControllerClass extends ModuleBase {
  ControllerClass() { this.getModule().getSuperClass+().toString() = "ApplicationController" }
}

/**
 * A method that follows the strong params naming convention
 */
class StrongParamsMethod extends Method {
  StrongParamsMethod() { this.getName().regexpMatch(".*_params") }
}

/**
 * A call to a method that exposes or accesses all parameters from an inbound HTTP request
 */
predicate allParamsAccess(MethodCall call) {
  call.getMethodName() = "expose_all" or
  call.getMethodName() = "original_hash" or
  call.getMethodName() = "path_parametes" or
  call.getMethodName() = "query_parameters" or
  call.getMethodName() = "request_parameters" or
  call.getMethodName() = "GET" or
  call.getMethodName() = "POST"
}

/**
 * A reference to an element in the `params` object
 */
class ParamsReference extends ElementReference {
  ParamsReference() { this.getAChild().toString() = "params" }
}

/**
 * A Model or ViewModel classes with a base class of `ViewModel`, `ApplicationRecord` or includes `ActionModel::Model`,
 * which are required to support the strong parameters pattern
 */
class ModelClass extends ModuleBase {
  ModelClass() {
    this.getModule().getSuperClass+().toString() = "ViewModel" or
    this.getModule().getSuperClass+().toString() = "ApplicationRecord" or
    this.getModule().getSuperClass+().getAnIncludedModule().toString() = "ActionModel::Model"
  }
}

/**
 * A DataFlow::Node representation that corresponds to any argument passed into a method call
 * where the receiver is an instance of ModelClass
 */
class ModelClassMethodArgument extends DataFlow::Node {

  ModelClassMethodArgument() {
    exists( DataFlow::CallNode call | this = call.getArgument(_) |
      call.getExprNode().getNode().getParent+() instanceof ModelClass )
  }
}

/**
 * A Taint tracking config where the source is a weak params access in a controller and the sink
 * is a method call of a model class
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "Configuration" }

  override predicate isSource(DataFlow::Node node) { node.asExpr().getNode() instanceof WeakParams }

  // the sink is an instance of a Model class that receives a method call
  override predicate isSink(DataFlow::Node node) { node instanceof ModelClassMethodArgument }
}

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode().(ModelClassMethodArgument), source, sink,
  "By exposing all keys in request parameters or by blindy accessing them, unintended parameters could be used and lead to mass-assignment or have other unexpected side-effects. It is safer to follow the 'strong parameters' pattern in Rails, which is outlined here: https://api.rubyonrails.org/classes/ActionController/StrongParameters.html"
