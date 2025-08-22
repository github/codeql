/**
 * Provides a taint tracking configuration for reasoning about download of sensitive file through insecure connection.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureDownload::Configuration` is needed, otherwise
 * `InsecureDownloadCustomizations` should be imported instead.
 */

import javascript
import InsecureDownloadCustomizations::InsecureDownload
private import InsecureDownloadCustomizations::InsecureDownload as InsecureDownload

/**
 * A taint tracking configuration for download of sensitive file through insecure connection.
 */
module InsecureDownloadConfig implements DataFlow::StateConfigSig {
  class FlowState = InsecureDownload::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.(Source).getAFlowState() = state
  }

  predicate isSink(DataFlow::Node sink, FlowState state) { sink.(Sink).getAFlowState() = state }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getDownloadCall().getLocation()
  }
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
    InsecureDownloadConfig::isSource(source, FlowState::fromFlowLabel(label))
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    InsecureDownloadConfig::isSink(sink, FlowState::fromFlowLabel(label))
  }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node) or
    InsecureDownloadConfig::isBarrier(node)
  }
}
