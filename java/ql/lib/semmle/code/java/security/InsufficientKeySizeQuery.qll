/** Provides data flow configurations to be used in queries related to insufficient key sizes. */

import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.InsufficientKeySize

/**
 * A data flow configuration for tracking non-elliptic curve asymmetric algorithm
 * (RSA, DSA, and DH) key sizes.
 */
class KeySizeConfiguration extends DataFlow::Configuration {
  KeySizeConfiguration() { this = "KeySizeConfiguration" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.(InsufficientKeySizeSource).hasState(state)
    //source instanceof InsufficientKeySizeSource
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink.(InsufficientKeySizeSink).hasState(state)
    //sink instanceof InsufficientKeySizeSink
  }
}
// /**
//  * A data flow configuration for tracking non-elliptic curve asymmetric algorithm
//  * (RSA, DSA, and DH) key sizes.
//  */
// class AsymmetricNonECKeyTrackingConfiguration extends DataFlow::Configuration {
//   AsymmetricNonECKeyTrackingConfiguration() { this = "AsymmetricNonECKeyTrackingConfiguration" }
//   override predicate isSource(DataFlow::Node source) { source instanceof AsymmetricNonECSource }
//   override predicate isSink(DataFlow::Node sink) { sink instanceof AsymmetricNonECSink }
// }
// /**
//  * A data flow configuration for tracking elliptic curve (EC) asymmetric
//  * algorithm key sizes.
//  */
// class AsymmetricECKeyTrackingConfiguration extends DataFlow::Configuration {
//   AsymmetricECKeyTrackingConfiguration() { this = "AsymmetricECKeyTrackingConfiguration" }
//   override predicate isSource(DataFlow::Node source) { source instanceof AsymmetricECSource }
//   override predicate isSink(DataFlow::Node sink) { sink instanceof AsymmetricECSink }
// }
// /** A data flow configuration for tracking symmetric algorithm (AES) key sizes. */
// class SymmetricKeyTrackingConfiguration extends DataFlow::Configuration {
//   SymmetricKeyTrackingConfiguration() { this = "SymmetricKeyTrackingConfiguration" }
//   override predicate isSource(DataFlow::Node source) { source instanceof SymmetricSource }
//   override predicate isSink(DataFlow::Node sink) { sink instanceof SymmetricSink }
// }
