/**
 * Provides Java-specific dataflow config wrappers that apply alert filtering.
 */

private import semmle.code.java.AlertFiltering
private import semmle.code.java.dataflow.DataFlow

/**
 * This wrapper applies alert filters to an existing `DataFlow::ConfigSig` module. It is intended
 * to be used in the specific case where both the dataflow sources and the dataflow sinks are
 * presented in the query result, so we need to apply the alert filter on either the source or the
 * sink.
 *
 * This wrapper supports this use case by checking whether the source or the sink intersects with
 * the alert filter. If so, the wrapped config returns the same sources and sinks as the original.
 * If there is no intersection, the wrapped config has no sources or sinks, thus eliminating the
 * corresponding dataflow computation (which would produce no results that would pass the alert
 * filter anyway).
 */
module FilteredConfig<DataFlow::ConfigSig Config> implements DataFlow::ConfigSig {
  pragma[noinline]
  private predicate nonEmptyFilteredSourceOrSink() {
    exists(DataFlow::Node n |
      Config::isSource(n) or
      Config::isSink(n)
    |
      AlertFiltering::filterByLocation(n.getLocation())
    )
  }

  predicate isSource(DataFlow::Node source) {
    nonEmptyFilteredSourceOrSink() and
    Config::isSource(source)
  }

  predicate isSink(DataFlow::Node sink) {
    nonEmptyFilteredSourceOrSink() and
    Config::isSink(sink)
  }

  predicate isBarrier = Config::isBarrier/1;

  predicate isBarrierIn = Config::isBarrierIn/1;

  predicate isBarrierOut = Config::isBarrierOut/1;

  predicate isAdditionalFlowStep = Config::isAdditionalFlowStep/2;

  predicate allowImplicitRead = Config::allowImplicitRead/2;

  predicate neverSkip = Config::neverSkip/1;

  predicate fieldFlowBranchLimit = Config::fieldFlowBranchLimit/0;

  predicate accessPathLimit = Config::accessPathLimit/0;

  predicate getAFeature = Config::getAFeature/0;

  predicate sourceGrouping = Config::sourceGrouping/2;

  predicate sinkGrouping = Config::sinkGrouping/2;

  predicate includeHiddenNodes = Config::includeHiddenNodes/0;
}

/**
 * This wrapper applies alert filters to an existing `DataFlow::StateConfigSig` module. It is
 * intended to be used in the specific case where both the dataflow sources and the dataflow sinks
 * are presented in the query result, so we need to apply the alert filter on either the source or
 * the sink.
 *
 * This wrapper supports this use case by checking whether the source or the sink intersects with
 * the alert filter. If so, the wrapped config returns the same sources and sinks as the original.
 * If there is no intersection, the wrapped config has no sources or sinks, thus eliminating the
 * corresponding dataflow computation (which would produce no results that would pass the alert
 * filter anyway).
 */
module FilteredStateConfig<DataFlow::StateConfigSig Config> implements DataFlow::StateConfigSig {
  class FlowState = Config::FlowState;

  pragma[noinline]
  private predicate nonEmptyFilteredSourceOrSink() {
    exists(DataFlow::Node n |
      Config::isSource(n, _) or
      Config::isSink(n, _) or
      Config::isSink(n)
    |
      AlertFiltering::filterByLocation(n.getLocation())
    )
  }

  predicate isSource(DataFlow::Node source, FlowState state) {
    nonEmptyFilteredSourceOrSink() and
    Config::isSource(source, state)
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    nonEmptyFilteredSourceOrSink() and
    Config::isSink(sink, state)
  }

  predicate isSink(DataFlow::Node sink) {
    nonEmptyFilteredSourceOrSink() and
    Config::isSink(sink)
  }

  predicate isBarrier = Config::isBarrier/1;

  predicate isBarrier = Config::isBarrier/2;

  predicate isBarrierIn = Config::isBarrierIn/1;

  predicate isBarrierIn = Config::isBarrierIn/2;

  predicate isBarrierOut = Config::isBarrierOut/1;

  predicate isBarrierOut = Config::isBarrierOut/2;

  predicate isAdditionalFlowStep = Config::isAdditionalFlowStep/2;

  predicate isAdditionalFlowStep = Config::isAdditionalFlowStep/4;
}
