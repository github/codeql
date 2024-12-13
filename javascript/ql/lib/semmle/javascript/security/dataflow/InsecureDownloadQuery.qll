/**
 * Provides a taint tracking configuration for reasoning about download of sensitive file through insecure connection.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureDownload::Configuration` is needed, otherwise
 * `InsecureDownloadCustomizations` should be imported instead.
 */

import javascript
import InsecureDownloadCustomizations::InsecureDownload

/**
 * A taint tracking configuration for download of sensitive file through insecure connection.
 */
module InsecureDownloadConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getALabel() = label
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getALabel() = label
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * Taint tracking for download of sensitive file through insecure connection.
 */
module InsecureDownloadFlow = DataFlow::GlobalWithState<InsecureDownloadConfig>;

/**
 * DEPRECATED. Use the `InsecureDownload` module instead.
 */
deprecated class Configuration extends DataFlow::Configuration {
  Configuration() { this = "InsecureDownload" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    InsecureDownloadConfig::isSource(source, label)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    InsecureDownloadConfig::isSink(sink, label)
  }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node) or
    InsecureDownloadConfig::isBarrier(node)
  }
}
