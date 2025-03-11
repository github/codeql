/**
 * Provides classes and predicates for defining flow sources.
 *
 * Flow sources defined here feed into the `ActiveThreatModelSource` class and
 * ultimately reach data flow configurations as follows:
 *
 *   data from `*.model.yml` | QL extensions of `FlowSource::Range`
 *    v                         v
 *   `FlowSource` (associated with a models-as-data `kind` string)
 *    v
 *   `sourceNode` predicate | (theoretically other QL defined sources)
 *    v                        v
 *   `ThreatModelSource` (associated with a threat model source type)
 *    v
 *   `ActiveThreatModelSource` (just the enabled sources)
 *    v
 *   various `Source` classes for specific data flow configurations
 *
 * New sources should be defined using models-as-data or QL extensions of
 * `FlowSource::Range`. Data flow configurations on the other hand should use
 * `ActiveThreatModelSource` to match sources enabled in the user
 * configuration.
 */

private import rust
private import internal.FlowSummaryImpl as Impl
private import internal.DataFlowImpl as DataFlowImpl

// import all instances below
private module Sources {
  private import codeql.rust.Frameworks
  private import codeql.rust.dataflow.internal.ModelsAsData
}

/** Provides the `Range` class used to define the extent of `FlowSource`. */
module FlowSource {
  /** A flow source. */
  abstract class Range extends Impl::Public::SourceElement {
    bindingset[this]
    Range() { any() }

    override predicate isSource(
      string output, string kind, Impl::Public::Provenance provenance, string model
    ) {
      this.isSource(output, kind) and provenance = "manual" and model = ""
    }

    /**
     * Holds is this element is a flow source of kind `kind`, where data
     * flows out as described by `output`.
     */
    predicate isSource(string output, string kind) { none() }
  }
}

final class FlowSource = FlowSource::Range;

predicate sourceNode = DataFlowImpl::sourceNode/2;
