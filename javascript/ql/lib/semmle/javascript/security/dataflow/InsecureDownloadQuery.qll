/**
 * Provides a taint tracking configuration for reasoning about download of sensitive file through insecure connection.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureDownload::Configuration` is needed, otherwise
 * `InsecureDownloadCustomizations` should be imported instead.
 */

import javascript
import InsecureDownloadCustomizations::InsecureDownload

// Materialize flow labels
private class ConcreteSensitiveInsecureUrl extends Label::SensitiveInsecureUrl {
  ConcreteSensitiveInsecureUrl() { this = this }
}

private class ConcreteInsecureUrl extends Label::InsecureUrl {
  ConcreteInsecureUrl() { this = this }
}

/**
 * A taint tracking configuration for download of sensitive file through insecure connection.
 */
class Configuration extends DataFlow::Configuration {
  Configuration() { this = "InsecureDownload" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getALabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getALabel() = label
  }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node) or
    node instanceof Sanitizer
  }
}
