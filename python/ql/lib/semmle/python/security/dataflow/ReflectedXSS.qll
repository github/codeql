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

/**
 * Provides a taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 */
module ReflectedXSS {
  import ReflectedXSSCustomizations::ReflectedXSS

  /**
   * A taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ReflectedXSS" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}

/**
 * DEPRECATED: Don't extend this class for customization, since this will lead to bad
 * performance, instead use the new `ReflectedXSSCustomizations.qll` file, and extend
 * its' classes.
 */
deprecated class ReflectedXssConfiguration = ReflectedXSS::Configuration;
