/**
 * @name Uncontrolled data used in network request
 * @description Sending network requests with user-controlled data allows for request forgery attacks.
 * @id go/ssrf
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @tags security
 *       experimental
 *       external/cwe/cwe-918
 */

import go

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(DataFlow::MethodCallNode m |
      m.getTarget().hasQualifiedName("github.com/valyala/fasthttp.URI", ["SetHost", "SetHostBytes"]) and
      source = m.getArgument(0)
    )
  }

  predicate isSink(DataFlow::Node sink) { any() }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::MethodCallNode m, DataFlow::Variable frn |
      m.getTarget().hasQualifiedName("github.com/valyala/fasthttp.URI", ["SetHost", "SetHostBytes"]) and
      pred = m.getArgument(0) and
      frn.getARead() = m.getReceiver() and
      succ = frn.getARead()
    )
    or
    exists(DataFlow::MethodCallNode m, DataFlow::Variable frn |
      m.getTarget()
          .hasQualifiedName("github.com/valyala/fasthttp.Request",
            ["SetRequestURI", "SetRequestURIBytes", "SetURI"]) and
      pred = m.getArgument(0) and
      frn.getARead() = m.getReceiver() and
      succ = frn.getARead()
    )
  }
}

module Flow = TaintTracking::Global<Config>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink, DataFlow::Node request
where
  Flow::flowPath(source, sink) and
  request = sink.getNode()
select request, source, sink, "The URL of this request depends on a user-provided value."
