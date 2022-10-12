/** Provides classes and predicates related to insufficient key sizes in Java. */

import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking

//import semmle.code.java.dataflow.internal.DataFlowImplCommonPublic
//import semmle.code.java.dataflow.FlowSources
//import semmle.code.java.dataflow.internal.DataFlowNodes
/**
 * A key length data flow tracking configuration.
 */
class KeyTrackingConfiguration extends DataFlow::Configuration {
  KeyTrackingConfiguration() { this = "KeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    //state instanceof DataFlow::FlowStateEmpty and
    // SYMMETRIC
    source.asExpr().(IntegerLiteral).getIntValue() < 128 and state = "128"
    or
    // ASYMMETRIC
    source.asExpr().(IntegerLiteral).getIntValue() < 2048 and state = "2048"
    or
    source.asExpr().(IntegerLiteral).getIntValue() < 256 and state = "256"
    or
    getECKeySize(source.asExpr().(StringLiteral).getValue()) < 256 and state = "256" // need this for the cases when the key size is embedded in the curve name.
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    // SYMMETRIC
    exists(MethodAccess ma, JavaxCryptoKeyGenerator jcg |
      ma.getMethod() instanceof KeyGeneratorInitMethod and
      jcg.getAlgoSpec().(StringLiteral).getValue().toUpperCase() = "AES" and
      DataFlow::localExprFlow(jcg, ma.getQualifier()) and
      sink.asExpr() = ma.getArgument(0) and
      state = "128"
    )
    or
    // ASYMMETRIC
    exists(MethodAccess ma, JavaSecurityKeyPairGenerator jpg |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      (
        jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches(["RSA", "DSA", "DH"]) and
        DataFlow::localExprFlow(jpg, ma.getQualifier()) and
        sink.asExpr() = ma.getArgument(0) and
        //ma.getArgument(0).(LocalSourceNode).flowsTo(sink) and
        //ma.getArgument(0).(CompileTimeConstantExpr).getIntValue() < 2048 and
        state = "2048"
      )
      or
      jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches("EC%") and
      DataFlow::localExprFlow(jpg, ma.getQualifier()) and
      sink.asExpr() = ma.getArgument(0) and
      //ma.getArgument(0).(CompileTimeConstantExpr).getIntValue() < 256 and
      state = "256"
    )
    or
    // TODO: combine below three for less duplicated code
    exists(ClassInstanceExpr rsaKeyGenParamSpec |
      rsaKeyGenParamSpec.getConstructedType() instanceof RsaKeyGenParameterSpec and
      sink.asExpr() = rsaKeyGenParamSpec.getArgument(0) and
      state = "2048"
    )
    or
    exists(ClassInstanceExpr dsaGenParamSpec |
      dsaGenParamSpec.getConstructedType() instanceof DsaGenParameterSpec and
      sink.asExpr() = dsaGenParamSpec.getArgument(0) and
      state = "2048"
    )
    or
    exists(ClassInstanceExpr dhGenParamSpec |
      dhGenParamSpec.getConstructedType() instanceof DhGenParameterSpec and
      sink.asExpr() = dhGenParamSpec.getArgument(0) and
      state = "2048"
    )
    or
    exists(ClassInstanceExpr ecGenParamSpec |
      ecGenParamSpec.getConstructedType() instanceof EcGenParameterSpec and
      sink.asExpr() = ecGenParamSpec.getArgument(0) and
      state = "256"
    )
  }

  // ! FlowStates seem to work without even including a step like the below... hmmm
  override predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(IntegerLiteral intLiteral |
      state1 = "" and
      state2 = intLiteral.toString() and
      node1.asExpr() = intLiteral and
      node2.asExpr() = intLiteral
    )
  }
}

/**
 * An Asymmetric (RSA, DSA, DH) key length data flow tracking configuration.
 */
class AsymmetricNonECKeyTrackingConfiguration extends DataFlow::Configuration {
  AsymmetricNonECKeyTrackingConfiguration() { this = "AsymmetricNonECKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(IntegerLiteral).getIntValue() < 2048
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, JavaSecurityKeyPairGenerator jpg |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches(["RSA", "DSA", "DH"]) and
      DataFlow::localExprFlow(jpg, ma.getQualifier()) and
      // exists(
      //   JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorInitConfiguration kpgConfig,
      //   DataFlow::PathNode source, DataFlow::PathNode dest
      // |
      //   jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches(["RSA", "DSA", "DH"]) and
      //   source.getNode().asExpr() = jpg and
      //   dest.getNode().asExpr() = ma.getQualifier() and
      //   kpgConfig.hasFlowPath(source, dest)
      // ) and
      sink.asExpr() = ma.getArgument(0)
    )
    or
    // TODO: combine below three for less duplicated code
    exists(ClassInstanceExpr rsaKeyGenParamSpec |
      rsaKeyGenParamSpec.getConstructedType() instanceof RsaKeyGenParameterSpec and
      sink.asExpr() = rsaKeyGenParamSpec.getArgument(0)
    )
    or
    exists(ClassInstanceExpr dsaGenParamSpec |
      dsaGenParamSpec.getConstructedType() instanceof DsaGenParameterSpec and
      sink.asExpr() = dsaGenParamSpec.getArgument(0)
    )
    or
    exists(ClassInstanceExpr dhGenParamSpec |
      dhGenParamSpec.getConstructedType() instanceof DhGenParameterSpec and
      sink.asExpr() = dhGenParamSpec.getArgument(0)
    )
  }
}

