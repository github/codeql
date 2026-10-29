/**
 * Provides a taint-tracking configuration for detecting "prompt injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `SystemPromptInjectionFlow::Configuration` is needed, otherwise
 * `SystemPromptInjectionCustomizations` should be imported instead.
 */

private import javascript
import semmle.javascript.dataflow.DataFlow
import semmle.javascript.dataflow.TaintTracking
import SystemPromptInjectionCustomizations::SystemPromptInjection

private module SystemPromptInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Global taint-tracking for detecting "prompt injection" vulnerabilities. */
module SystemPromptInjectionFlow = TaintTracking::Global<SystemPromptInjectionConfig>;
