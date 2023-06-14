/**
 * Provides a taint tracking configuration for reasoning about
 * path injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `PathInjection::Configuration` is needed, otherwise
 * `PathInjectionCustomizations` should be imported instead.
 */

import PathInjectionCustomizations
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking

/**
 * A taint-tracking configuration for reasoning about path injection
 * vulnerabilities.
 */
module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

private module ConfigurationImpl implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof PathInjection::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof PathInjection::Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Path::PathSanitization or node instanceof PathInjection::Sanitizer
  }

  additional deprecated predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof PathInjection::SanitizerGuard
  }
}
