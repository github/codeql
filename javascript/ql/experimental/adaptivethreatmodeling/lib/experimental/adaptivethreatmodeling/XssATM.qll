/**
 * For internal use only.
 *
 * Defines shared code used by the XSS boosted query.
 */

private import semmle.javascript.heuristics.SyntacticHeuristics
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations
import AdaptiveThreatModeling
import CoreKnowledge as CoreKnowledge
import StandardEndpointFilters as StandardEndpointFilters

/**
 * This module provides logic to filter candidate sinks to those which are likely XSS sinks.
 */
module SinkEndpointFilter {
  private import javascript
  private import DomBasedXss

  /**
   * Provides a set of reasons why a given data flow node should be excluded as a sink candidate.
   *
   * If this predicate has no results for a sink candidate `n`, then we should treat `n` as an
   * effective sink.
   */
  string getAReasonSinkExcluded(DataFlow::Node sinkCandidate) {
    result = StandardEndpointFilters::getAReasonSinkExcluded(sinkCandidate)
    or
    exists(DataFlow::CallNode call | sinkCandidate = call.getAnArgument() |
      call.getCalleeName() = "setState"
    ) and
    result = "setState calls ought to be safe in react applications"
    or
    // Require XSS sink candidates to be (a) arguments to external library calls (possibly
    // indirectly), or (b) heuristic sinks.
    //
    // Heuristic sinks are copied from the `HeuristicDomBasedXssSink` class defined within
    // `codeql/javascript/ql/src/semmle/javascript/heuristics/AdditionalSinks.qll`.
    // We can't reuse the class because importing that file would cause us to treat these
    // heuristic sinks as known sinks.
    not StandardEndpointFilters::flowsToArgumentOfLikelyExternalLibraryCall(sinkCandidate) and
    not (
      isAssignedToOrConcatenatedWith(sinkCandidate, "(?i)(html|innerhtml)")
      or
      isArgTo(sinkCandidate, "(?i)(html|render)")
      or
      sinkCandidate instanceof StringOps::HtmlConcatenationLeaf
      or
      isConcatenatedWithStrings("(?is).*<[a-z ]+.*", sinkCandidate, "(?s).*>.*")
      or
      // In addition to the heuristic sinks from `HeuristicDomBasedXssSink`, explicitly allow
      // property writes like `elem.innerHTML = <TAINT>` that may not be picked up as HTML
      // concatenation leaves.
      exists(DataFlow::PropWrite pw |
        pw.getPropertyName().regexpMatch("(?i).*html*") and
        pw.getRhs() = sinkCandidate
      )
    ) and
    result = "not a direct argument to a likely external library call or a heuristic sink"
  }
}

class DomBasedXssAtmConfig extends AtmConfig {
  DomBasedXssAtmConfig() { this = "DomBasedXssATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof DomBasedXss::Source }

  override predicate isKnownSink(DataFlow::Node sink) { sink instanceof DomBasedXss::Sink }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    not exists(SinkEndpointFilter::getAReasonSinkExcluded(sinkCandidate))
  }

  override EndpointType getASinkEndpointType() { result instanceof XssSinkType }
}

/** DEPRECATED: Alias for DomBasedXssAtmConfig */
deprecated class DomBasedXssATMConfig = DomBasedXssAtmConfig;

/**
 * A taint-tracking configuration for reasoning about XSS vulnerabilities.
 *
 * This is largely a copy of the taint tracking configuration for the standard XSSThroughDom query,
 * except additional ATM sinks have been added to the `isSink` predicate.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "DomBasedXssATMConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof DomBasedXss::Source }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof DomBasedXss::Sink or
    any(DomBasedXssAtmConfig cfg).isEffectiveSink(sink)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof DomBasedXss::Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof DomBasedXss::SanitizerGuard
  }

  override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    DomBasedXss::isOptionallySanitizedEdge(pred, succ)
  }
}
