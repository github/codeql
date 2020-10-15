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
      exists(StringReplaceCall replace |
        replace = succ and
        pred = replace.getRawReplacement()
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
    exists(ReachableBasicBlock srcBB, ReachableBasicBlock sinkBB |
      aliasPropertyPresenceStepHelper(src, sink, srcBB, sinkBB) and
      srcBB.strictlyDominates(sinkBB)
    )
  }

  /**
   * Holds if there is a taint-step from `src` to `sink`, and `srcBB` is the basicblock for `src` and `sinkBB` is the basicblock for `sink`.
   *
   * This predicate is outlined to get a better join-order.
   */
  pragma[noinline]
  private predicate aliasPropertyPresenceStepHelper(
    DataFlow::PropRead src, DataFlow::Node sink, ReachableBasicBlock srcBB,
    ReachableBasicBlock sinkBB
  ) {
    exists(PropertyPresenceSanitizer sanitizer |
      src = sanitizer.getPropRead() and
      sink = AccessPath::getAnAliasedSourceNode(src) and
      srcBB = src.getBasicBlock() and
      sinkBB = sink.getBasicBlock()
    )
  }
}
