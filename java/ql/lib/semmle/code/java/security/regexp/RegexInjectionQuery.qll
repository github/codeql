/** Provides configurations to be used in queries related to regex injection. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.regexp.RegexInjection

/** A taint-tracking configuration for untrusted user input used to construct regular expressions. */
class RegexInjectionConfiguration extends TaintTracking::Configuration {
  RegexInjectionConfiguration() { this = "RegexInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegexInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof RegexInjectionSanitizer }
}
