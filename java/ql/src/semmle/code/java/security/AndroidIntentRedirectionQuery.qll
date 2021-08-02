/** Provides taint tracking configurations to be used in Android Intent redirection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.AndroidIntentRedirection

/**
 * A taint tracking configuration for user-provided Intents being used to start Android components.
 */
class IntentRedirectionConfiguration extends TaintTracking::Configuration {
  IntentRedirectionConfiguration() { this = "IntentRedirectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof IntentRedirectionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof IntentRedirectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(IntentRedirectionAdditionalTaintStep c).step(node1, node2)
  }
}
