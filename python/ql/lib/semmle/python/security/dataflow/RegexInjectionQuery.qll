/**
 * Provides a taint-tracking configuration for detecting "regular expression injection"
 * vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `RegexInjection::Configuration` is needed, otherwise
 * `RegexInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import RegexInjectionCustomizations::RegexInjection

private module RegexInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getRegexExecution().getLocation()
  }
}

/** Global taint-tracking for detecting "regular expression injection" vulnerabilities. */
module RegexInjectionFlow = TaintTracking::Global<RegexInjectionConfig>;
