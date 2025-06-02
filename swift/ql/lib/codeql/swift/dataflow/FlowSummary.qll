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

class SummarizedCallable = Impl::Public::SummarizedCallable;
