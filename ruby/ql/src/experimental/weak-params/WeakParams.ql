/**
 * @name Weak or direct parameter references are used
 * @description Directly checking request parameters without following a strong params pattern can lead to unintentional avenues for injection attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision low
 * @id rb/weak-params
 * @tags security
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import DataFlow::PathGraph

class WeakParams extends Expr {
  WeakParams() {
    allParamsAccess(this) or
    this instanceof ParamsReference
  }
}

class ControllerClass extends ModuleBase {
  ControllerClass() { this.getModule().getSuperClass+().toString() = "ApplicationController" }
}

class StrongParamsMethod extends Method {
  StrongParamsMethod() { this.getName().regexpMatch(".*_params") }
}

predicate allParamsAccess(MethodCall call) {
  call.getMethodName() = "expose_all" or
  call.getMethodName() = "original_hash" or
  call.getMethodName() = "path_parametes" or
  call.getMethodName() = "query_parameters" or
  call.getMethodName() = "request_parameters" or
  call.getMethodName() = "GET" or
  call.getMethodName() = "POST"
}

class ParamsReference extends ElementReference {
  ParamsReference() { this.getAChild().toString() = "params" }
}

class ModelClass extends ModuleBase {
  ModelClass() {
    this.getModule().getSuperClass+().toString() = "ViewModel" or
    this.getModule().getSuperClass+().getAnIncludedModule().toString() = "ActionModel::Model"
  }
}

class ModelClassMethodArgument extends DataFlow::Node {
  private DataFlow::CallNode call;

  ModelClassMethodArgument() {
    this = call.getArgument(_) and
    call.getExprNode().getNode().getParent+() instanceof ModelClass
  }
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "Configuration" }

  override predicate isSource(DataFlow::Node node) { node.asExpr().getNode() instanceof WeakParams }

  // the sink is an instance of a Model class that receives a method call
  override predicate isSink(DataFlow::Node node) { node instanceof ModelClassMethodArgument }
}

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode().(ModelClassMethodArgument), source, sink, "This is bad"
// from WeakParams params
// where
//   not params.getEnclosingMethod() instanceof StrongParamsMethod and
//   params.getEnclosingModule() instanceof ControllerClass
// select params,
//   "By exposing all keys in request parameters or by blindy accessing them, unintended parameters could be used and lead to mass-assignment or have other unexpected side-effects."
