/** Provides classes and predicates for defining flow summaries. */

import csharp
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch as DataFlowDispatch

/** Provides the `Range` class used to define the extent of `SummarizedCallable`. */
module SummarizedCallable {
  class Range = Impl::Public::SummarizedCallable;
}

class SummarizedCallable = Impl::Public::RelevantSummarizedCallable;

class Provenance = Impl::Public::Provenance;
