/**
 * @name Weak encryption: Insufficient key size
 * @description Finds uses of encryption algorithms with too small a key size
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/insufficient-key-size
 * @tags security
 *       external/cwe/cwe-326
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking

/** The Java class `java.security.spec.ECGenParameterSpec`. */
class ECGenParameterSpec extends RefType {
  ECGenParameterSpec() { this.hasQualifiedName("java.security.spec", "ECGenParameterSpec") }
}

/** The `init` method declared in `javax.crypto.KeyGenerator`. */
class KeyGeneratorInitMethod extends Method {
  KeyGeneratorInitMethod() {
    this.getDeclaringType() instanceof KeyGenerator and
    this.hasName("init")
  }
}

/** The `initialize` method declared in `java.security.KeyPairGenerator`. */
class KeyPairGeneratorInitMethod extends Method {
  KeyPairGeneratorInitMethod() {
    this.getDeclaringType() instanceof KeyPairGenerator and
    this.hasName("initialize")
  }
}

/** Returns the key size in the EC algorithm string */
bindingset[algorithm]
int getECKeySize(string algorithm) {
  algorithm.matches("sec%") and // specification such as "secp256r1"
  result = algorithm.regexpCapture("sec[p|t](\\d+)[a-zA-Z].*", 1).toInt()
  or
  algorithm.matches("X9.62%") and //specification such as "X9.62 prime192v2"
  result = algorithm.regexpCapture("X9\\.62 .*[a-zA-Z](\\d+)[a-zA-Z].*", 1).toInt()
  or
  (algorithm.matches("prime%") or algorithm.matches("c2tnb%")) and //specification such as "prime192v2"
  result = algorithm.regexpCapture(".*[a-zA-Z](\\d+)[a-zA-Z].*", 1).toInt()
}

/** Taint configuration tracking flow from a key generator to a `init` method call. */
class KeyGeneratorInitConfiguration extends TaintTracking::Configuration {
  KeyGeneratorInitConfiguration() { this = "KeyGeneratorInitConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof JavaxCryptoKeyGenerator
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyGeneratorInitMethod and
      sink.asExpr() = ma.getQualifier()
    )
  }
}

/** Taint configuration tracking flow from a keypair generator to a `initialize` method call. */
class KeyPairGeneratorInitConfiguration extends TaintTracking::Configuration {
  KeyPairGeneratorInitConfiguration() { this = "KeyPairGeneratorInitConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof JavaSecurityKeyPairGenerator
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      sink.asExpr() = ma.getQualifier()
    )
  }
}

/** Holds if a symmetric `KeyGenerator` implementing encryption algorithm `type` and initialized by `ma` uses an insufficient key size. `msg` provides a human-readable description of the problem. */
bindingset[type]
predicate hasShortSymmetricKey(MethodAccess ma, string msg, string type) {
  ma.getMethod() instanceof KeyGeneratorInitMethod and
  exists(
    JavaxCryptoKeyGenerator jcg, KeyGeneratorInitConfiguration cc, DataFlow::PathNode source,
    DataFlow::PathNode dest
  |
    jcg.getAlgoSpec().(StringLiteral).getValue() = type and
    source.getNode().asExpr() = jcg and
    dest.getNode().asExpr() = ma.getQualifier() and
    cc.hasFlowPath(source, dest)
  ) and
  ma.getArgument(0).(IntegerLiteral).getIntValue() < 128 and
  msg = "Key size should be at least 128 bits for " + type + " encryption."
}

/** Holds if an AES `KeyGenerator` initialized by `ma` uses an insufficient key size. `msg` provides a human-readable description of the problem. */
predicate hasShortAESKey(MethodAccess ma, string msg) { hasShortSymmetricKey(ma, msg, "AES") }

/** Holds if an asymmetric `KeyPairGenerator` implementing encryption algorithm `type` and initialized by `ma` uses an insufficient key size. `msg` provides a human-readable description of the problem. */
bindingset[type]
predicate hasShortAsymmetricKeyPair(MethodAccess ma, string msg, string type) {
  ma.getMethod() instanceof KeyPairGeneratorInitMethod and
  exists(
    JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorInitConfiguration kc,
    DataFlow::PathNode source, DataFlow::PathNode dest
  |
    jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase() = type and
    source.getNode().asExpr() = jpg and
    dest.getNode().asExpr() = ma.getQualifier() and
    kc.hasFlowPath(source, dest)
  ) and
  ma.getArgument(0).(IntegerLiteral).getIntValue() < 2048 and
  msg = "Key size should be at least 2048 bits for " + type + " encryption."
}

/** Holds if a DSA `KeyPairGenerator` initialized by `ma` uses an insufficient key size. `msg` provides a human-readable description of the problem. */
predicate hasShortDSAKeyPair(MethodAccess ma, string msg) {
  hasShortAsymmetricKeyPair(ma, msg, "DSA") or hasShortAsymmetricKeyPair(ma, msg, "DH")
}

/** Holds if a RSA `KeyPairGenerator` initialized by `ma` uses an insufficient key size. `msg` provides a human-readable description of the problem. */
predicate hasShortRSAKeyPair(MethodAccess ma, string msg) {
  hasShortAsymmetricKeyPair(ma, msg, "RSA")
}

/** Holds if an EC `KeyPairGenerator` initialized by `ma` uses an insufficient key size. `msg` provides a human-readable description of the problem. */
predicate hasShortECKeyPair(MethodAccess ma, string msg) {
  ma.getMethod() instanceof KeyPairGeneratorInitMethod and
  exists(
    JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorInitConfiguration kc,
    DataFlow::PathNode source, DataFlow::PathNode dest, ClassInstanceExpr cie
  |
    jpg.getAlgoSpec().(StringLiteral).getValue().matches("EC%") and // ECC variants such as ECDH and ECDSA
    source.getNode().asExpr() = jpg and
    dest.getNode().asExpr() = ma.getQualifier() and
    kc.hasFlowPath(source, dest) and
    DataFlow::localExprFlow(cie, ma.getArgument(0)) and
    ma.getArgument(0).getType() instanceof ECGenParameterSpec and
    getECKeySize(cie.getArgument(0).(StringLiteral).getValue()) < 256
  ) and
  msg = "Key size should be at least 256 bits for EC encryption."
}

from Expr e, string msg
where
  hasShortAESKey(e, msg) or
  hasShortDSAKeyPair(e, msg) or
  hasShortRSAKeyPair(e, msg) or
  hasShortECKeyPair(e, msg)
select e, msg
