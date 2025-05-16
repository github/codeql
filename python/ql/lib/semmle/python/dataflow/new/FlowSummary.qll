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

/** A callable with a flow summary, identified by a unique string. */
abstract class SummarizedCallable extends LibraryCallable, Impl::Public::SummarizedCallable {
  bindingset[this]
  SummarizedCallable() { any() }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    this.propagatesFlow(input, output, preservesValue) and model = this
  }

  /**
   * Holds if data may flow from `input` to `output` through this callable.
   *
   * `preservesValue` indicates whether this is a value-preserving step or a taint-step.
   */
  predicate propagatesFlow(string input, string output, boolean preservesValue) { none() }
}
