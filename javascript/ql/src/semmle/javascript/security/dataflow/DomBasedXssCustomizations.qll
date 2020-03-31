/**
 * Provides default sources for reasoning about DOM-based
 * cross-site scripting vulnerabilities.
 */

import javascript

module DomBasedXss {
  import Xss::DomBasedXss

  /** A source of remote user input, considered as a flow source for DOM-based XSS. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An access of the URL of this page, or of the referrer to this page.
   */
  class LocationSource extends Source {
    LocationSource() { this = DOM::locationSource() }
  }
}
