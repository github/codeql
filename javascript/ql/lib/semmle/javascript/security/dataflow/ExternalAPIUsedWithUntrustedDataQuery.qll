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

/** Flow label for objects from which a tainted value is reachable. */
private class ObjectWrapperFlowLabel extends DataFlow::FlowLabel {
  ObjectWrapperFlowLabel() { this = "object-wrapper" }
}

/**
 * A taint tracking configuration for untrusted data flowing to an external API.
 */
class Configuration extends TaintTracking::Configuration {
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

  override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    // Block flow from the location to its properties, as the relevant properties (hash and search) are taint sources of their own.
    // The location source is only used for propagating through API calls like `new URL(location)` and into external APIs where
    // the whole location object escapes.
    exists(DataFlow::PropRead read |
      read = DOM::locationRef().getAPropertyRead() and
      pred = read.getBase() and
      succ = read
    )
  }
}

/** A node representing data being passed to an external API. */
class ExternalApiDataNode extends DataFlow::Node {
  ExternalApiDataNode() { this instanceof Sink }
}

/** DEPRECATED: Alias for ExternalApiDataNode */
deprecated class ExternalAPIDataNode = ExternalApiDataNode;

/** A node representing untrusted data being passed to an external API. */
class UntrustedExternalApiDataNode extends ExternalApiDataNode {
  UntrustedExternalApiDataNode() { any(Configuration c).hasFlow(_, this) }

  /** Gets a source of untrusted data which is passed to this external API data node. */
  DataFlow::Node getAnUntrustedSource() { any(Configuration c).hasFlow(result, this) }
}

/** DEPRECATED: Alias for UntrustedExternalApiDataNode */
deprecated class UntrustedExternalAPIDataNode = UntrustedExternalApiDataNode;

/**
 * Name of an external API sink, boxed in a newtype for consistency with other languages.
 */
private newtype TExternalApi =
  MkExternalApiNode(string name) {
    exists(Sink sink |
      any(Configuration c).hasFlow(_, sink) and
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
    result = count(getUntrustedDataNode().getAnUntrustedSource())
  }

  /** Gets a textual representation of this element. */
  string toString() { this = MkExternalApiNode(result) }
}

/** DEPRECATED: Alias for ExternalApiUsedWithUntrustedData */
deprecated class ExternalAPIUsedWithUntrustedData = ExternalApiUsedWithUntrustedData;
