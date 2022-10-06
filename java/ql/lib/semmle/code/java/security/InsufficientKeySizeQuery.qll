import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow

// ******* DATAFLOW BELOW *************************************************************************
/**
 * Asymmetric (RSA, DSA, DH) key length data flow tracking configuration.
 */
class AsymmetricKeyTrackingConfiguration extends DataFlow::Configuration {
  AsymmetricKeyTrackingConfiguration() { this = "AsymmetricKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof IntegerLiteral and // ! this works with current test cases, but reconsider IntegerLiteral when variables are used
    source.toString().toInt() < 2048
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * Asymmetric (RSA, DSA, DH) key length data flow tracking configuration.
 */
class AsymmetricECCKeyTrackingConfiguration extends DataFlow::Configuration {
  AsymmetricECCKeyTrackingConfiguration() { this = "AsymmetricECCKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(ClassInstanceExpr ecGenParamSpec |
      getECKeySize(ecGenParamSpec.getArgument(0).(StringLiteral).getValue()) < 256 and
      source.asExpr() = ecGenParamSpec
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      ma.getArgument(0).getType() instanceof ECGenParameterSpec and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * Symmetric (AES) key length data flow tracking configuration.
 */
class SymmetricKeyTrackingConfiguration extends DataFlow::Configuration {
  SymmetricKeyTrackingConfiguration() { this = "SymmetricKeyTrackingConfiguration2" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof IntegerLiteral and // ! this works with current test cases, but reconsider IntegerLiteral when variables are used
    source.toString().toInt() < 128
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyGeneratorInitMethod and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}

// ! below doesn't work for some reason...
predicate hasInsufficientKeySize2(DataFlow::PathNode source, DataFlow::PathNode sink) {
  exists(AsymmetricKeyTrackingConfiguration config1 | config1.hasFlowPath(source, sink))
  or
  exists(SymmetricKeyTrackingConfiguration config2 | config2.hasFlowPath(source, sink))
}

// ******** Need the below for the above ********
// ! move to Encryption.qll?
/** The Java class `java.security.spec.ECGenParameterSpec`. */
private class ECGenParameterSpec extends RefType {
  ECGenParameterSpec() { this.hasQualifiedName("java.security.spec", "ECGenParameterSpec") }
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
