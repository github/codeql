/**
 * For internal use only.
 *
 * Defines shared code used by the path injection boosted query.
 */

import semmle.javascript.heuristics.SyntacticHeuristics
import semmle.javascript.security.dataflow.TaintedPathCustomizations
import AdaptiveThreatModeling
import CoreKnowledge as CoreKnowledge
import StandardEndpointFilters as StandardEndpointFilters

/**
 * This module provides logic to filter candidate sinks to those which are likely path injection
 * sinks.
 */
module SinkEndpointFilter {
  private import javascript
  private import TaintedPath

  /**
   * Provides a set of reasons why a given data flow node should be excluded as a sink candidate.
   *
   * If this predicate has no results for a sink candidate `n`, then we should treat `n` as an
   * effective sink.
   */
  string getAReasonSinkExcluded(DataFlow::Node sinkCandidate) {
    result = StandardEndpointFilters::getAReasonSinkExcluded(sinkCandidate)
    or
    // Require path injection sink candidates to be (a) arguments to external library calls
    // (possibly indirectly), or (b) heuristic sinks.
    //
    // Heuristic sinks are mostly copied from the `HeuristicTaintedPathSink` class defined within
    // `codeql/javascript/ql/src/semmle/javascript/heuristics/AdditionalSinks.qll`.
    // We can't reuse the class because importing that file would cause us to treat these
    // heuristic sinks as known sinks.
    not StandardEndpointFilters::flowsToArgumentOfLikelyExternalLibraryCall(sinkCandidate) and
    not (
      isAssignedToOrConcatenatedWith(sinkCandidate, "(?i)(file|folder|dir|absolute)")
      or
      isArgTo(sinkCandidate, "(?i)(get|read)file")
      or
      exists(string pathPattern |
        // paths with at least two parts, and either a trailing or leading slash
        pathPattern = "(?i)([a-z0-9_.-]+/){2,}" or
        pathPattern = "(?i)(/[a-z0-9_.-]+){2,}"
      |
        isConcatenatedWithString(sinkCandidate, pathPattern)
      )
      or
      isConcatenatedWithStrings(".*/", sinkCandidate, "/.*")
      or
      // In addition to the names from `HeuristicTaintedPathSink` in the
      // `isAssignedToOrConcatenatedWith` predicate call above, we also allow the noisier "path"
      // name.
      isAssignedToOrConcatenatedWith(sinkCandidate, "(?i)path")
    ) and
    result = "not a direct argument to a likely external library call or a heuristic sink"
  }
}

class TaintedPathAtmConfig extends AtmConfig {
  TaintedPathAtmConfig() { this = "TaintedPathATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof TaintedPath::Source }

  override predicate isKnownSink(DataFlow::Node sink) { sink instanceof TaintedPath::Sink }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    not exists(SinkEndpointFilter::getAReasonSinkExcluded(sinkCandidate))
  }

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
    sanitizes(outcome, e)
  }
}
