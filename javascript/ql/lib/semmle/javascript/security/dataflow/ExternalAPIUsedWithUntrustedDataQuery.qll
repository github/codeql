/**
 * Provides a taint tracking configuration for reasoning about untrusted
 * data flowing to an external API call.
 *
 * Note, for performance reasons: only import this file if
 * `ExternalAPIUsedWithUntrustedData::Configuration` is needed, otherwise
 * `ExternalAPIUsedWithUntrustedDataCustomizations` should be imported instead.
 */

import javascript
import ExternalAPIUsedWithUntrustedDataCustomizations::ExternalApiUsedWithUntrustedData

/**
 * A taint tracking configuration for untrusted data flowing to an external API.
 */
module ExternalAPIUsedWithUntrustedDataConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isBarrierIn(DataFlow::Node node) {
    // Block flow from the location to its properties, as the relevant properties (hash and search) are taint sources of their own.
    // The location source is only used for propagating through API calls like `new URL(location)` and into external APIs where
    // the whole location object escapes.
    node = DOM::locationRef().getAPropertyRead()
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet contents) {
    // Also report values that escape while inside a property
    isSink(node) and contents = DataFlow::ContentSet::anyProperty()
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // Not used for PR analysis
  }
}

/**
 * Taint tracking for untrusted data flowing to an external API.
 */
module ExternalAPIUsedWithUntrustedDataFlow =
  TaintTracking::Global<ExternalAPIUsedWithUntrustedDataConfig>;

/** A node representing data being passed to an external API. */
class ExternalApiDataNode extends DataFlow::Node instanceof Sink { }

/** A node representing untrusted data being passed to an external API. */
class UntrustedExternalApiDataNode extends ExternalApiDataNode {
  UntrustedExternalApiDataNode() { ExternalAPIUsedWithUntrustedDataFlow::flow(_, this) }

  /** Gets a source of untrusted data which is passed to this external API data node. */
  DataFlow::Node getAnUntrustedSource() { ExternalAPIUsedWithUntrustedDataFlow::flow(result, this) }
}

/**
 * Name of an external API sink, boxed in a newtype for consistency with other languages.
 */
private newtype TExternalApi =
  /** An external API sink with `name`. */
  MkExternalApiNode(string name) {
    exists(Sink sink |
      ExternalAPIUsedWithUntrustedDataFlow::flow(_, sink) and
      name = sink.getApiName()
    )
  }

/** An external API which is used with untrusted data. */
class ExternalApiUsedWithUntrustedData extends TExternalApi {
  /** Gets a possibly untrusted use of this external API. */
  UntrustedExternalApiDataNode getUntrustedDataNode() {
    this = MkExternalApiNode(result.(Sink).getApiName())
  }

  /** Gets the number of untrusted sources used with this external API. */
  int getNumberOfUntrustedSources() {
    result = count(this.getUntrustedDataNode().getAnUntrustedSource())
  }

  /** Gets a textual representation of this element. */
  string toString() { this = MkExternalApiNode(result) }
}