/**
 * An Asymmetric (EC) key length data flow tracking configuration.
 */
class AsymmetricECKeyTrackingConfiguration extends DataFlow::Configuration {
  AsymmetricECKeyTrackingConfiguration() { this = "AsymmetricECKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(IntegerLiteral).getIntValue() < 256 or
    getECKeySize(source.asExpr().(StringLiteral).getValue()) < 256 // need this for the cases when the key size is embedded in the curve name.
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, JavaSecurityKeyPairGenerator jpg |
      ma.getMethod() instanceof KeyPairGeneratorInitMethod and
      jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches("EC%") and
      DataFlow::localExprFlow(jpg, ma.getQualifier()) and
      // exists(
      //   JavaSecurityKeyPairGenerator jpg, KeyPairGeneratorInitConfiguration kpgConfig,
      //   DataFlow::PathNode source, DataFlow::PathNode dest
      // |
      //   jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches("EC%") and
      //   source.getNode().asExpr() = jpg and
      //   dest.getNode().asExpr() = ma.getQualifier() and
      //   kpgConfig.hasFlowPath(source, dest)
      // ) and
      sink.asExpr() = ma.getArgument(0)
    )
    or
    exists(ClassInstanceExpr ecGenParamSpec |
      ecGenParamSpec.getConstructedType() instanceof EcGenParameterSpec and
      //getECKeySize(ecGenParamSpec.getArgument(0).(StringLiteral).getValue()) < 256 and
      sink.asExpr() = ecGenParamSpec.getArgument(0)
    )
  }
}

/**
 * A Symmetric (AES) key length data flow tracking configuration.
 */
class SymmetricKeyTrackingConfiguration extends DataFlow::Configuration {
  SymmetricKeyTrackingConfiguration() { this = "SymmetricKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(IntegerLiteral).getIntValue() < 128
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, JavaxCryptoKeyGenerator jcg |
      ma.getMethod() instanceof KeyGeneratorInitMethod and
      jcg.getAlgoSpec().(StringLiteral).getValue().toUpperCase() = "AES" and
      DataFlow::localExprFlow(jcg, ma.getQualifier()) and
      // exists(
      //   JavaxCryptoKeyGenerator jcg, KeyGeneratorInitConfiguration kgConfig,
      //   DataFlow::PathNode source, DataFlow::PathNode dest
      // |
      //   jcg.getAlgoSpec().(StringLiteral).getValue().toUpperCase() = "AES" and
      //   source.getNode().asExpr() = jcg and
      //   dest.getNode().asExpr() = ma.getQualifier() and
      //   kgConfig.hasFlowPath(source, dest)
      // ) and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}

// ********************** Need the below models for the above configs **********************
// todo: move some/all of below to Encryption.qll or elsewhere?
// /** A data flow configuration tracking flow from a key generator to an `init` method call. */
// private class KeyGeneratorInitConfiguration extends DataFlow::Configuration {
//   KeyGeneratorInitConfiguration() { this = "KeyGeneratorInitConfiguration" }
//   override predicate isSource(DataFlow::Node source) {
//     source.asExpr() instanceof JavaxCryptoKeyGenerator
//   }
//   override predicate isSink(DataFlow::Node sink) {
//     exists(MethodAccess ma |
//       ma.getMethod() instanceof KeyGeneratorInitMethod and
//       sink.asExpr() = ma.getQualifier()
//     )
//   }
// }
// /** A data flow configuration tracking flow from a keypair generator to an `initialize` method call. */
// private class KeyPairGeneratorInitConfiguration extends DataFlow::Configuration {
//   KeyPairGeneratorInitConfiguration() { this = "KeyPairGeneratorInitConfiguration" }
//   override predicate isSource(DataFlow::Node source) {
//     source.asExpr() instanceof JavaSecurityKeyPairGenerator
//   }
//   override predicate isSink(DataFlow::Node sink) {
//     exists(MethodAccess ma |
//       ma.getMethod() instanceof KeyPairGeneratorInitMethod and
//       sink.asExpr() = ma.getQualifier()
//     )
//   }
// }
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
// ******* DATAFLOW ABOVE *************************************************************************
// TODO:
// todo #0: look into use of specs without keygens; should spec not be a sink in these cases?
// todo #1: make representation of source that can be shared across the configs
// todo #2: make representation of sink that can be shared across the configs
// todo #3: make list of algo names more easily reusable (either as constant-type variable at top of file, or model as own class to share, etc.)
// todo #4: refactor to be more like the Python (or C#) version? (or not possible because of lack of DataFlow::Node for void method in Java?)
