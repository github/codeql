/**
 * Provides a taint-tracking configuration for reasoning about stored
 * cross-site scripting vulnerabilities.
 */

import javascript

module StoredXss {
  import Xss::StoredXss

  /**
   * A taint-tracking configuration for reasoning about XSS.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "StoredXss" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof SanitizerGuard
    }
  }

  /** A file name, considered as a flow source for stored XSS. */
  class FileNameSourceAsSource extends Source {
    FileNameSourceAsSource() { this instanceof FileNameSource }
  }

  /** User-controlled torrent information, considered as a flow source for stored XSS. */
  class UserControlledTorrentInfoAsSource extends Source {
    UserControlledTorrentInfoAsSource() { this instanceof ParseTorrent::UserControlledTorrentInfo }
  }
}
