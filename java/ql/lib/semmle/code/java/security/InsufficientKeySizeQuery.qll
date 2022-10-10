import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow

// TODO:
// todo #1: make representation of source that can be shared across the configs
// todo #2: make representation of sink that can be shared across the configs
// todo #3: finish adding tracking for algo type/name... need flow/taint-tracking for across methods??
// todo #3a: make list of algo names more easily reusable (either as constant-type variable at top of file, or model as own class to share, etc.)
// ******* DATAFLOW BELOW *************************************************************************
/**
 * Asymmetric (RSA, DSA, DH) key length data flow tracking configuration.
 */
class AsymmetricKeyTrackingConfiguration extends TaintTracking2::Configuration {
  AsymmetricKeyTrackingConfiguration() { this = "AsymmetricKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(ClassInstanceExpr rsaGenParamSpec |
      rsaGenParamSpec.getConstructedType() instanceof RSAGenParameterSpec and // ! double-check if should just use getType() instead
      rsaGenParamSpec.getArgument(0).(IntegerLiteral).getIntValue() < 2048 and
      source.asExpr() = rsaGenParamSpec
    )
    or
    source.asExpr().(IntegerLiteral).getIntValue() < 2048
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, VarAccess va |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      //ma.getFile().getBaseName().matches("SignatureTest.java") and
      // va.getVariable()
      //     .getAnAssignedValue()
      //     .(JavaSecurityKeyPairGenerator)
      //     .getAlgoSpec()
      //     .(StringLiteral)
      //     .getValue()
      //     .toUpperCase()
      //     .matches(["RSA", "DSA", "DH"]) and
      // ma.getQualifier() = va and
      exists(
        JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorInitConfiguration kpgConfig,
        DataFlow::PathNode source, DataFlow::PathNode dest
      |
        jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches(["RSA", "DSA", "DH"]) and
        source.getNode().asExpr() = jpg and
        dest.getNode().asExpr() = ma.getQualifier() and
        kpgConfig.hasFlowPath(source, dest)
      ) and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}

// predicate hasInsufficientKeySize(string msg) { hasShortAsymmetricKeyPair(msg) }
// predicate hasShortAsymmetricKeyPair(string msg) {
//   exists(AsymmetricKeyTrackingConfiguration config1, DataFlow::Node source, DataFlow::Node sink |
//     config1.hasFlow(source, sink)
//   ) and
//   msg = "Key size should be at least 2048 bits for " + "___" + " encryption."
// }
/**
 * Asymmetric (EC) key length data flow tracking configuration.
 */
class AsymmetricECCKeyTrackingConfiguration extends TaintTracking2::Configuration {
  AsymmetricECCKeyTrackingConfiguration() { this = "AsymmetricECCKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(ClassInstanceExpr ecGenParamSpec |
      getECKeySize(ecGenParamSpec.getArgument(0).(StringLiteral).getValue()) < 256 and // ! can generate EC with just the keysize and not the curve apparently... (based on netty/netty FP example)
      source.asExpr() = ecGenParamSpec
    )
    or
    source.asExpr().(IntegerLiteral).getIntValue() < 256
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, VarAccess va |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      //ma.getArgument(0).getType() instanceof ECGenParameterSpec and // ! can generate EC with just the keysize and not the curve apparently... (based on netty/netty FP example)
      // va.getVariable()
      //     .getAnAssignedValue()
      //     .(JavaSecurityKeyPairGenerator)
      //     .getAlgoSpec()
      //     .(StringLiteral)
      //     .getValue()
      //     .toUpperCase()
      //     .matches(["EC%"]) and
      // ma.getQualifier() = va and
      exists(
        JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorInitConfiguration kpgConfig,
        DataFlow::PathNode source, DataFlow::PathNode dest
      |
        jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches("EC%") and
        source.getNode().asExpr() = jpg and
        dest.getNode().asExpr() = ma.getQualifier() and
        kpgConfig.hasFlowPath(source, dest)
      ) and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * Symmetric (AES) key length data flow tracking configuration.
 */
class SymmetricKeyTrackingConfiguration extends TaintTracking2::Configuration {
  SymmetricKeyTrackingConfiguration() { this = "SymmetricKeyTrackingConfiguration2" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(IntegerLiteral).getIntValue() < 128
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, VarAccess va |
      ma.getMethod() instanceof KeyGeneratorInitMethod and
      // va.getVariable()
      //     .getAnAssignedValue()
      //     .(JavaxCryptoKeyGenerator)
      //     .getAlgoSpec()
      //     .(StringLiteral)
      //     .getValue()
      //     .toUpperCase()
      //     .matches(["AES"]) and
      // ma.getQualifier() = va and
      exists(
        JavaxCryptoKeyGenerator jcg, KeyGeneratorInitConfiguration kgConfig,
        DataFlow::PathNode source, DataFlow::PathNode dest
      |
        jcg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches("AES") and
        source.getNode().asExpr() = jcg and
        dest.getNode().asExpr() = ma.getQualifier() and
        kgConfig.hasFlowPath(source, dest)
      ) and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}

// ! below doesn't work for some reason...
// predicate hasInsufficientKeySize2(DataFlow::PathNode source, DataFlow::PathNode sink) {
//   exists(AsymmetricKeyTrackingConfiguration config1 | config1.hasFlowPath(source, sink))
//   or
//   exists(SymmetricKeyTrackingConfiguration config2 | config2.hasFlowPath(source, sink))
// }
// ******** Need the below for the above ********
// ! move to Encryption.qll?
/** The Java class `java.security.spec.ECGenParameterSpec`. */
private class ECGenParameterSpec extends RefType {
  ECGenParameterSpec() { this.hasQualifiedName("java.security.spec", "ECGenParameterSpec") }
}

/** The Java class `java.security.spec.ECGenParameterSpec`. */
private class RSAGenParameterSpec extends RefType {
  RSAGenParameterSpec() { this.hasQualifiedName("java.security.spec", "RSAKeyGenParameterSpec") }
}

// ! move to Encryption.qll?
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

// ! move to Encryption.qll?
/** The `init` method declared in `javax.crypto.KeyGenerator`. */
private class KeyGeneratorInitMethod extends Method {
  KeyGeneratorInitMethod() {
    this.getDeclaringType() instanceof KeyGenerator and
    this.hasName("init")
  }
}

// ! move to Encryption.qll?
/** The `initialize` method declared in `java.security.KeyPairGenerator`. */
private class KeyPairGeneratorInitMethod extends Method {
  KeyPairGeneratorInitMethod() {
    this.getDeclaringType() instanceof KeyPairGenerator and
    this.hasName("initialize")
  }
}

// ******* DATAFLOW ABOVE *************************************************************************
// ************************************************************************************************
// ************************************************************************************************
// ************************************************************************************************
// ************************************************************************************************
// ************************************************************************************************
// ******* OLD/UNUSED OR EXPERIMENTAL CODE BELOW **************************************************
class UnsafeSymmetricKeySize extends IntegerLiteral {
  UnsafeSymmetricKeySize() { this.getIntValue() < 128 }
}

class UnsafeAsymmetricKeySize extends IntegerLiteral {
  UnsafeAsymmetricKeySize() { this.getIntValue() < 2048 }
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
