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
module IntentUriPermissionManipulationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof IntentUriPermissionManipulationSink }

  predicate isBarrier(DataFlow::Node barrier) {
    barrier instanceof IntentUriPermissionManipulationSanitizer
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(IntentUriPermissionManipulationAdditionalTaintStep c).step(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint tracking flow for user-provided Intents being returned to third party apps.
 */
module IntentUriPermissionManipulationFlow =
  TaintTracking::Global<IntentUriPermissionManipulationConfig>;
