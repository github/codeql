/**
 * @name Weak HMAC secret key used to sign JWT (Json Web Tokens)
 * @description JWT requires a minimum of 32 bytes of full-entropy key to sign and verify
 *              JWT messages. Weak HMAC secrets are vulnerable to brute-force attacks.
 * @kind path-problem
 * @id java/weak-jwt-hmac-secret
 * @tags security
 *       external/cwe/cwe-326
 */

import java
import semmle.code.java.dataflow.TaintTracking
import experimental.semmle.code.java.frameworks.Jjwt
import experimental.semmle.code.java.frameworks.Jose4j
import DataFlow::PathGraph

/**
 * Weak HMAC key with a length shorter than 32 bytes or 43 characters in base64.
 */
class WeakSecretKey extends Expr {
  WeakSecretKey() { this.(CompileTimeConstantExpr).getStringValue().length() < 43 }
}

/**
 * A taint-tracking configuration for using a weak secret key in JWT signing.
 */
class InsecureJwtSigningFlowConfig extends TaintTracking::Configuration {
  InsecureJwtSigningFlowConfig() { this = "WeakJwtSecureKey:InsecureJwtSigningFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof WeakSecretKey }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      (
        ma.getMethod() instanceof SetSigningKeyMethod
        or
        ma.getMethod() instanceof SetJwtVerificationKey and
        exists(MethodAccess rma |
          rma.getMethod() instanceof SetRelaxJwtKeyValidation and
          (
            DataFlow::localExprFlow(ma, rma.getQualifier()) or
            DataFlow::localExprFlow(rma, ma.getQualifier())
          )
        )
      ) and
      sink.asExpr() = ma.getArgument(0)
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      ConstructorCall cc // new HmacKey(secretKeyString.getBytes("UTF-8"))
    |
      cc.getConstructedType().getASupertype*().hasQualifiedName("java.security", "Key") and
      pred.asExpr() = cc.getAnArgument() and
      succ.asExpr() = cc
    )
    or
    exists(
      MethodAccess ma // md.digest(secretKeyString.getBytes())
    |
      ma.getMethod()
          .getDeclaringType()
          .getASupertype*()
          .hasQualifiedName("java.security", "MessageDigest") and
      pred.asExpr() = ma.getArgument(0) and
      succ.asExpr() = ma
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, InsecureJwtSigningFlowConfig config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Insecure JWT signing configuration with $@.",
  source.getNode(), "weak HMAC Key"
