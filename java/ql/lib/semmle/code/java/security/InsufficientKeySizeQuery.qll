import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow

//import DataFlow::PathGraph
/**
 * Asymmetric (RSA, DSA, DH) key length data flow tracking configuration.
 */
class AsymmetricKeyTrackingConfiguration extends DataFlow::Configuration {
  AsymmetricKeyTrackingConfiguration() { this = "AsymmetricKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(IntegerLiteral integer, VarAccess var |
      integer.getIntValue() < 2048 and
      source.asExpr() = integer
      or
      var.getVariable().getInitializer().getUnderlyingExpr() instanceof IntegerLiteral and
      var.getVariable().getInitializer().getUnderlyingExpr().toString().toInt() < 2048 and
      source.asExpr() = var.getVariable().getInitializer()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}

/** The Java class `java.security.spec.ECGenParameterSpec`. */
private class ECGenParameterSpec extends RefType {
  ECGenParameterSpec() { this.hasQualifiedName("java.security.spec", "ECGenParameterSpec") }
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

/** Taint configuration tracking flow from a key generator to a `init` method call. */
private class KeyGeneratorInitConfiguration extends TaintTracking::Configuration {
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
 * Taint configuration tracking flow from a keypair generator to
 * an `initialize` method call.
 */
private class KeyPairGeneratorInitConfiguration extends TaintTracking::Configuration {
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
  // flow needed to correctly determine algorithm type and
  // not match to ANY symmetric algorithm (although doesn't really matter since only have AES currently...)
  exists(
    JavaxCryptoKeyGenerator jcg, KeyGeneratorInitConfiguration cc, DataFlow::PathNode source,
    DataFlow::PathNode dest
  |
    jcg.getAlgoSpec().(StringLiteral).getValue() = type and
    source.getNode().asExpr() = jcg and
    dest.getNode().asExpr() = ma.getQualifier() and
    cc.hasFlowPath(source, dest)
  ) and
  (
    // VarAccess case needed to handle FN of key-size stored in a variable
    // Note: cannot use CompileTimeConstantExpr since will miss cases when variable is not a compile-time constant
    // (e.g. not declared `final` in Java)
    exists(VarAccess var |
      var.getVariable().getInitializer().getUnderlyingExpr() instanceof IntegerLiteral and
      var.getVariable().getInitializer().getUnderlyingExpr().toString().toInt() < 128 and
      ma.getArgument(0) = var
    )
    or
    // exists(CompileTimeConstantExpr var |
    //   //var.getUnderlyingExpr() instanceof IntegerLiteral and // can't include this...
    //   var.getIntValue() < 128 and
    //   ma.getArgument(0) = var
    // )
    // or
    ma.getArgument(0).(IntegerLiteral).getIntValue() < 128
  ) and
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
private predicate hasShortAsymmetricKeyPair(MethodAccess ma, string msg, string type) {
  ma.getMethod() instanceof KeyPairGeneratorInitMethod and
  ma.getQualifier() instanceof JavaSecurityKeyPairGenerator and
  ma.getQualifier().getBasicBlock() instanceof JavaSecurityKeyPairGenerator and
  //ma.getQualifier().getBasicBlock().getNode(2) instanceof JavaSecurityKeyPairGenerator and
  // ma.getQualifier()
  //     .getBasicBlock()
  //     .getANode()
  //     .(JavaSecurityKeyPairGenerator)
  //     .getAlgoSpec()
  //     .(StringLiteral)
  //     .getValue()
  //     .toUpperCase() = type and
  //ma.getQualifier().getBasicBlock().getAPredecessor() instanceof JavaSecurityKeyPairGenerator and
  ma.getQualifier()
      .getBasicBlock()
      .getAPredecessor()
      .(JavaSecurityKeyPairGenerator)
      .getAlgoSpec()
      .(StringLiteral)
      .getValue()
      .toUpperCase() = type and
  // flow needed to correctly determine algorithm type and
  // not match to ANY asymmetric algorithm
  exists(
    JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorInitConfiguration kc,
    DataFlow::PathNode source, DataFlow::PathNode dest
  |
    jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase() = type and
    source.getNode().asExpr() = jpg and
    dest.getNode().asExpr() = ma.getQualifier() and
    kc.hasFlowPath(source, dest)
  ) and
  // VarAccess case needed to handle FN of key-size stored in a variable
  // Note: cannot use CompileTimeConstantExpr since will miss cases when variable is not a compile-time constant
  // (e.g. not declared `final` in Java)
  (
    exists(VarAccess var |
      var.getVariable().getInitializer().getUnderlyingExpr() instanceof IntegerLiteral and
      var.getVariable().getInitializer().getUnderlyingExpr().toString().toInt() < 2048 and
      ma.getArgument(0) = var
    )
    or
    ma.getArgument(0).(IntegerLiteral).getIntValue() < 2048
    or
    exists(
      AsymmetricKeyTrackingConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
    |
      cfg.hasFlowPath(source, sink)
    )
  ) and
  msg = "Key size should be at least 2048 bits for " + type + " encryption."
}

/**
 * Holds if a DSA `KeyPairGenerator` initialized by `ma` uses an insufficient key size.
 *
 * `msg` provides a human-readable description of the problem.
 */
private predicate hasShortDsaKeyPair(MethodAccess ma, string msg) {
  hasShortAsymmetricKeyPair(ma, msg, "DSA") or
  hasShortAsymmetricKeyPair(ma, msg, "DH")
}

/**
 * Holds if a RSA `KeyPairGenerator` initialized by `ma` uses an insufficient key size.
 *
 * `msg` provides a human-readable description of the problem.
 */
private predicate hasShortRsaKeyPair(MethodAccess ma, string msg) {
  hasShortAsymmetricKeyPair(ma, msg, "RSA")
}

/**
 * Holds if an EC `KeyPairGenerator` initialized by `ma` uses an insufficient key size.
 *
 * `msg` provides a human-readable description of the problem.
 */
private predicate hasShortECKeyPair(MethodAccess ma, string msg) {
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

// ! refactor this so can use 'path-problem' select clause instead?
predicate hasInsufficientKeySize(Expr e, string msg) {
  hasShortAESKey(e, msg) or
  hasShortDsaKeyPair(e, msg) or
  hasShortRsaKeyPair(e, msg) or
  hasShortECKeyPair(e, msg)
}
