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

private module CodeInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "code injection" vulnerabilities. */
module CodeInjectionFlow = TaintTracking::Global<CodeInjectionConfig>;
