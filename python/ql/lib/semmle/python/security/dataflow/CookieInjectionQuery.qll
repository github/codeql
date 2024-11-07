/**
 * Provides a taint-tracking configuration for detecting "cookie injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `CookieInjectionFlow` is needed, otherwise
 * `CookieInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import CookieInjectionCustomizations::CookieInjection

/**
 * A taint-tracking configuration for detecting "cookie injection" vulnerabilities.
 */
module CookieInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "cookie injection" vulnerabilities. */
module CookieInjectionFlow = TaintTracking::Global<CookieInjectionConfig>;
