private import semmle.javascript.Locations
private import DataFlowImplSpecific
private import codeql.dataflow.DataFlow as SharedDataFlow
private import codeql.dataflow.TaintTracking as SharedTaintTracking
private import codeql.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

module JSDataFlow implements SharedDataFlow::InputSig<Location> {
  import Private
  import Public

  // Explicitly implement signature members that have a default
  predicate typeStrongerThan = Private::typeStrongerThan/2;

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;

  predicate accessPathLimit = Private::accessPathLimit/0;

  predicate viableImplInCallContext = Private::viableImplInCallContext/2;

  predicate mayBenefitFromCallContext = Private::mayBenefitFromCallContext/1;
}

module JSTaintFlow implements SharedTaintTracking::InputSig<Location, JSDataFlow> {
  import semmle.javascript.dataflow.internal.TaintTrackingPrivate
}

module JSFlowSummary implements FlowSummaryImpl::InputSig<Location, JSDataFlow> {
  private import semmle.javascript.dataflow.internal.FlowSummaryPrivate as FlowSummaryPrivate
  import FlowSummaryPrivate

  // Explicitly implement signature members that have a default
  predicate callbackSelfParameterPosition = FlowSummaryPrivate::callbackSelfParameterPosition/0;

  predicate encodeContent = FlowSummaryPrivate::encodeContent/2;

  predicate encodeReturn = FlowSummaryPrivate::encodeReturn/2;

  predicate encodeWithoutContent = FlowSummaryPrivate::encodeWithoutContent/2;

  predicate encodeWithContent = FlowSummaryPrivate::encodeWithContent/2;

  predicate decodeUnknownParameterPosition = FlowSummaryPrivate::decodeUnknownParameterPosition/1;

  predicate decodeUnknownArgumentPosition = FlowSummaryPrivate::decodeUnknownArgumentPosition/1;

  predicate decodeUnknownContent = FlowSummaryPrivate::decodeUnknownContent/1;

  predicate decodeUnknownReturn = FlowSummaryPrivate::decodeUnknownReturn/1;

  predicate decodeUnknownWithoutContent = FlowSummaryPrivate::decodeUnknownWithoutContent/1;

  predicate decodeUnknownWithContent = FlowSummaryPrivate::decodeUnknownWithContent/1;
}
