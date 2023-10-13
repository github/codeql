/**
 * Provides a taint-tracking configuration for detecting "regular expression injection"
 * vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `RegexInjection::Configuration` is needed, otherwise
 * `RegexInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import RegexInjectionCustomizations::RegexInjection

/**
 * DEPRECATED: Use `RegexInjectionFlow` module instead.
 *
 * A taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "RegexInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

private module RegexInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "regular expression injection" vulnerabilities. */
module RegexInjectionFlow = TaintTracking::Global<RegexInjectionConfig>;
