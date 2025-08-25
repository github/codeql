/**
 * Provides a taint-tracking configuration for detecting "Xpath Injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `XpathInjection::Configuration` is needed, otherwise
 * `XpathInjectionCustomizations` should be imported instead.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import XpathInjectionCustomizations::XpathInjection

private module XpathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting "Xpath Injection" vulnerabilities.
 */
module XpathInjectionFlow = TaintTracking::Global<XpathInjectionConfig>;
