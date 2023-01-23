/**
 * Provides a taint-tracking configuration for reasoning about HTML
 * constructed from library input vulnerabilities.
 *
 * Note, for performance reasons: only import this file if `Configuration` is needed,
 * otherwise `UnsafeHtmlConstructionCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import UnsafeHtmlConstructionCustomizations::UnsafeHtmlConstruction
private import codeql.ruby.TaintTracking
private import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for detecting unsafe HTML construction.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeHtmlConstruction" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  // override to require the path doesn't have unmatched return steps
  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }
}
