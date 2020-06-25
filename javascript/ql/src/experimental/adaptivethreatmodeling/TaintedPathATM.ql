/**
 * @name Uncontrolled data used in path expression (boosted)
 * @description Accessing paths influenced by users can allow an attacker to access
 *              unexpected resources.
 * @kind path-problem
 * @problem.severity error
 */

import experimental.adaptivethreatmodeling.AdaptiveThreatModeling
import experimental.adaptivethreatmodeling.CoreKnowledge as CoreKnowledge
import experimental.adaptivethreatmodeling.EndpointFilterUtils as EndpointFilterUtils
import semmle.javascript.security.dataflow.TaintedPathCustomizations
import ATM::ResultsInfo
import DataFlow::PathGraph

/**
 * This module provides logic to filter candidate sinks to those which are likely path injection
 * sinks.
 */
module SinkEndpointFilter {
  private import javascript
  private import TaintedPath

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
        // Remove modeled file system calls. Arguments to modeled calls are very likely to be modeled
        // as sinks if they are true positives. Therefore arguments that are not modeled as sinks
        // are unlikely to be true positives
        call instanceof FileSystemAccess
        or
        // Remove modeled database calls
        call instanceof DatabaseAccess
        or
        // Remove calls to APIs that aren't relevant to path injection
        call.getReceiver().asExpr() instanceof HTTP::RequestExpr
        or
        call.getReceiver().asExpr() instanceof HTTP::ResponseExpr
      )
    )
  }
}

class TaintedPathATMConfig extends ATMConfig {
  TaintedPathATMConfig() { this = "TaintedPathATMConfig" }

  override predicate isKnownSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    label = source.(TaintedPath::Source).getAFlowLabel()
  }

  override predicate isKnownSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    label = sink.(TaintedPath::Sink).getAFlowLabel()
  }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    SinkEndpointFilter::isEffectiveSink(sinkCandidate)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    // XXX this should be isBarrier, but ATM only supports the taint configuration...
    super.isSanitizer(node) or
    node instanceof TaintedPath::Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintedPath::BarrierGuardNode
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    TaintedPath::isAdditionalTaintedPathFlowStep(src, dst, srclabel, dstlabel)
  }
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
  "[Score = " + scoreString + "] This may be a js/path-injection result depending on $@ " +
    sourceSinkOriginReport as msg, source.getNode(), "a user-provided value"
