/**
 * Provides a taint-tracking configuration for detecting "system prompt injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `SystemPromptInjection::Configuration` is needed, otherwise
 * `SystemPromptInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import SystemPromptInjectionCustomizations::SystemPromptInjection

private module SystemPromptInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Global taint-tracking for detecting "system prompt injection" vulnerabilities. */
module SystemPromptInjectionFlow = TaintTracking::Global<SystemPromptInjectionConfig>;
