/**
 * Provides a taint-tracking configuration for detecting "URL redirection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UrlRedirect::Configuration` is needed, otherwise
 * `UrlRedirectCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "URL redirection" vulnerabilities.
 */
module UrlRedirect {
  import UrlRedirectCustomizations::UrlRedirect

  /**
   * A taint-tracking configuration for detecting "URL redirection" vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "UrlRedirect" }

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
 * performance, instead use the new `UrlRedirectCustomizations.qll` file, and extend
 * its' classes.
 */
deprecated class UrlRedirectConfiguration = UrlRedirect::Configuration;
