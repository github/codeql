/**
 * Provides a taint-tracking configuration for reasoning about DOM-based
 * cross-site scripting vulnerabilities in unsafe jQuery plugins.
 */

import javascript
import semmle.javascript.security.dataflow.DomBasedXssCustomizations
import UnsafeJQueryPluginCustomizations::UnsafeJQueryPlugin

/**
 * A taint-tracking configuration for reasoning about XSS in unsafe jQuery plugins.
 */
module UnsafeJQueryPluginConfig implements DataFlow::ConfigSig {
  // Note: This query currently misses some results due to two issues:
  // - PropertyPresenceSanitizer blocks values in a content
  // - localFieldStep has been omitted for performance reaons
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof DomBasedXss::Sanitizer or
    node instanceof Sanitizer or
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node sink) {
    aliasPropertyPresenceStep(node1, sink)
  }

  predicate isBarrierOut(DataFlow::Node node) {
    // prefixing prevents forced html/css confusion:
    // prefixing through concatenation:
    StringConcatenation::taintStep(node, _, _, any(int i | i >= 1))
    or
    // prefixing through a poor-mans templating system:
    node = any(StringReplaceCall call).getRawReplacement()
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    result = source.(Source).getLocation()
    or
    result = source.(Source).getPlugin().getLocation()
  }
}

/**
 * Taint-tracking for reasoning about XSS in unsafe jQuery plugins.
 */
module UnsafeJQueryPluginFlow = TaintTracking::Global<UnsafeJQueryPluginConfig>;

/**
 * DEPRECATED. Use the `UnsafeJQueryPluginFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
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

  override predicate isSanitizerOut(DataFlow::Node node) {
    // prefixing prevents forced html/css confusion:
    // prefixing through concatenation:
    StringConcatenation::taintStep(node, _, _, any(int i | i >= 1))
    or
    // prefixing through a poor-mans templating system:
    node = any(StringReplaceCall call).getRawReplacement()
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
    super.isSanitizerGuard(node) or
    node instanceof IsElementSanitizer or
    node instanceof PropertyPresenceSanitizer or
    node instanceof NumberGuard
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
  DataFlow::PropRead src, DataFlow::Node sink, ReachableBasicBlock srcBB, ReachableBasicBlock sinkBB
) {
  exists(PropertyPresenceSanitizer sanitizer |
    src = sanitizer.getPropRead() and
    sink = AccessPath::getAnAliasedSourceNode(src) and
    srcBB = src.getBasicBlock() and
    sinkBB = sink.getBasicBlock()
  )
}
