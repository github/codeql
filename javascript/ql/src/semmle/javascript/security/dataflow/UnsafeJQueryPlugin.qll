/**
 * Provides a taint-tracking configuration for reasoning about DOM-based
 * cross-site scripting vulnerabilities in unsafe jQuery plugins.
 */

import javascript
import semmle.javascript.security.dataflow.Xss

module UnsafeJQueryPlugin {
  import UnsafeJQueryPluginCustomizations::UnsafeJQueryPlugin

  /**
   * A taint-tracking configuration for reasoning about XSS in unsafe jQuery plugins.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "UnsafeJQueryPlugin" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node)
      or
      node instanceof DomBasedXss::Sanitizer
      or
      node instanceof Sanitizer
    }

    override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node sink) {
      // jQuery plugins tend to be implemented as classes that store data in fields initialized by the constructor.
      DataFlow::localFieldStep(src, sink) or
      aliasPropertyPresenceStep(src, sink)
    }

    override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
      // prefixing prevents forced html/css confusion:
      // prefixing through concatenation:
      StringConcatenation::taintStep(pred, succ, _, any(int i | i >= 1))
      or
      // prefixing through a poor-mans templating system:
      exists(DataFlow::MethodCallNode replace |
        replace = succ and
        pred = replace.getArgument(1) and
        replace.getMethodName() = "replace"
      )
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
      super.isSanitizerGuard(node) or
      node instanceof IsElementSanitizer or
      node instanceof PropertyPresenceSanitizer
    }
  }

  /**
   * Holds if there is a taint-step from `src` to `sink`,
   * where `src` is a property read that acts as a sanitizer for the base,
   * and `sink` is that same property read from the same base.
   *
   * For an condition like `if(foo.bar) {...}`, the base `foo` is sanitized but the property `foo.bar` is not.
   * With this taint-step we regain that `foo.bar` is tainted, because `PropertyPresenceSanitizer` could remove it.
   */
  private predicate aliasPropertyPresenceStep(DataFlow::Node src, DataFlow::Node sink) {
    exists(PropertyPresenceSanitizer sanitizer, DataFlow::PropRead read | read = src |
      read = sanitizer.getPropRead() and
      sink = AccessPath::getAnAliasedSourceNode(read) and
      read.getBasicBlock().(ReachableBasicBlock).strictlyDominates(sink.getBasicBlock())
    )
  }
}
