/** Provides classes and predicates related to insufficient key sizes in Java. */

import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking

/** The Java class `java.security.spec.ECGenParameterSpec`. */
private class EcGenParameterSpec extends RefType {
  EcGenParameterSpec() { this.hasQualifiedName("java.security.spec", "ECGenParameterSpec") }
}

/** The Java class `java.security.spec.RSAKeyGenParameterSpec`. */
private class RsaKeyGenParameterSpec extends RefType {
  RsaKeyGenParameterSpec() { this.hasQualifiedName("java.security.spec", "RSAKeyGenParameterSpec") }
}

/** The Java class `java.security.spec.DSAGenParameterSpec`. */
private class DsaGenParameterSpec extends RefType {
  DsaGenParameterSpec() { this.hasQualifiedName("java.security.spec", "DSAGenParameterSpec") }
}

/** The Java class `javax.crypto.spec.DHGenParameterSpec`. */
private class DhGenParameterSpec extends RefType {
  DhGenParameterSpec() { this.hasQualifiedName("javax.crypto.spec", "DHGenParameterSpec") }
}

/** The `init` method declared in `javax.crypto.KeyGenerator`. */
private class KeyGeneratorInitMethod extends Method {
  KeyGeneratorInitMethod() {
    this.getDeclaringType() instanceof KeyGenerator and
    this.hasName("init")
  }
}

/** The `initialize` method declared in `java.security.KeyPairGenerator`. */
private class KeyPairGeneratorInitMethod extends Method {
  KeyPairGeneratorInitMethod() {
    this.getDeclaringType() instanceof KeyPairGenerator and
    this.hasName("initialize")
  }
}

/** Returns the key size in the EC algorithm string */
bindingset[algorithm]
private int getECKeySize(string algorithm) {
  algorithm.matches("sec%") and // specification such as "secp256r1"
  result = algorithm.regexpCapture("sec[p|t](\\d+)[a-zA-Z].*", 1).toInt()
  or
  algorithm.matches("X9.62%") and //specification such as "X9.62 prime192v2"
  result = algorithm.regexpCapture("X9\\.62 .*[a-zA-Z](\\d+)[a-zA-Z].*", 1).toInt()
  or
  (algorithm.matches("prime%") or algorithm.matches("c2tnb%")) and //specification such as "prime192v2"
  result = algorithm.regexpCapture(".*[a-zA-Z](\\d+)[a-zA-Z].*", 1).toInt()
}

/** Data flow configuration tracking flow from a key generator to a `init` method call. */
private class KeyGeneratorInitConfiguration extends DataFlow::Configuration {
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

/**
 * Data flow  configuration tracking flow from a keypair generator to
 * an `initialize` method call.
 */
private class KeyPairGeneratorInitConfiguration extends DataFlow::Configuration {
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

/**
 * Holds if a symmetric `KeyGenerator` implementing encryption algorithm
 * `type` and initialized by `ma` uses an insufficient key size.
 *
 * `msg` provides a human-readable description of the problem.
 */
bindingset[type]
private predicate hasShortSymmetricKey(MethodAccess ma, string msg, string type) {
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
  ma.getArgument(0).(CompileTimeConstantExpr).getIntValue() < 128 and
  msg = "Key size should be at least 128 bits for " + type + " encryption."
}

/**
 * Holds if an AES `KeyGenerator` initialized by `ma` uses an insufficient key size.
 * `msg` provides a human-readable description of the problem.
 */
private predicate hasShortAESKey(MethodAccess ma, string msg) {
  hasShortSymmetricKey(ma, msg, "AES")
}

/**
 * Holds if an asymmetric `KeyPairGenerator` implementing encryption algorithm
 * `type` and initialized by `ma` uses an insufficient key size.
 *
 * `msg` provides a human-readable description of the problem.
 */
bindingset[type]
private predicate hasShortAsymmetricKeyPair(Expr e, string msg, string type) {
  (
    exists(
      JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorInitConfiguration kc,
      DataFlow::PathNode source, DataFlow::PathNode dest, MethodAccess ma
    |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase() = type and
      source.getNode().asExpr() = jpg and
      dest.getNode().asExpr() = ma.getQualifier() and
      kc.hasFlowPath(source, dest) and
      ma.getArgument(0).(CompileTimeConstantExpr).getIntValue() < 2048 and
      ma = e
    )
    or
    exists(ClassInstanceExpr genParamSpec |
      (
        genParamSpec.getConstructedType() instanceof RsaKeyGenParameterSpec or
        genParamSpec.getConstructedType() instanceof DsaGenParameterSpec or
        genParamSpec.getConstructedType() instanceof DhGenParameterSpec
      ) and
      genParamSpec.getArgument(0).(CompileTimeConstantExpr).getIntValue() < 2048 and
      genParamSpec = e
    )
  ) and
  msg = "Key size should be at least 2048 bits for " + type + " encryption."
}

/**
 * Holds if a DSA `KeyPairGenerator` initialized by `ma` uses an insufficient key size.
 *
 * `msg` provides a human-readable description of the problem.
 */
private predicate hasShortDsaKeyPair(Expr e, string msg) {
  hasShortAsymmetricKeyPair(e, msg, "DSA") or
  hasShortAsymmetricKeyPair(e, msg, "DH")
}

/**
 * Holds if a RSA `KeyPairGenerator` initialized by `ma` uses an insufficient key size.
 *
 * `msg` provides a human-readable description of the problem.
 */
private predicate hasShortRsaKeyPair(Expr e, string msg) {
  hasShortAsymmetricKeyPair(e, msg, "RSA")
}

/**
 * Holds if an EC `KeyPairGenerator` initialized by `ma` uses an insufficient key size.
 *
 * `msg` provides a human-readable description of the problem.
 */
private predicate hasShortECKeyPair(Expr e, string msg) {
  (
    exists(
      JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorInitConfiguration kc,
      DataFlow::PathNode source, DataFlow::PathNode dest, MethodAccess ma
    |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      jpg.getAlgoSpec().(StringLiteral).getValue().matches("EC%") and // ECC variants such as ECDH and ECDSA
      source.getNode().asExpr() = jpg and
      dest.getNode().asExpr() = ma.getQualifier() and
      kc.hasFlowPath(source, dest) and
      ma.getArgument(0).(CompileTimeConstantExpr).getIntValue() < 256 and
      ma = e
    )
    or
    // don't need KeyPairGeneratorInitConfiguration in the below since
    // know the algo from the spec.
    exists(ClassInstanceExpr ecGenParamSpec |
      ecGenParamSpec.getConstructedType() instanceof EcGenParameterSpec and
      getECKeySize(ecGenParamSpec.getArgument(0).(StringLiteral).getValue()) < 256 and
      ecGenParamSpec = e
    )
  ) and
  msg = "Key size should be at least 256 bits for EC encryption."
}

/** Holds if an insufficient key size is used. */
predicate hasInsufficientKeySize(Expr e, string msg) {
  hasShortAESKey(e, msg) or
  hasShortDsaKeyPair(e, msg) or
  hasShortRsaKeyPair(e, msg) or
  hasShortECKeyPair(e, msg)
}
