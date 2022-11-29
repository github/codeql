/**
 * For internal use only.
 *
 * Defines shared code used by the path injection boosted query.
 */

import semmle.javascript.heuristics.SyntacticHeuristics
import semmle.javascript.security.dataflow.TaintedPathCustomizations
import AdaptiveThreatModeling
import CoreKnowledge as CoreKnowledge

class TaintedPathAtmConfig extends AtmConfig {
  TaintedPathAtmConfig() { this = "TaintedPathATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof TaintedPath::Source }

  override EndpointType getASinkEndpointType() { result instanceof TaintedPathSinkType }
}

/** DEPRECATED: Alias for TaintedPathAtmConfig */
deprecated class TaintedPathATMConfig = TaintedPathAtmConfig;

/**
 * A taint-tracking configuration for reasoning about path injection vulnerabilities.
 *
 * This is largely a copy of the taint tracking configuration for the standard path injection
 * query, except additional ATM sinks have been added to the `isSink` predicate.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "TaintedPathATM" }

  override predicate isSource(DataFlow::Node source) { source instanceof TaintedPath::Source }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    label = sink.(TaintedPath::Sink).getAFlowLabel()
    or
    // Allow effective sinks to have any taint label
    any(TaintedPathAtmConfig cfg).isEffectiveSink(sink)
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof TaintedPath::Sanitizer }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
    node instanceof BarrierGuardNodeAsSanitizerGuardNode
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    TaintedPath::isAdditionalTaintedPathFlowStep(src, dst, srclabel, dstlabel)
  }
}

/**
 * This class provides sanitizer guards for path injection.
 *
 * The standard library path injection query uses a data flow configuration, and therefore defines
 * barrier nodes. However we're using a taint tracking configuration for path injection to find new
 * kinds of less certain results. Since taint tracking configurations use sanitizer guards instead
 * of barrier guards, we port the barrier guards for the boosted query from the standard library to
 * sanitizer guards here.
 */
class BarrierGuardNodeAsSanitizerGuardNode extends TaintTracking::LabeledSanitizerGuardNode {
  BarrierGuardNodeAsSanitizerGuardNode() { this instanceof TaintedPath::BarrierGuardNode }

  override predicate sanitizes(boolean outcome, Expr e) {
    blocks(outcome, e) or blocks(outcome, e, _)
  }

  override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    sanitizes(outcome, e) and exists(label)
  }
}
