/**
 * Provides classes and predicates for defining flow sinks.
 *
 * Flow sinks defined here feed into data flow configurations as follows:
 *
 *   data from `*.model.yml` | QL extensions of `FlowSink::Range`
 *    v                         v
 *   `FlowSink` (associated with a models-as-data `kind` string)
 *    v
 *   `sinkNode` predicate | other QL defined sinks, for example using concepts
 *    v                      v
 *   various `Sink` classes for specific data flow configurations
 *
 * New sinks should be defined using models-as-data, QL extensions of
 * `FlowSink::Range`, or concepts. Data flow configurations should use the
 * `sinkNode` predicate and/or concepts to define their sinks.
 */

private import rust
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowImpl as DataFlowImpl

// import all instances below
private module Sinks {
  private import codeql.rust.Frameworks
  private import codeql.rust.dataflow.internal.ModelsAsData
}

/** Provides the `Range` class used to define the extent of `FlowSink`. */
module FlowSink {
  /** A flow sink. */
  abstract class Range extends Impl::Public::SinkElement {
    bindingset[this]
    Range() { any() }

    override predicate isSink(
      string input, string kind, Impl::Public::Provenance provenance, string model
    ) {
      this.isSink(input, kind) and provenance = "manual" and model = ""
    }

    /**
     * Holds is this element is a flow sink of kind `kind`, where data
     * flows in as described by `input`.
     */
    predicate isSink(string output, string kind) { none() }
  }
}

final class FlowSink = FlowSink::Range;

predicate sinkNode = DataFlowImpl::sinkNode/2;
