/**
 * @name Client-side cross-site scripting (boosted)
 * @description Writing user input directly to the DOM allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 */

import experimental.adaptivethreatmodeling.AdaptiveThreatModeling
import experimental.adaptivethreatmodeling.CoreKnowledge as CoreKnowledge
import experimental.adaptivethreatmodeling.EndpointFilterUtils as EndpointFilterUtils
import semmle.javascript.security.dataflow.DomBasedXssCustomizations
import ATM::ResultsInfo
import DataFlow::PathGraph

/**
 * This module provides logic to filter candidate sinks to those which are likely XSS sinks.
 */
module SinkEndpointFilter {
  private import javascript
  private import DomBasedXss

  /**
   * Returns any argument of calls that satisfy the following conditions:
   * - The call is likely to be to an external non-built-in library
   * - The argument is not explicitly modelled as a sink, and is not an unlikely sink
   */
  predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    exists(DataFlow::CallNode call |
      call = EndpointFilterUtils::getALikelyExternalLibraryCall() and
      sinkCandidate = call.getAnArgument() and
      not (
        // Remove modeled sinks
        CoreKnowledge::isKnownLibrarySink(sinkCandidate)
        or
        // Remove common kinds of unlikely sinks
        CoreKnowledge::isKnownStepSrc(sinkCandidate)
        or
        CoreKnowledge::isUnlikelySink(sinkCandidate)
        or
        // Remove modeled file system calls
        call instanceof FileSystemAccess
        or
        // Remove modeled database calls
        call instanceof DatabaseAccess
        or
        // Remove calls to APIs that aren't relevant to XSS
        call.getReceiver().asExpr() instanceof HTTP::RequestExpr
      )
    )
  }
}

class DomBasedXssATMConfig extends ATMConfig {
  DomBasedXssATMConfig() { this = "DomBasedXssATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof DomBasedXss::Source }

  override predicate isKnownSink(DataFlow::Node sink) { sink instanceof DomBasedXss::Sink }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    SinkEndpointFilter::isEffectiveSink(sinkCandidate)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof DomBasedXss::Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof DomBasedXss::SanitizerGuard
  }
  // XXX missing support for isAdditionalLoadStoreStep and isAdditionalLoadStep
}

from
  ATM::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, string scoreString,
  string sourceSinkOriginReport
where
  cfg.hasFlowPath(source, sink) and
  not isFlowLikelyInBaseQuery(source.getNode(), sink.getNode()) and
  scoreString = scoreStringForFlow(source.getNode(), sink.getNode()) and
  sourceSinkOriginReport =
    "Source origin: " + originsForSource(source.getNode()).listOfOriginComponents() + " " +
      " Sink origin: " + originsForSink(sink.getNode()).listOfOriginComponents()
select sink.getNode(), source, sink,
  "[Score = " + scoreString + "] This may be a js/xss result depending on $@ " +
    sourceSinkOriginReport as msg, source.getNode(), "a user-provided value"
