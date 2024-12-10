/**
 * Provides a taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `ReflectedXSS::Configuration` is needed, otherwise
 * `ReflectedXSSCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import ReflectedXSSCustomizations::ReflectedXss

private module ReflectedXssConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "reflected server-side cross-site scripting" vulnerabilities. */
module ReflectedXssFlow = TaintTracking::Global<ReflectedXssConfig>;
