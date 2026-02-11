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

/** Provides the `Range` class used to define the extent of `SummarizedCallable`. */
module SummarizedCallable {
  class Range = Impl::Public::SummarizedCallable;
}

class SummarizedCallable = Impl::Public::RelevantSummarizedCallable;
