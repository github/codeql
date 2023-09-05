/**
 * Provides a taint-tracking configuration for detecting "XML External Entity (XXE)" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `Configuration` is needed, otherwise
 * `XxeCustomizations` should be imported instead.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import XxeCustomizations::Xxe

/**
 * A taint-tracking configuration for detecting "XML External Entity (XXE)" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "Xxe" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}
