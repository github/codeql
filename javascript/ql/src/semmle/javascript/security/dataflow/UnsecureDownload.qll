/**
 * Provides a taint tracking configuration for reasoning about download of sensitive file through unsecure connection.
 *
 * Note, for performance reasons: only import this file if
 * `UnsecureDownload::Configuration` is needed, otherwise
 * `UnsecureDownloadCustomizations` should be imported instead.
 */

import javascript

module UnsecureDownload {
  import UnsecureDownloadCustomizations::UnsecureDownload

  /**
   * A taint tracking configuration for download of sensitive file through unsecure connection.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "HTTP/HTTPS" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
  }
}
