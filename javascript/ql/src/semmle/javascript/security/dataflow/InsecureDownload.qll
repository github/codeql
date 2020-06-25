/**
 * Provides a taint tracking configuration for reasoning about download of sensitive file through insecure connection.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureDownload::Configuration` is needed, otherwise
 * `InsecureDownloadCustomizations` should be imported instead.
 */

import javascript

/**
 * Classes and predicates for reasoning about download of sensitive file through insecure connection vulnerabilities.
 */
module InsecureDownload {
  import InsecureDownloadCustomizations::InsecureDownload

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
  }
}
