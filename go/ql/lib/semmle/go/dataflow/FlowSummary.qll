/**
 * Provides classes and predicates for defining flow summaries.
 */
overlay[local?]
module;

import go
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch
private import internal.DataFlowUtil

// import all instances below
private module Summaries { }

/** Provides the `Range` class used to define the extent of `SummarizedCallable`. */
module SummarizedCallable {
  class Range = Impl::Public::SummarizedCallable;
}

class SummarizedCallable = Impl::Public::RelevantSummarizedCallable;
