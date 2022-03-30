/** Provides classes and predicates to be used in queries related to Android Fragment injection. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.FragmentInjection

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to create Android fragments dynamically.
 */
class FragmentInjectionTaintConf extends TaintTracking::Configuration {
  FragmentInjectionTaintConf() { this = "FragmentInjectionTaintConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof FragmentInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(FragmentInjectionAdditionalTaintStep c).step(n1, n2)
  }
}
