/** Provides classes and predicates for defining flow summaries. */

import swift
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowDispatch as DataFlowDispatch

class ParameterPosition = DataFlowDispatch::ParameterPosition;

class ArgumentPosition = DataFlowDispatch::ArgumentPosition;

// import all instances below
private module Summaries {
  private import codeql.swift.frameworks.Frameworks
}

deprecated class SummaryComponent = Impl::Private::SummaryComponent;

deprecated module SummaryComponent = Impl::Private::SummaryComponent;

deprecated class SummaryComponentStack = Impl::Private::SummaryComponentStack;

deprecated module SummaryComponentStack = Impl::Private::SummaryComponentStack;

class SummarizedCallable = Impl::Public::SummarizedCallable;

deprecated class RequiredSummaryComponentStack = Impl::Private::RequiredSummaryComponentStack;
