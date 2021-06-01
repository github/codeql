/**
 * Provides Java specific classes and predicates for definining flow summaries.
 */

private import java
private import DataFlowPrivate
private import DataFlowUtil
private import FlowSummaryImpl::Private
private import FlowSummaryImpl::Public
private import semmle.code.java.dataflow.ExternalFlow

private module FlowSummaries {
  private import semmle.code.java.dataflow.FlowSummary as F
}

/** Holds is `i` is a valid parameter position. */
predicate parameterPosition(int i) { i in [-1 .. any(Parameter p).getPosition()] }

/** Gets the synthesized summary data-flow node for the given values. */
Node summaryNode(SummarizedCallable c, SummaryNodeState state) { result = getSummaryNode(c, state) }

/** Gets the synthesized data-flow call for `receiver`. */
DataFlowCall summaryDataFlowCall(Node receiver) { none() }

/** Gets the type of content `c`. */
DataFlowType getContentType(Content c) {
  result = getErasedRepr(c.(FieldContent).getField().getType())
  or
  c instanceof CollectionContent and
  result instanceof TypeObject
  or
  c instanceof ArrayContent and
  result instanceof TypeObject
}

/** Gets the return type of kind `rk` for callable `c`. */
DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk) {
  result = getErasedRepr(c.getReturnType()) and
  exists(rk)
}

/**
 * Gets the type of the `i`th parameter in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackParameterType(DataFlowType t, int i) { none() }

/**
 * Gets the return type of kind `rk` in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) { none() }

/** Holds if `spec` is a relevant external specification. */
predicate relevantSpec(string spec) { spec = inOutSpec() }

/**
 * Holds if an external flow summary exists for `c` with input specification
 * `input`, output specification `output`, and kind `kind`.
 */
predicate externalSummary(DataFlowCallable c, string input, string output, string kind) {
  summaryElement(c, input, output, kind)
}

/** Gets the summary component for specification component `c`, if any. */
bindingset[c]
SummaryComponent interpretComponentSpecific(string c) {
  c = "ReturnValue" and result = SummaryComponent::return(_)
  or
  c = "ArrayElement" and result = SummaryComponent::content(any(ArrayContent c0))
  or
  c = "Element" and result = SummaryComponent::content(any(CollectionContent c0))
  or
  c = "MapKey" and result = SummaryComponent::content(any(MapKeyContent c0))
  or
  c = "MapValue" and result = SummaryComponent::content(any(MapValueContent c0))
}
