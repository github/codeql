/** Provides classes and predicates for defining flow summaries. */

import csharp
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch as DataFlowDispatch

deprecated class ParameterPosition = DataFlowDispatch::ParameterPosition;

deprecated class ArgumentPosition = DataFlowDispatch::ArgumentPosition;

deprecated class SummaryComponent = Impl::Private::SummaryComponent;

deprecated module SummaryComponent = Impl::Private::SummaryComponent;

deprecated class SummaryComponentStack = Impl::Private::SummaryComponentStack;

deprecated module SummaryComponentStack = Impl::Private::SummaryComponentStack;

deprecated class RequiredSummaryComponentStack = Impl::Private::RequiredSummaryComponentStack;

class SummarizedCallable = Impl::Public::SummarizedCallable;

class Provenance = Impl::Public::Provenance;
