/**
 * Provides a taint-tracking configuration for detecting "user prompt injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UserPromptInjection::Configuration` is needed, otherwise
 * `UserPromptInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import UserPromptInjectionCustomizations::UserPromptInjection

private module UserPromptInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Global taint-tracking for detecting "user prompt injection" vulnerabilities. */
module UserPromptInjectionFlow = TaintTracking::Global<UserPromptInjectionConfig>;
