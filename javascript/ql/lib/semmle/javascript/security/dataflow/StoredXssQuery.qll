/**
 * Provides a taint-tracking configuration for reasoning about stored
 * cross-site scripting vulnerabilities.
 */

import javascript
import StoredXssCustomizations::StoredXss
private import Xss::Shared as Shared

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
    guard instanceof QuoteGuard or
    guard instanceof ContainsHtmlGuard
  }
}

/** A file name, considered as a flow source for stored XSS. */
class FileNameSourceAsSource extends Source {
  FileNameSourceAsSource() { this instanceof FileNameSource }
}

/** An instance of user-controlled torrent information, considered as a flow source for stored XSS. */
class UserControlledTorrentInfoAsSource extends Source {
  UserControlledTorrentInfoAsSource() { this instanceof ParseTorrent::UserControlledTorrentInfo }
}

private class QuoteGuard extends TaintTracking::SanitizerGuardNode, Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends TaintTracking::SanitizerGuardNode, Shared::ContainsHtmlGuard {
  ContainsHtmlGuard() { this = this }
}
