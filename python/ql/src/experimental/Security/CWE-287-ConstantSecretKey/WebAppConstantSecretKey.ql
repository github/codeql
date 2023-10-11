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
import semmle.python.filters.Tests

newtype TFrameWork =
  Flask() or
  Django()

private module WebAppConstantSecretKeyConfig implements DataFlow::StateConfigSig {
  class FlowState = TFrameWork;

  predicate isSource(DataFlow::Node source, FlowState state) {
    state = Flask() and FlaskConstantSecretKeyConfig::isSource(source)
    or
    state = Django() and DjangoConstantSecretKeyConfig::isSource(source)
  }

  predicate isBarrier(DataFlow::Node node) {
    node.getLocation().getFile().inStdlib()
    or
    // To reduce FP rate, the following was added
    node.getLocation()
        .getFile()
        .getRelativePath()
        .matches(["%test%", "%demo%", "%example%", "%sample%"]) and
    // but that also meant all data-flow nodes in query tests were excluded... so we had
    // to add this:
    not node.getLocation().getFile().getRelativePath().matches("%query-tests/Security/CWE-287%")
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    state = Flask() and FlaskConstantSecretKeyConfig::isSink(sink)
    or
    state = Django() and DjangoConstantSecretKeyConfig::isSink(sink)
  }
}

module WebAppConstantSecretKeyFlow = TaintTracking::GlobalWithState<WebAppConstantSecretKeyConfig>;

import WebAppConstantSecretKeyFlow::PathGraph

from WebAppConstantSecretKeyFlow::PathNode source, WebAppConstantSecretKeyFlow::PathNode sink
where WebAppConstantSecretKeyFlow::flowPath(source, sink)
select sink, source, sink, "The SECRET_KEY config variable is assigned by $@.", source,
  " this constant String"
