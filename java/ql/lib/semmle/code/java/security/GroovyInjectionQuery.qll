/** Provides taint tracking configurations relating to Groovy injection vulnerabilities. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.GroovyInjection

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to evaluate a Groovy expression.
 */
module GroovyInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof GroovyInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    any(GroovyInjectionAdditionalTaintStep c).step(fromNode, toNode)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Detect taint flow of unsafe user input
 * that is used to evaluate a Groovy expression.
 */
module GroovyInjectionFlow = TaintTracking::Global<GroovyInjectionConfig>;
