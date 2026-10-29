/**
 * @name Information disclosure through postMessage
 * @description Tracks values from an 'authKey' property into a postMessage call with unrestricted origin,
 *              indicating a leak of sensitive information.
 * @kind path-problem
 * @problem.severity warning
 * @tags security
 * @id js/examples/information-disclosure
 */

import javascript

/**
 * A dataflow configuration that tracks authentication tokens ("authKey")
 * to a postMessage call with unrestricted target origin.
 *
 * For example:
 * ```
 * win.postMessage(JSON.stringify({
 *  action: 'pause',
 *  auth: {
 *    key: window.state.authKey
 *  }
 * }), '*');
 * ```
 */
module AuthKeyTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.(DataFlow::PropRead).getPropertyName() = "authKey"
  }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() = "postMessage" and
      call.getArgument(1).getStringValue() = "*" and // no restriction on target origin
      call.getArgument(0) = node
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Step into objects: x -> { f: x }
    node2.(DataFlow::SourceNode).getAPropertyWrite().getRhs() = node1
    or
    // Step through JSON serialization: x -> JSON.stringify(x)
    // Note: TaintTracking::Configuration includes this step by default, but not DataFlow::Configuration
    exists(DataFlow::CallNode call |
      call = DataFlow::globalVarRef("JSON").getAMethodCall("stringify") and
      node1 = call.getArgument(0) and
      node2 = call
    )
  }
}

module AuthKeyTracking = DataFlow::Global<AuthKeyTrackingConfig>;

import AuthKeyTracking::PathGraph

from AuthKeyTracking::PathNode source, AuthKeyTracking::PathNode sink
where AuthKeyTracking::flowPath(source, sink)
select sink.getNode(), source, sink, "Message leaks the authKey from $@.", source.getNode(), "here"
