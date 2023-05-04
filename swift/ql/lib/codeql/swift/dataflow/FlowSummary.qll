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

class SummaryComponent = Impl::Public::SummaryComponent;

/** Provides predicates for constructing summary components. */
module SummaryComponent {
  private import Impl::Public::SummaryComponent as SummaryComponentInternal

  predicate content = SummaryComponentInternal::content/1;

  predicate parameter = SummaryComponentInternal::parameter/1;

  predicate argument = SummaryComponentInternal::argument/1;

  predicate return = SummaryComponentInternal::return/1;
}

class SummaryComponentStack = Impl::Public::SummaryComponentStack;

/** Provides predicates for constructing stacks of summary components. */
module SummaryComponentStack {
  private import Impl::Public::SummaryComponentStack as SummaryComponentStackInternal

  predicate singleton = SummaryComponentStackInternal::singleton/1;

  predicate push = SummaryComponentStackInternal::push/2;

  predicate argument = SummaryComponentStackInternal::argument/1;

  predicate return = SummaryComponentStackInternal::return/1;
}

class SummarizedCallable = Impl::Public::SummarizedCallable;

class RequiredSummaryComponentStack = Impl::Public::RequiredSummaryComponentStack;
