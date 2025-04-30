/**
 * Provides a taint tracking configuration for reasoning about bypass of sensitive action guards.
 *
 * Note, for performance reasons: only import this file if
 * `ConditionalBypassFlow` is needed, otherwise
 * `ConditionalBypassCustomizations` should be imported instead.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.security.SensitiveActions
import ConditionalBypassCustomizations::ConditionalBypass

private module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.getLocation() or result = sink.(Sink).getAction().getLocation()
  }
}

/**
 * Taint-tracking for bypass of sensitive action guards.
 */
module ConditionalBypassFlow = TaintTracking::Global<Config>;
