/**
 * Provides a dataflow configuration for reasoning about the download of sensitive file through insecure connection.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureDownload::Configuration` is needed, otherwise
 * `InsecureDownloadCustomizations` should be imported instead.
 */

private import ruby
private import codeql.ruby.DataFlow
import InsecureDownloadCustomizations::InsecureDownload

/**
 * A taint tracking configuration for download of sensitive file through insecure connection.
 */
class Configuration extends DataFlow::Configuration {
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
