/**
 * @name SQL database query built from user-controlled sources (boosted)
 * @description Building a database query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 */

import experimental.adaptivethreatmodeling.AdaptiveThreatModeling
import experimental.adaptivethreatmodeling.CoreKnowledge as CoreKnowledge
import experimental.adaptivethreatmodeling.EndpointFilterUtils as EndpointFilterUtils
import semmle.javascript.security.dataflow.SqlInjectionCustomizations
import ATM::ResultsInfo
import DataFlow::PathGraph

/**
 * This module provides logic to filter candidate sinks to those which are likely SQL injection
 * sinks.
 */
module SinkEndpointFilter {
  private import javascript
  private import SQL

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
        // Remove modeled database calls. Arguments to modeled calls are very likely to be modeled
        // as sinks if they are true positives. Therefore arguments that are not modeled as sinks
        // are unlikely to be true positives.
        call instanceof DatabaseAccess
        or
        // Remove calls to APIs that aren't relevant to SQL injection
        call.getReceiver().asExpr() instanceof HTTP::RequestExpr
        or
        call.getReceiver().asExpr() instanceof HTTP::ResponseExpr
        or
        // prepared statements for SQL
        any(DataFlow::CallNode cn | cn.getCalleeName() = "prepare")
            .getAMethodCall("run")
            .getAnArgument() = sinkCandidate
        or
        sinkCandidate instanceof DataFlow::ArrayCreationNode
        or
        // (still required?)
        call instanceof FileSystemAccess
      )
    )
  }
}

class SqlInjectionATMConfig extends ATMConfig {
  SqlInjectionATMConfig() { this = "SqlInjectionATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof SqlInjection::Source }

  override predicate isKnownSink(DataFlow::Node sink) { sink instanceof SqlInjection::Sink }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    SinkEndpointFilter::isEffectiveSink(sinkCandidate)
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof SqlInjection::Sanitizer }
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
  "[Score = " + scoreString + "] This may be a js/sql result depending on $@ " + sourceSinkOriginReport as msg,
  source.getNode(), "a user-provided value"
