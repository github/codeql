/**
 * Provides a taint-tracking configuration for tracking "log injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `LogInjection::Configuration` is needed, otherwise
 * `LogInjectionCustomizations` should be imported instead.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import LogInjectionCustomizations::LogInjection

private module LogInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "log injection" vulnerabilities. */
module LogInjectionFlow = TaintTracking::Global<LogInjectionConfig>;
