/**
 * Provides a taint-tracking configuration for detecting "code injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `CodeInjection::Configuration` is needed, otherwise
 * `CodeInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import CodeInjectionCustomizations::CodeInjection

/**
 * DEPRECATED: Use `CodeInjectionFlow` module instead.
 *
 * A taint-tracking configuration for detecting "code injection" vulnerabilities.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CodeInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

private module CodeInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "code injection" vulnerabilities. */
module CodeInjectionFlow = TaintTracking::Global<CodeInjectionConfig>;
