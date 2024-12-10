/**
 * Provides a taint-tracking configuration for detecting "command injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `CommandInjection::Configuration` is needed, otherwise
 * `CommandInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import CommandInjectionCustomizations::CommandInjection

/**
 * A taint-tracking configuration for detecting "command injection" vulnerabilities.
 */
module CommandInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "command injection" vulnerabilities. */
module CommandInjectionFlow = TaintTracking::Global<CommandInjectionConfig>;
