import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow

// ******* DATAFLOW BELOW *************************************************************************
/**
 * Asymmetric (RSA, DSA, DH) key length data flow tracking configuration.
 */
class AsymmetricKeyTrackingConfiguration extends DataFlow2::Configuration {
  AsymmetricKeyTrackingConfiguration() { this = "AsymmetricKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    // ! may need to change below to still use `keysize` variable as the source, not the spec
    // ! also need to look into specs for DSA and DH more
    exists(ClassInstanceExpr rsaGenParamSpec |
      rsaGenParamSpec.getConstructedType() instanceof RSAGenParameterSpec and
      rsaGenParamSpec.getArgument(0).(CompileTimeConstantExpr).getIntValue() < 2048 and
      source.asExpr() = rsaGenParamSpec
    )
    or
    source.asExpr().(IntegerLiteral).getIntValue() < 2048
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      exists(
        JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorInitConfiguration kpgConfig,
        DataFlow::PathNode source, DataFlow::PathNode dest
      |
        jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches(["RSA", "DSA", "DH"]) and
        source.getNode().asExpr() = jpg and
        dest.getNode().asExpr() = ma.getQualifier() and
        kpgConfig.hasFlowPath(source, dest)
      ) and
      sink.asExpr() = ma.getArgument(0) // ! todo: add spec as a sink
    )
  }
}

/**
 * Asymmetric (EC) key length data flow tracking configuration.
 */
class AsymmetricECCKeyTrackingConfiguration extends DataFlow2::Configuration {
  AsymmetricECCKeyTrackingConfiguration() { this = "AsymmetricECCKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    // ! may need to change below to still use `keysize` variable as the source, not the spec
    exists(ClassInstanceExpr ecGenParamSpec |
      getECKeySize(ecGenParamSpec.getArgument(0).(StringLiteral).getValue()) < 256 and
      source.asExpr() = ecGenParamSpec
    )
    or
    source.asExpr().(IntegerLiteral).getIntValue() < 256
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
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
class SymmetricKeyTrackingConfiguration extends DataFlow2::Configuration {
  SymmetricKeyTrackingConfiguration() { this = "SymmetricKeyTrackingConfiguration2" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(IntegerLiteral).getIntValue() < 128
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof KeyGeneratorInitMethod and
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

// ! below predicate doesn't work
// predicate hasInsufficientKeySize2(DataFlow::PathNode source, DataFlow::PathNode sink) {
//   exists(AsymmetricKeyTrackingConfiguration config1 | config1.hasFlowPath(source, sink))
//   or
//   exists(SymmetricKeyTrackingConfiguration config2 | config2.hasFlowPath(source, sink))
// }
// ******** Need the below models for the above configs ********
/** Taint configuration tracking flow from a key generator to a `init` method call. */
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
 * Taint configuration tracking flow from a keypair generator to
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

// ! move some/all of below to Encryption.qll or elsewhere?
/** The Java class `java.security.spec.ECGenParameterSpec`. */
private class ECGenParameterSpec extends RefType {
  ECGenParameterSpec() { this.hasQualifiedName("java.security.spec", "ECGenParameterSpec") }
}

/** The Java class `java.security.spec.ECGenParameterSpec`. */
private class RSAGenParameterSpec extends RefType {
  RSAGenParameterSpec() { this.hasQualifiedName("java.security.spec", "RSAKeyGenParameterSpec") }
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

// ******* DATAFLOW ABOVE *************************************************************************
// ************************************************************************************************
// ************************************************************************************************
// ******* OLD/UNUSED OR EXPERIMENTAL CODE BELOW **************************************************
class UnsafeSymmetricKeySize extends IntegerLiteral {
  UnsafeSymmetricKeySize() { this.getIntValue() < 128 }
}

class UnsafeAsymmetricKeySize extends IntegerLiteral {
  UnsafeAsymmetricKeySize() { this.getIntValue() < 2048 }
}
// TODO:
// ! todo #0a: find a better way to combine the two needed taint-tracking configs so can go back to having a path-graph...
// ! todo #0b: possible to combine the 3 dataflow configs?
// todo #1: make representation of source that can be shared across the configs
// todo #2: make representation of sink that can be shared across the configs
// todo #3: make list of algo names more easily reusable (either as constant-type variable at top of file, or model as own class to share, etc.)
// todo #4: refactor to be more like the Python version? (or not possible because of lack of DataFlow::Node for void method in Java?)
