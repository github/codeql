/**
 * @name Weak encryption: Insufficient key size
 * @description Finds uses of encryption algorithms with too small a key size
 * @kind problem
 * @id java/insufficient-key-size
 * @tags security
 *       external/cwe/cwe-326
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking

/** The Java class `javax.crypto.KeyGenerator`. */
class KeyGenerator extends RefType {
  KeyGenerator() { this.hasQualifiedName("javax.crypto", "KeyGenerator") }
}

/** The Java class `javax.crypto.KeyGenerator`. */
class KeyPairGenerator extends RefType {
  KeyPairGenerator() { this.hasQualifiedName("java.security", "KeyPairGenerator") }
}

/** The Java class `java.security.spec.ECGenParameterSpec`. */
class ECGenParameterSpec extends RefType {
  ECGenParameterSpec() { this.hasQualifiedName("java.security.spec", "ECGenParameterSpec") }
}

/** The `init` method declared in `javax.crypto.KeyGenerator`. */
class KeyGeneratorInitMethod extends Method {
  KeyGeneratorInitMethod() {
    getDeclaringType() instanceof KeyGenerator and
    hasName("init")
  }
}

/** The `initialize` method declared in `java.security.KeyPairGenerator`. */
class KeyPairGeneratorInitMethod extends Method {
  KeyPairGeneratorInitMethod() {
    getDeclaringType() instanceof KeyPairGenerator and
    hasName("initialize")
  }
}

/** Taint configuration tracking flow from a key generator to a `init` method call. */
class CryptoKeyGeneratorConfiguration extends TaintTracking::Configuration {
  CryptoKeyGeneratorConfiguration() { this = "CryptoKeyGeneratorConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(JavaxCryptoKeyGenerator jcg | jcg = source.asExpr())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyGeneratorInitMethod and
      sink.asExpr() = ma.getQualifier()
    )
  }
}

/** Taint configuration tracking flow from a keypair generator to a `initialize` method call. */
class KeyPairGeneratorConfiguration extends TaintTracking::Configuration {
  KeyPairGeneratorConfiguration() { this = "KeyPairGeneratorConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(JavaSecurityKeyPairGenerator jkg | jkg = source.asExpr())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      sink.asExpr() = ma.getQualifier()
    )
  }
}

/** Holds if an AES `KeyGenerator` is initialized with an insufficient key size. */
predicate incorrectUseOfAES(MethodAccess ma, string msg) {
  ma.getMethod() instanceof KeyGeneratorInitMethod and
  exists(
    JavaxCryptoKeyGenerator jcg, CryptoKeyGeneratorConfiguration cc, DataFlow::PathNode source,
    DataFlow::PathNode dest
  |
    jcg.getAlgoSpec().(StringLiteral).getValue() = "AES" and
    source.getNode().asExpr() = jcg and
    dest.getNode().asExpr() = ma.getQualifier() and
    cc.hasFlowPath(source, dest)
  ) and
  ma.getArgument(0).(IntegerLiteral).getIntValue() < 128 and
  msg = "Key size should be at least 128 bits for AES encryption."
}

/** Holds if a DSA `KeyPairGenerator` is initialized with an insufficient key size. */
predicate incorrectUseOfDSA(MethodAccess ma, string msg) {
  ma.getMethod() instanceof KeyPairGeneratorInitMethod and
  exists(
    JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorConfiguration kc, DataFlow::PathNode source,
    DataFlow::PathNode dest
  |
    jpg.getAlgoSpec().(StringLiteral).getValue() = "DSA" and
    source.getNode().asExpr() = jpg and
    dest.getNode().asExpr() = ma.getQualifier() and
    kc.hasFlowPath(source, dest)
  ) and
  ma.getArgument(0).(IntegerLiteral).getIntValue() < 2048 and
  msg = "Key size should be at least 2048 bits for DSA encryption."
}

/** Holds if a RSA `KeyPairGenerator` is initialized with an insufficient key size. */
predicate incorrectUseOfRSA(MethodAccess ma, string msg) {
  ma.getMethod() instanceof KeyPairGeneratorInitMethod and
  exists(
    JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorConfiguration kc, DataFlow::PathNode source,
    DataFlow::PathNode dest
  |
    jpg.getAlgoSpec().(StringLiteral).getValue() = "RSA" and
    source.getNode().asExpr() = jpg and
    dest.getNode().asExpr() = ma.getQualifier() and
    kc.hasFlowPath(source, dest)
  ) and
  ma.getArgument(0).(IntegerLiteral).getIntValue() < 2048 and
  msg = "Key size should be at least 2048 bits for RSA encryption."
}

/** Holds if an EC `KeyPairGenerator` is initialized with an insufficient key size. */
predicate incorrectUseOfEC(MethodAccess ma, string msg) {
  ma.getMethod() instanceof KeyPairGeneratorInitMethod and
  exists(
    JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorConfiguration kc, DataFlow::PathNode source,
    DataFlow::PathNode dest, ClassInstanceExpr cie
  |
    jpg.getAlgoSpec().(StringLiteral).getValue().matches("EC%") and //ECC variants such as ECDH and ECDSA
    source.getNode().asExpr() = jpg and
    dest.getNode().asExpr() = ma.getQualifier() and
    kc.hasFlowPath(source, dest) and
    exists(VariableAssign va |
      ma.getArgument(0).(VarAccess).getVariable() = va.getDestVar() and
      va.getSource() = cie and
      cie.getArgument(0)
          .(StringLiteral)
          .getRepresentedString()
          .regexpCapture(".*[a-zA-Z]+([0-9]+)[a-zA-Z]+.*", 1)
          .toInt() < 224
    )
  ) and
  msg = "Key size should be at least 224 bits for EC encryption."
}

from Expr e, string msg
where
  incorrectUseOfAES(e, msg) or
  incorrectUseOfDSA(e, msg) or
  incorrectUseOfRSA(e, msg) or
  incorrectUseOfEC(e, msg)
select e, msg
