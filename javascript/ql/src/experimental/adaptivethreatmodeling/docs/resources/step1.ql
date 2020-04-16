/**
 * @name NoSQL database query built from user-controlled sources (boosted)
 * @description Building a database query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 */

import javascript
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling
import ATM::ResultsInfo
import DataFlow::PathGraph

class NosqlInjectionATMConfig extends ATMConfig {
  NosqlInjectionATMConfig() { this = "NosqlInjectionATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { none() }

  override predicate isKnownSink(DataFlow::Node sink) { none() }

  override predicate isEffectiveSink(DataFlow::Node candidateSink) { none() }
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
  "[Score = " + scoreString + "] This may be a NoSQL query depending on $@ " +
    sourceSinkOriginReport as msg, source.getNode(), "a user-provided value"
