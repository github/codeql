/**
 * @name Weak or direct parameter references are used
 * @description Directly checking request parameters without following a strong params pattern can lead to unintentional avenues for injection attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision medium
 * @id rb/weak-params
 * @tags security
 *       experimental
 */

import codeql.ruby.AST
import codeql.ruby.Concepts
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import codeql.ruby.frameworks.ActionController
import DataFlow::PathGraph

/**
 * Gets a call to `request` in an ActionController controller class.
 * This probably refers to the incoming HTTP request object.
 */
DataFlow::LocalSourceNode request() {
  result = any(ActionControllerClass cls).getSelf().getAMethodCall("request")
}

/**
 * A direct parameters reference that happens inside a controller class.
 */
class WeakParams extends DataFlow::CallNode {
  WeakParams() {
    this =
      request()
          .getAMethodCall([
              "path_parameters", "query_parameters", "request_parameters", "GET", "POST"
            ])
  }
}

/**
 * A Taint tracking config where the source is a weak params access in a controller and the sink
 * is a method call of a model class
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "WeakParamsConfiguration" }

  override predicate isSource(DataFlow::Node node) { node instanceof WeakParams }

  // the sink is an instance of a Model class that receives a method call
  override predicate isSink(DataFlow::Node node) { node = any(PersistentWriteAccess a).getValue() }
}

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "By exposing all keys in request parameters or by blindy accessing them, unintended parameters could be used and lead to mass-assignment or have other unexpected side-effects. It is safer to follow the 'strong parameters' pattern in Rails, which is outlined here: https://api.rubyonrails.org/classes/ActionController/StrongParameters.html"
