/**
 * Provides classes and predicates for defining flow summaries.
 */

import go
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch
private import internal.DataFlowUtil

// import all instances below
private module Summaries { }

class SummarizedCallable = Impl::Public::SummarizedCallable;
