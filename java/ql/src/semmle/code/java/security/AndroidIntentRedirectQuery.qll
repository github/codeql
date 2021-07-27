/** Provides taint tracking configurations to be used in Android Intent Redirect queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/**
 * A taint tracking configuration for user-provided Intents being used to start Android components.
 */
class IntentRedirectConfiguration extends TaintTracking::Configuration {
  IntentRedirectConfiguration() { this = "IntentRedirectConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof StartActivityMethod or
      ma.getMethod() instanceof StartServiceMethod or
      ma.getMethod() instanceof SendBroadcastMethod
    |
      ma.getArgument(0) = sink.asExpr()
    )
  }
}
