/**
 * Provides a dataflow configuration for reasoning about the download of sensitive file through insecure connection.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureDownloadFlow` is needed, otherwise
 * `InsecureDownloadCustomizations` should be imported instead.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
import InsecureDownloadCustomizations::InsecureDownload

private module InsecureDownloadConfig implements DataFlow::StateConfigSig {
  class FlowState = Label::State;

  predicate isSource(DataFlow::Node source, FlowState label) {
    source.(Source).getAFlowLabel() = label
  }

  predicate isSink(DataFlow::Node sink, FlowState label) { sink.(Sink).getAFlowLabel() = label }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * Taint-tracking for download of sensitive file through insecure connection.
 */
module InsecureDownloadFlow = DataFlow::GlobalWithState<InsecureDownloadConfig>;

/** DEPRECATED: Use `InsecureDownloadConfig` */
deprecated module Config = InsecureDownloadConfig;

/** DEPRECATED: Use `InsecureDownloadFlow` */
deprecated module Flow = InsecureDownloadFlow;
