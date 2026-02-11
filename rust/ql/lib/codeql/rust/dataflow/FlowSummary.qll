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
      string input, string output, boolean preservesValue, Provenance p, boolean isExact,
      string model
    ) {
      this.propagatesFlow(input, output, preservesValue) and
      p = "manual" and
      isExact = true and
      model = "QL"
    }

    /**
     * Holds if data may flow from `input` to `output` through this callable.
     *
     * `preservesValue` indicates whether this is a value-preserving step or a taint-step.
     */
    predicate propagatesFlow(string input, string output, boolean preservesValue) { none() }
  }
}

class SummarizedCallable = Impl::Public::RelevantSummarizedCallable;

final class Provenance = Impl::Public::Provenance;
