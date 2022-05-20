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
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PathInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof PathInjection::Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PathInjection::Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Path::PathSanitization }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof PathInjection::SanitizerGuard
  }
}
