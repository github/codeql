/**
 * Provides a taint tracking configuration for reasoning about download of sensitive file through insecure connection.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureDownload::Configuration` is needed, otherwise
 * `InsecureDownloadCustomizations` should be imported instead.
 */

import javascript

module InsecureDownload {
  import InsecureDownloadCustomizations::InsecureDownload

  /**
   * A taint tracking configuration for download of sensitive file through insecure connection.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "HTTP/HTTPS" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
  }
}
