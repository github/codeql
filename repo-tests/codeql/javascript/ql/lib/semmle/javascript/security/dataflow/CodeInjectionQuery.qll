/**
 * Provides a taint-tracking configuration for reasoning about code
 * injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `CodeInjection::Configuration` is needed, otherwise
 * `CodeInjectionCustomizations` should be imported instead.
 */

import javascript
import CodeInjectionCustomizations::CodeInjection

/**
 * A taint-tracking configuration for reasoning about code injection vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CodeInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node trg) {
    // HTML sanitizers are insufficient protection against code injection
    src = trg.(HtmlSanitizerCall).getInput()
  }
}
