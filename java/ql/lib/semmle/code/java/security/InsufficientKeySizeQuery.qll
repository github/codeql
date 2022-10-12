/** Provides data flow configurations to be used in queries related to insufficient key sizes. */

import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.InsufficientKeySize

/**
 * A data flow configuration for tracking non-elliptic curve asymmetric algorithms
 * (RSA, DSA, and DH) key sizes.
 */
class AsymmetricNonECKeyTrackingConfiguration extends DataFlow::Configuration {
  AsymmetricNonECKeyTrackingConfiguration() { this = "AsymmetricNonECKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof AsymmetricNonECSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof AsymmetricNonECSink }
}

/**
 * A data flow configuration for tracking elliptic curve (EC) asymmetric
 * algorithm key sizes.
 */
class AsymmetricECKeyTrackingConfiguration extends DataFlow::Configuration {
  AsymmetricECKeyTrackingConfiguration() { this = "AsymmetricECKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof AsymmetricECSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof AsymmetricECSink }
}

/** A data flow configuration for tracking symmetric algorithm (AES) key sizes. */
class SymmetricKeyTrackingConfiguration extends DataFlow::Configuration {
  SymmetricKeyTrackingConfiguration() { this = "SymmetricKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof SymmetricSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SymmetricSink }
}
// ******* 3 DATAFLOW CONFIGS ABOVE *************************************************************************
// ******* SINGLE CONFIG ATTEMPT BELOW *************************************************************************
// /**
//  * A key length data flow tracking configuration.
//  */
// class KeyTrackingConfiguration extends DataFlow::Configuration {
//   KeyTrackingConfiguration() { this = "KeyTrackingConfiguration" }
//   override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
//     //state instanceof DataFlow::FlowStateEmpty and
//     // SYMMETRIC
//     source.asExpr().(IntegerLiteral).getIntValue() < 128 and state = "128"
//     or
//     // ASYMMETRIC
//     source.asExpr().(IntegerLiteral).getIntValue() < 2048 and state = "2048"
//     or
//     source.asExpr().(IntegerLiteral).getIntValue() < 256 and state = "256"
//     or
//     getECKeySize(source.asExpr().(StringLiteral).getValue()) < 256 and state = "256" // need this for the cases when the key size is embedded in the curve name.
//   }
//   override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
//     // SYMMETRIC
//     exists(MethodAccess ma, JavaxCryptoKeyGenerator jcg |
//       ma.getMethod() instanceof KeyGeneratorInitMethod and
//       jcg.getAlgoSpec().(StringLiteral).getValue().toUpperCase() = "AES" and
//       DataFlow::localExprFlow(jcg, ma.getQualifier()) and
//       sink.asExpr() = ma.getArgument(0) and
//       state = "128"
//     )
//     or
//     // ASYMMETRIC
//     exists(MethodAccess ma, JavaSecurityKeyPairGenerator jpg |
//       ma.getMethod() instanceof KeyPairGeneratorInitMethod and
//       (
//         jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches(["RSA", "DSA", "DH"]) and
//         DataFlow::localExprFlow(jpg, ma.getQualifier()) and
//         sink.asExpr() = ma.getArgument(0) and
//         //ma.getArgument(0).(LocalSourceNode).flowsTo(sink) and
//         //ma.getArgument(0).(CompileTimeConstantExpr).getIntValue() < 2048 and
//         state = "2048"
//       )
//       or
//       jpg.getAlgoSpec().(StringLiteral).getValue().toUpperCase().matches("EC%") and
//       DataFlow::localExprFlow(jpg, ma.getQualifier()) and
//       sink.asExpr() = ma.getArgument(0) and
//       //ma.getArgument(0).(CompileTimeConstantExpr).getIntValue() < 256 and
//       state = "256"
//     )
//     or
//     // TODO: combine below three for less duplicated code
//     exists(ClassInstanceExpr rsaKeyGenParamSpec |
//       rsaKeyGenParamSpec.getConstructedType() instanceof RsaKeyGenParameterSpec and
//       sink.asExpr() = rsaKeyGenParamSpec.getArgument(0) and
//       state = "2048"
//     )
//     or
//     exists(ClassInstanceExpr dsaGenParamSpec |
//       dsaGenParamSpec.getConstructedType() instanceof DsaGenParameterSpec and
//       sink.asExpr() = dsaGenParamSpec.getArgument(0) and
//       state = "2048"
//     )
//     or
//     exists(ClassInstanceExpr dhGenParamSpec |
//       dhGenParamSpec.getConstructedType() instanceof DhGenParameterSpec and
//       sink.asExpr() = dhGenParamSpec.getArgument(0) and
//       state = "2048"
//     )
//     or
//     exists(ClassInstanceExpr ecGenParamSpec |
//       ecGenParamSpec.getConstructedType() instanceof EcGenParameterSpec and
//       sink.asExpr() = ecGenParamSpec.getArgument(0) and
//       state = "256"
//     )
//   }
//   // ! FlowStates seem to work without even including a step like the below... hmmm
//   override predicate isAdditionalFlowStep(
//     DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
//     DataFlow::FlowState state2
//   ) {
//     exists(IntegerLiteral intLiteral |
//       state1 = "" and
//       state2 = intLiteral.toString() and
//       node1.asExpr() = intLiteral and
//       node2.asExpr() = intLiteral
//     )
//   }
// }
