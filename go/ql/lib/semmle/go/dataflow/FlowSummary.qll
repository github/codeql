/**
 * Provides classes and predicates for defining flow summaries.
 */

import go
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch
private import internal.DataFlowUtil

// import all instances below
private module Summaries { }

deprecated class SummaryComponent = Impl::Private::SummaryComponent;

deprecated module SummaryComponent = Impl::Private::SummaryComponent;

deprecated class SummaryComponentStack = Impl::Private::SummaryComponentStack;

deprecated module SummaryComponentStack = Impl::Private::SummaryComponentStack;

class SummarizedCallable = Impl::Public::SummarizedCallable;

deprecated class RequiredSummaryComponentStack = Impl::Private::RequiredSummaryComponentStack;
