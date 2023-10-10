/**
 * Provides a taint tracking configuration for reasoning about
 * path injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `PathInjectionFlow` is needed, otherwise
 * `PathInjectionCustomizations` should be imported instead.
 */

import PathInjectionCustomizations
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking

/**
 * A taint-tracking configuration for reasoning about path injection
 * vulnerabilities.
 * DEPRECATED: Use `PathInjectionFlow`
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PathInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof PathInjection::Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PathInjection::Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof Path::PathSanitization or node instanceof PathInjection::Sanitizer
  }
}

private module PathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof PathInjection::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof PathInjection::Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Path::PathSanitization or node instanceof PathInjection::Sanitizer
  }
}

/**
 * Taint-tracking for detecting path injection vulnerabilities.
 */
module PathInjectionFlow = TaintTracking::Global<PathInjectionConfig>;
