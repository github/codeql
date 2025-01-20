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

/**
 * Flow label for objects from which a tainted value is reachable.
 *
 * Only used by the legacy data-flow configuration, as the new data flow configuration
 * uses `allowImplicitRead` to achieve this instead.
 */
deprecated private class ObjectWrapperFlowLabel extends DataFlow::FlowLabel {
  ObjectWrapperFlowLabel() { this = "object-wrapper" }
}

/**
 * DEPRECATED. Use the `ExternalAPIUsedWithUntrustedDataFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ExternalAPIUsedWithUntrustedData" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) {
    sink instanceof Sink and
    (lbl.isTaint() or lbl instanceof ObjectWrapperFlowLabel)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predLbl,
    DataFlow::FlowLabel succLbl
  ) {
    // Step into an object and switch to the 'object-wrapper' label.
    exists(DataFlow::PropWrite write |
      pred = write.getRhs() and
      succ = write.getBase().getALocalSource() and
      (predLbl.isTaint() or predLbl instanceof ObjectWrapperFlowLabel) and
      succLbl instanceof ObjectWrapperFlowLabel
    )
  }

  override predicate isSanitizerIn(DataFlow::Node node) {
    // Block flow from the location to its properties, as the relevant properties (hash and search) are taint sources of their own.
    // The location source is only used for propagating through API calls like `new URL(location)` and into external APIs where
    // the whole location object escapes.
    node = DOM::locationRef().getAPropertyRead()
  }
}

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
