/** Provides taint tracking configurations to be used in Android Intent Redirect queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.AndroidIntentRedirect

/**
 * A taint tracking configuration for user-provided Intents being used to start Android components.
 */
class IntentRedirectConfiguration extends TaintTracking::Configuration {
  IntentRedirectConfiguration() { this = "IntentRedirectConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof IntentRedirectSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof IntentRedirectSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(IntentRedirectAdditionalTaintStep c).step(node1, node2)
  }
}
