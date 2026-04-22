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

class Provenance = Impl::Public::Provenance;

/** Provides the `Range` class used to define the extent of `SummarizedCallable`. */
overlay[local]
module SummarizedCallable {
  /** A callable with a flow summary, identified by a unique string. */
  abstract class Range extends LibraryCallable, Impl::Public::SummarizedCallable {
    bindingset[this]
    Range() { any() }

    override predicate propagatesFlow(
      string input, string output, boolean preservesValue, Provenance p, boolean isExact,
      string model
    ) {
      this.propagatesFlow(input, output, preservesValue) and
      p = "manual" and
      isExact = true and
      model = this
    }

    /**
     * Holds if data may flow from `input` to `output` through this callable.
     *
     * `preservesValue` indicates whether this is a value-preserving step or a taint-step.
     */
    predicate propagatesFlow(string input, string output, boolean preservesValue) { none() }
  }
}

final private class SummarizedCallableFinal = SummarizedCallable::Range;

/** A callable with a flow summary, identified by a unique string. */
final class SummarizedCallable extends SummarizedCallableFinal,
  Impl::Public::RelevantSummarizedCallable
{ }

deprecated class RequiredSummaryComponentStack = Impl::Private::RequiredSummaryComponentStack;
