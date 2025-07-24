/** Provides classes and predicates for defining flow summaries. */

private import rust
private import internal.FlowSummaryImpl as Impl

// import all instances below
private module Summaries {
  private import codeql.rust.Frameworks
  private import codeql.rust.dataflow.internal.ModelsAsData
}

/** Provides the `Range` class used to define the extent of `SummarizedCallable`. */
module SummarizedCallable {
  /** A callable with a flow summary, identified by a unique string. */
  abstract class Range extends Impl::Public::SummarizedCallable {
    bindingset[this]
    Range() { any() }

    override predicate propagatesFlow(
      string input, string output, boolean preservesValue, string model
    ) {
      this.propagatesFlow(input, output, preservesValue) and model = ""
    }

    /**
     * Holds if data may flow from `input` to `output` through this callable.
     *
     * `preservesValue` indicates whether this is a value-preserving step or a taint-step.
     */
    predicate propagatesFlow(string input, string output, boolean preservesValue) { none() }
  }
}

final class SummarizedCallable = SummarizedCallable::Range;

final class Provenance = Impl::Public::Provenance;
