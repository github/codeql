/** Provides classes and predicates to be used in queries related to Android Fragment injection. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.FragmentInjection

/**
 * DEPRECATED: Use `FragmentInjectionFlow` instead.
 *
 * A taint-tracking configuration for unsafe user input
 * that is used to create Android fragments dynamically.
 */
deprecated class FragmentInjectionTaintConf extends TaintTracking::Configuration {
  FragmentInjectionTaintConf() { this = "FragmentInjectionTaintConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof FragmentInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(FragmentInjectionAdditionalTaintStep c).step(n1, n2)
  }
}

private module FragmentInjectionTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof FragmentInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(FragmentInjectionAdditionalTaintStep c).step(n1, n2)
  }
}

/**
 * Taint-tracking flow for unsafe user input
 * that is used to create Android fragments dynamically.
 */
module FragmentInjectionTaintFlow = TaintTracking::Global<FragmentInjectionTaintConfig>;
