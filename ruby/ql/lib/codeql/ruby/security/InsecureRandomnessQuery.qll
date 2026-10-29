/**
 * Provides default sources, sinks and sanitizers for detecting Insecure Randomness
 * vulnerabilities, as well as extension points for adding your own.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import InsecureRandomnessCustomizations::InsecureRandomness

private module InsecureRandomnessConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting Insecure Randomness vulnerabilities.
 */
module InsecureRandomnessFlow = TaintTracking::Global<InsecureRandomnessConfig>;
