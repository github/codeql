/**
 * Provides a taint-tracking configuration for reasoning about
 * untrusted user input used to construct regular expressions.
 *
 * Note, for performance reasons: only import this file if
 * `RegExpInjection::Configuration` is needed, otherwise
 * `RegExpInjectionCustomizations` should be imported instead.
 */

import javascript
import RegExpInjectionCustomizations::RegExpInjection

/**
 * A taint-tracking configuration for untrusted user input used to construct regular expressions.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "RegExpInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}
