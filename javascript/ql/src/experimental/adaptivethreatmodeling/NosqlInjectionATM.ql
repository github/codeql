/**
 * @name NoSQL database query built from user-controlled sources (boosted)
 * @description Building a database query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 */

import experimental.adaptivethreatmodeling.AdaptiveThreatModeling
import experimental.adaptivethreatmodeling.CoreKnowledge as CoreKnowledge
import experimental.adaptivethreatmodeling.EndpointFilterUtils as EndpointFilterUtils
import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
import ATM::ResultsInfo
import DataFlow::PathGraph

/**
 * This module provides logic to filter candidate sinks to those which are likely NoSQL injection
 * sinks.
 */
module SinkEndpointFilter {
  private import javascript
  private import NoSQL

  /**
   * Require that local dataflow contains a property write to `node`.
   *
   * For example, this predicate would be true for a node corresponding to
   * `{ password : req.body.password }`, but false for a node corresponding to just
   * `req.body.password`.
   *
   * This is appropriate for NoSQL injection as we are looking for a query object built up from
   * user-controlled data.  Rarely is the query object itself user-controlled data.
   */
  predicate containsAPropertyThatIsWrittenTo(DataFlow::Node node) {
    exists(DataFlow::PropWrite pw, DataFlow::Node base |
      (
        base = pw.getBase() or
        base = pw.getBase().getImmediatePredecessor()
      ) and
      DataFlow::localFlowStep*(base, node)
    )
  }

  /**
   * Returns any argument of calls that satisfy the following conditions:
   * - The call is likely to be to an external non-built-in library
   * - The argument is not explicitly modelled as a sink, and is not an unlikely sink
   * - The argument contains a property that is written to. This condition means that we look for
   *   arguments that have the shape of a NoSQL query. See `containsAPropertyThatIsWrittenTo` for
   *   further details.
   */
  predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    exists(DataFlow::CallNode call |
      call = EndpointFilterUtils::getALikelyExternalLibraryCall() and
      sinkCandidate = call.getAnArgument() and
      containsAPropertyThatIsWrittenTo(sinkCandidate) and
      not (
        // Remove modeled sinks
        CoreKnowledge::isKnownLibrarySink(sinkCandidate) or
        // Remove common kinds of unlikely sinks
        CoreKnowledge::isKnownStepSrc(sinkCandidate) or
        CoreKnowledge::isUnlikelySink(sinkCandidate) or
        // Remove modeled database calls. Arguments to modeled calls are very likely to be modeled
        // as sinks if they are true positives. Therefore arguments that are not modeled as sinks
        // are unlikely to be true positives.
        call instanceof DatabaseAccess or
        // Remove calls to APIs that aren't relevant to NoSQL injection
        call.getReceiver().asExpr() instanceof HTTP::RequestExpr or
        call.getReceiver().asExpr() instanceof HTTP::ResponseExpr
      )
    )
  }
}

/**
 * This predicate allows us to propagate data flow through property writes and array constructors
 * within a query object, enabling the security query to pick up NoSQL injection vulnerabilities
 * involving more complex queries.
 */
private DataFlow::Node getASubexpressionWithinQuery(DataFlow::SourceNode query) {
  // The right-hand side of a property write is a query subexpression
  result = getASubexpressionWithinQuery*(query).(DataFlow::SourceNode).getAPropertyWrite().getRhs() or
  // An element within an array constructor is also a query subexpression
  result = getASubexpressionWithinQuery*(query).(DataFlow::ArrayCreationNode).getAnElement()
}

class NosqlInjectionATMConfig extends ATMConfig {
  NosqlInjectionATMConfig() { this = "NosqlInjectionATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) {
    source instanceof NosqlInjection::Source
  }

  override predicate isKnownSource(DataFlow::Node source, DataFlow::FlowLabel lbl) {
    TaintedObject::isSource(source, lbl)
  }

  override predicate isKnownSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) {
    sink.(NosqlInjection::Sink).getAFlowLabel() = lbl
  }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    SinkEndpointFilter::isEffectiveSink(sinkCandidate)
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof NosqlInjection::Sanitizer }

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
    // relaxed version of previous additional flow step to track taint through unmodeled NoSQL
    // query objects
    any(ATM::Configuration cfg).isSink(trg) and
    src = getASubexpressionWithinQuery(trg)
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
