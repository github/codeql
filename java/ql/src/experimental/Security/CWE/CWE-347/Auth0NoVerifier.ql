/**
 * @name Missing JWT signature check
 * @description Failing to check the Json Web Token (JWT) signature may allow an attacker to forge their own tokens.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id java/missing-jwt-signature-check-auth0
 * @tags security
 *       external/cwe/cwe-347
 */

import java
import semmle.code.java.dataflow.FlowSources
import JwtAuth0 as JwtAuth0

module JwtDecodeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not FlowToJwtVerify::flow(source, _)
  }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(JwtAuth0::GetPayload a) }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Decode Should be one of the middle nodes
    exists(JwtAuth0::Decode a |
      nodeFrom.asExpr() = a.getArgument(0) and
      nodeTo.asExpr() = a
    )
    or
    exists(JwtAuth0::Verify a |
      nodeFrom.asExpr() = a.getArgument(0) and
      nodeTo.asExpr() = a
    )
    or
    exists(JwtAuth0::GetPayload a |
      nodeFrom.asExpr() = a.getQualifier() and
      nodeTo.asExpr() = a
    )
  }
}

module FlowToJwtVerifyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(JwtAuth0::Verify a).getArgument(0) }
}

module JwtDecode = TaintTracking::Global<JwtDecodeConfig>;

module FlowToJwtVerify = TaintTracking::Global<FlowToJwtVerifyConfig>;

import JwtDecode::PathGraph

from JwtDecode::PathNode source, JwtDecode::PathNode sink
where JwtDecode::flowPath(source, sink)
select sink.getNode(), source, sink, "This parses a $@, but the signature is not verified.",
  source.getNode(), "JWT"
