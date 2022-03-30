/** Provides taint tracking configurations relating to Groovy injection vulnerabilities. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.GroovyInjection

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to evaluate a Groovy expression.
 */
class GroovyInjectionConfig extends TaintTracking::Configuration {
  GroovyInjectionConfig() { this = "GroovyInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof GroovyInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    any(GroovyInjectionAdditionalTaintStep c).step(fromNode, toNode)
  }
}
