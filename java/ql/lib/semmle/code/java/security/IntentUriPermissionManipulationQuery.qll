/**
 * Provides taint tracking configurations to be used in queries related to Intent URI permission
 * manipulation in Android.
 */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.DataFlow
private import IntentUriPermissionManipulation

/**
 * A taint tracking configuration for user-provided Intents being returned to third party apps.
 */
class IntentUriPermissionManipulationConf extends TaintTracking::Configuration {
  IntentUriPermissionManipulationConf() { this = "UriPermissionManipulationConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof IntentUriPermissionManipulationSink
  }

  override predicate isSanitizer(DataFlow::Node barrier) {
    barrier instanceof IntentUriPermissionManipulationSanitizer
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof IntentUriPermissionManipulationGuard
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(IntentUriPermissionManipulationAdditionalTaintStep c).step(node1, node2)
  }
}
