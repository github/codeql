/**
 * Provides a taint tracking configuration for reasoning about string based
 * query injection vulnerabilities
 *
 * Note, for performance reasons: only import this file if
 * `SqlInjection::Configuration` is needed, otherwise
 * `SqlInjectionCustomizations` should be imported instead.
 */

import javascript
import SqlInjectionCustomizations::SqlInjection
import semmle.javascript.frameworks.TypeORM

/**
 * A taint-tracking configuration for reasoning about string based query injection vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SqlInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof TypeOrm::QueryString }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(LdapJS::TaintPreservingLdapFilterStep filter |
      pred = filter.getInput() and
      succ = filter.getOutput()
    )
    or
    exists(HtmlSanitizerCall call |
      pred = call.getInput() and
      succ = call
    )
  }
}
