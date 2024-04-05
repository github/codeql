/** Provides classes and predicates for defining flow summaries. */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowUtil
private import internal.DataFlowPrivate

// import all instances below
private module Summaries {
  private import semmle.python.Frameworks
  private import semmle.python.frameworks.data.ModelsAsData
}

deprecated class SummaryComponent = Impl::Private::SummaryComponent;

/** Provides predicates for constructing summary components. */
deprecated module SummaryComponent = Impl::Private::SummaryComponent;

deprecated class SummaryComponentStack = Impl::Private::SummaryComponentStack;

deprecated module SummaryComponentStack = Impl::Private::SummaryComponentStack;

/** A callable with a flow summary, identified by a unique string. */
abstract class SummarizedCallable extends LibraryCallable, Impl::Public::SummarizedCallable {
  bindingset[this]
  SummarizedCallable() { any() }

  /**
   * DEPRECATED: Use `propagatesFlow` instead.
   */
  deprecated predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    this.propagatesFlow(input, output, preservesValue)
  }
}

deprecated class RequiredSummaryComponentStack = Impl::Private::RequiredSummaryComponentStack;
