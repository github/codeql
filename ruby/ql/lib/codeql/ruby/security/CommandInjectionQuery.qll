/**
 * Provides a taint tracking configuration for reasoning about
 * command-injection vulnerabilities (CWE-078).
 *
 * Note, for performance reasons: only import this file if
 * `CommandInjectionFlow` is needed, otherwise
 * `CommandInjectionCustomizations` should be imported instead.
 */

import codeql.ruby.AST
import codeql.ruby.TaintTracking
import CommandInjectionCustomizations::CommandInjection
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for reasoning about command-injection vulnerabilities.
 * DEPRECATED: Use `CommandInjectionFlow` instead
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CommandInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof Sanitizer or
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }
}

private module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }
}

/**
 * Taint-tracking for reasoning about command-injection vulnerabilities.
 */
module CommandInjectionFlow = TaintTracking::Global<Config>;
