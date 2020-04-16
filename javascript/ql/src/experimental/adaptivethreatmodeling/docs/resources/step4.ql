/**
 * @name NoSQL database query built from user-controlled sources (boosted)
 * @description Building a database query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 */

import javascript
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling
import experimental.adaptivethreatmodeling.EndpointFilterUtils as EndpointFilterUtils
import ATM::ResultsInfo
import DataFlow::PathGraph
import semmle.javascript.security.TaintedObject
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations::NosqlInjection

class NosqlInjectionATMConfig extends ATMConfig {
  NosqlInjectionATMConfig() { this = "NosqlInjectionATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof Source }

  override predicate isKnownSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    TaintedObject::isSource(source, label)
  }

  override predicate isKnownSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getAFlowLabel() = label
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintedObject::SanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
    or
    // additional flow step to track taint through NoSQL query objects
    inlbl = TaintedObject::label() and
    outlbl = TaintedObject::label() and
    exists(NoSQL::Query query, DataFlow::SourceNode queryObj |
      queryObj.flowsToExpr(query) and
      queryObj.flowsTo(trg) and
      src = queryObj.getAPropertyWrite().getRhs()
    )
    or
    // relaxed version of previous flow step to track taint through predicted NoSQL query objects
    any(ATM::Configuration cfg).isSink(trg) and
    src = trg.(DataFlow::SourceNode).getAPropertyWrite().getRhs()
  }

  override predicate isEffectiveSink(DataFlow::Node candidateSink) {
    exists(DataFlow::CallNode call |
      call = EndpointFilterUtils::getALikelyExternalLibraryCall() and
      candidateSink = call.getAnArgument()
    )
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
  "[Score = " + scoreString + "] This may be a NoSQL query depending on $@ " +
    sourceSinkOriginReport as msg, source.getNode(), "a user-provided value"
