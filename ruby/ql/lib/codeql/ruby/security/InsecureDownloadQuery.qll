/**
 * Provides a dataflow configuration for reasoning about the download of sensitive file through insecure connection.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureDownload::Configuration` is needed, otherwise
 * `InsecureDownloadCustomizations` should be imported instead.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
import InsecureDownloadCustomizations::InsecureDownload

/**
 * A taint tracking configuration for download of sensitive file through insecure connection.
 */
deprecated class Configuration extends DataFlow::Configuration {
  Configuration() { this = "InsecureDownload" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState label) {
    source.(Source).getALabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState label) {
    sink.(Sink).getALabel() = label
  }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node) or
    node instanceof Sanitizer
  }
}

/**
 * A taint tracking configuration for download of sensitive file through insecure connection.
 */
module Config implements DataFlow::StateConfigSig {
  class FlowState = string;

  predicate isSource(DataFlow::Node source, DataFlow::FlowState label) {
    source.(Source).getALabel() = label
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState label) {
    sink.(Sink).getALabel() = label
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

module Flow = DataFlow::GlobalWithState<Config>;
