/**
 * For internal use only.
 *
 * A taint-tracking configuration for reasoning about NoSQL injection vulnerabilities.
 * Defines shared code used by the NoSQL injection boosted query.
 */

import javascript
private import semmle.javascript.heuristics.SyntacticHeuristics
private import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
import AdaptiveThreatModeling

class NosqlInjectionAtmConfig extends AtmConfig {
  NosqlInjectionAtmConfig() { this = "NosqlInjectionAtmConfig" }

  override predicate isKnownSource(DataFlow::Node source) {
    source instanceof NosqlInjection::Source or TaintedObject::isSource(source, _)
  }

  override EndpointType getASinkEndpointType() { result instanceof NosqlInjectionSinkType }

  /*
   * This is largely a copy of the taint tracking configuration for the standard NoSQL injection
   * query, except additional ATM sinks have been added and the additional flow step has been
   * generalised to cover the sinks predicted by ATM.
   */

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    TaintedObject::isSource(source, label)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(NosqlInjection::Sink).getAFlowLabel() = label
    or
    // Allow effective sinks to have any taint label
    isEffectiveSink(sink)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof NosqlInjection::Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof TaintedObject::SanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    // additional flow steps from the base (non-boosted) security query
    isBaseAdditionalFlowStep(src, trg, inlbl, outlbl)
    or
    // relaxed version of previous step to track taint through unmodeled NoSQL query objects
    isEffectiveSink(trg) and
    src = getASubexpressionWithinQuery(trg)
  }

  /** Holds if src -> trg is an additional flow step in the non-boosted NoSql injection security query. */
  private predicate isBaseAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, trg, inlbl, outlbl)
    or
    // additional flow step to track taint through NoSQL query objects
    inlbl = TaintedObject::label() and
    outlbl = TaintedObject::label() and
    exists(NoSql::Query query, DataFlow::SourceNode queryObj |
      queryObj.flowsTo(query) and
      queryObj.flowsTo(trg) and
      src = queryObj.getAPropertyWrite().getRhs()
    )
  }

  /**
   * Gets a value that is (transitively) written to `query`, where `query` is a NoSQL sink.
   *
   * This predicate allows us to propagate data flow through property writes and array constructors
   * within a query object, enabling the security query to pick up NoSQL injection vulnerabilities
   * involving more complex queries.
   */
  private DataFlow::Node getASubexpressionWithinQuery(DataFlow::Node query) {
    isEffectiveSink(query) and
    exists(DataFlow::SourceNode receiver |
      receiver = [getASubexpressionWithinQuery(query), query].getALocalSource()
    |
      result =
        [
          receiver.getAPropertyWrite().getRhs(),
          receiver.(DataFlow::ArrayCreationNode).getAnElement()
        ]
    )
  }
}
