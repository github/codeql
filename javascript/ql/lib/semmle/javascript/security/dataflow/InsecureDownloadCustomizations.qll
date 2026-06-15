/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * download of sensitive file through insecure connection, as well as
 * extension points for adding your own.
 */

import javascript

/**
 * Classes and predicates for reasoning about download of sensitive file through insecure connection vulnerabilities.
 */
module InsecureDownload {
  private newtype TFlowState =
    TSensitiveInsecureUrl() or
    TInsecureUrl()

  /** A flow state to associate with a tracked value. */
  class FlowState extends TFlowState {
    /** Gets a string representation fo this flow state */
    string toString() {
      this = TSensitiveInsecureUrl() and result = "sensitive-insecure-url"
      or
      this = TInsecureUrl() and result = "insecure-url"
    }

    /** Gets the corresponding flow label. */
    deprecated DataFlow::FlowLabel toFlowLabel() {
      this = TSensitiveInsecureUrl() and result instanceof Label::SensitiveInsecureUrl
      or
      this = TInsecureUrl() and result instanceof Label::InsecureUrl
    }
  }

  /** Predicates for working with flow states. */
  module FlowState {
    /** Gets the flow state corresponding to `label`. */
    deprecated FlowState fromFlowLabel(DataFlow::FlowLabel label) { result.toFlowLabel() = label }

    /**
     * A file URL that is both sensitive and downloaded over an insecure connection.
     */
    FlowState sensitiveInsecureUrl() { result = TSensitiveInsecureUrl() }

    /**
     * A URL that is downloaded over an insecure connection.
     */
    FlowState insecureUrl() { result = TInsecureUrl() }
  }

  /**
   * A data flow source for download of sensitive file through insecure connection.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a flow state for this source.
     */
    FlowState getAFlowState() { result = FlowState::insecureUrl() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getALabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A data flow sink for download of sensitive file through insecure connection.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the call that downloads the sensitive file.
     */
    abstract DataFlow::Node getDownloadCall();

    /**
     * Gets a flow state where this sink is vulnerable.
     */
    FlowState getAFlowState() {
      result = [FlowState::insecureUrl(), FlowState::sensitiveInsecureUrl()]
    }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getALabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A sanitizer for download of sensitive file through insecure connection.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * Flow-labels for reasoning about download of sensitive file through insecure connection.
   */
  deprecated module Label {
    /**
     * A flow-label for file URLs that are both sensitive and downloaded over an insecure connection.
     */
    class SensitiveInsecureUrl extends DataFlow::FlowLabel {
      SensitiveInsecureUrl() { this = "sensitiveInsecure" }
    }

    /**
     * A flow-label for a URL that is downloaded over an insecure connection.
     */
    class InsecureUrl extends DataFlow::FlowLabel {
      InsecureUrl() { this = "insecure" }
    }
  }

  /**
   * A HTTP or FTP URL that refers to a file with a sensitive file extension,
   * seen as a source for download of sensitive file through insecure connection.
   */
  class SensitiveFileUrl extends Source {
    string str;

    SensitiveFileUrl() {
      str = this.getStringValue() and
      str.regexpMatch("http://.*|ftp://.*")
    }

    override FlowState getAFlowState() {
      result = FlowState::insecureUrl()
      or
      hasUnsafeExtension(str) and
      result = FlowState::sensitiveInsecureUrl()
    }
  }

  /**
   * Holds if `str` is a string that ends with an unsafe file extension.
   */
  bindingset[str]
  predicate hasUnsafeExtension(string str) {
    exists(string suffix | suffix = unsafeExtension() |
      str.suffix(str.length() - suffix.length() - 1).toLowerCase() = "." + suffix
    )
  }

  /**
   * Gets a file-extension that can potentially be dangerous.
   *
   * Archives are included, because they often contain source-code.
   */
  string unsafeExtension() {
    result =
      [
        "exe", "dmg", "pkg", "tar.gz", "zip", "sh", "bat", "cmd", "app", "apk", "msi", "dmg",
        "tar.gz", "zip", "js", "py", "jar", "war"
      ]
  }

  /**
   * A url downloaded by a client-request, seen as a sink for download of
   * sensitive file through insecure connection.
   */
  class ClientRequestUrl extends Sink {
    ClientRequest request;

    ClientRequestUrl() { this = request.getUrl() }

    override DataFlow::Node getDownloadCall() { result = request }

    override FlowState getAFlowState() {
      result = FlowState::sensitiveInsecureUrl()
      or
      hasUnsafeExtension(request.getASavePath().getStringValue()) and
      result = FlowState::insecureUrl()
    }
  }

  /**
   * Gets a node for the response from `request`, type-tracked using `t`.
   */
  DataFlow::SourceNode clientRequestResponse(DataFlow::TypeTracker t, ClientRequest request) {
    t.start() and
    result = request.getAResponseDataNode()
    or
    exists(DataFlow::TypeTracker t2 | result = clientRequestResponse(t2, request).track(t2, t))
  }

  /**
   * A url that is downloaded through an insecure connection, where the result ends up being saved to a sensitive location.
   */
  class FileWriteSink extends Sink {
    ClientRequest request;

    FileWriteSink() {
      exists(FileSystemWriteAccess write |
        this = request.getUrl() and
        clientRequestResponse(DataFlow::TypeTracker::end(), request).flowsTo(write.getADataNode()) and
        hasUnsafeExtension(write.getAPathArgument().getStringValue())
      )
    }

    override FlowState getAFlowState() { result = FlowState::insecureUrl() }

    override DataFlow::Node getDownloadCall() { result = request }
  }
}
