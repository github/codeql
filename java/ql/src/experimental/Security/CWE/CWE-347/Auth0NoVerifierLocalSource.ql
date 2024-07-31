/**
 * @name Missing JWT signature check
 * @description Failing to check the Json Web Token (JWT) signature may allow an attacker to forge their own tokens.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id java/missing-jwt-signature-check-auth0-local-source
 * @tags security
 *       external/cwe/cwe-347
 */

import java
import semmle.code.java.dataflow.FlowSources

module JwtAuth0 {
  class PayloadType extends RefType {
    PayloadType() { this.hasQualifiedName("com.auth0.jwt.interfaces", "Payload") }
  }

  class JwtType extends RefType {
    JwtType() { this.hasQualifiedName("com.auth0.jwt", "JWT") }
  }

  class JwtVerifierType extends RefType {
    JwtVerifierType() { this.hasQualifiedName("com.auth0.jwt", "JWTVerifier") }
  }

  /**
   * A Method that returns a Decoded Claim of JWT
   */
  class GetPayload extends MethodCall {
    GetPayload() {
      this.getCallee().getDeclaringType() instanceof PayloadType and
      this.getCallee().hasName(["getClaim", "getIssuedAt"])
    }
  }

  /**
   * A Method that Decode JWT without signature verification
   */
  class Decode extends MethodCall {
    Decode() {
      this.getCallee().getDeclaringType() instanceof JwtType and
      this.getCallee().hasName("decode")
    }
  }

  /**
   * A Method that Decode JWT with signature verification
   */
  class Verify extends MethodCall {
    Verify() {
      this.getCallee().getDeclaringType() instanceof JwtVerifierType and
      this.getCallee().hasName("verify")
    }
  }
}

module JwtDecodeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
   
    exists(Variable v |
      source.asExpr() = v.getInitializer() and
      v.getType().hasName("String")
    ) and
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
  predicate isSource(DataFlow::Node source) { 
    exists(Variable v |
      source.asExpr() = v.getInitializer() and
      v.getType().hasName("String")
    ) 
  }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(JwtAuth0::Verify a).getArgument(0) }
}

module JwtDecode = TaintTracking::Global<JwtDecodeConfig>;

module FlowToJwtVerify = TaintTracking::Global<FlowToJwtVerifyConfig>;

import JwtDecode::PathGraph

from JwtDecode::PathNode source, JwtDecode::PathNode sink
where JwtDecode::flowPath(source, sink)
select sink.getNode(), source, sink, "This parses a $@, but the signature is not verified.",
  source.getNode(), "JWT"
