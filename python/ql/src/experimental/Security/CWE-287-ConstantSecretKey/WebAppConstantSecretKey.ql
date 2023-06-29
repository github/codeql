/**
 * @name Initializing SECRET_KEY of Flask application with Constant value
 * @description Initializing SECRET_KEY of Flask application with Constant value
 * files can lead to Authentication bypass
 * @kind path-problem
 * @id py/flask-constant-secret-key
 * @problem.severity error
 * @security-severity 8.5
 * @precision high
 * @tags security
 *       experimental
 *       external/cwe/cwe-287
 */

import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import WebAppConstantSecretKeyDjango
import WebAppConstantSecretKeyFlask

newtype TFrameWork =
  Flask() or
  Django()

module WebAppConstantSecretKeyConfig implements DataFlow::StateConfigSig {
  class FlowState = TFrameWork;

  predicate isSource(DataFlow::Node source, FlowState state) {
    state = Flask() and FlaskConstantSecretKeyConfig::isSource(source)
    or
    state = Django() and DjangoConstantSecretKeyConfig::isSource(source)
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    state = Flask() and FlaskConstantSecretKeyConfig::isSink(sink)
    or
    state = Django() and DjangoConstantSecretKeyConfig::isSink(sink)
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) { none() }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    none()
  }
}

module WebAppConstantSecretKey = TaintTracking::GlobalWithState<WebAppConstantSecretKeyConfig>;

import WebAppConstantSecretKey::PathGraph

from WebAppConstantSecretKey::PathNode source, WebAppConstantSecretKey::PathNode sink
where WebAppConstantSecretKey::flowPath(source, sink)
select sink, source, sink, "The SECRET_KEY config variable is assigned by $@.", source,
  " this constant String"
