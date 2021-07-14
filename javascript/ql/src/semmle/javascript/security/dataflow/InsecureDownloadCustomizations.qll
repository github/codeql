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
  /**
   * A data flow source for download of sensitive file through insecure connection.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a flow-label for this source.
     */
    abstract DataFlow::FlowLabel getALabel();
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
     * Gets a flow-label where this sink is vulnerable.
     */
    abstract DataFlow::FlowLabel getALabel();
  }

  /**
   * A sanitizer for download of sensitive file through insecure connection.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * Flow-labels for reasoning about download of sensitive file through insecure connection.
   */
  module Label {
    /**
     * A flow-label for file URLs that are both sensitive and downloaded over an insecure connection.
     */
    class SensitiveInsecureURL extends DataFlow::FlowLabel {
      SensitiveInsecureURL() { this = "sensitiveInsecure" }
    }

    /**
     * A flow-label for a URL that is downloaded over an insecure connection.
     */
    class InsecureURL extends DataFlow::FlowLabel {
      InsecureURL() { this = "insecure" }
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

    override DataFlow::FlowLabel getALabel() {
      result instanceof Label::InsecureURL
      or
      hasUnsafeExtension(str) and
      result instanceof Label::SensitiveInsecureURL
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
  class ClientRequestURL extends Sink {
    ClientRequest request;

    ClientRequestURL() { this = request.getUrl() }

    override DataFlow::Node getDownloadCall() { result = request }

    override DataFlow::FlowLabel getALabel() {
      result instanceof Label::SensitiveInsecureURL
      or
      hasUnsafeExtension(request.getASavePath().getStringValue()) and
      result instanceof Label::InsecureURL
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
    FileSystemWriteAccess write;

    FileWriteSink() {
      this = request.getUrl() and
      clientRequestResponse(DataFlow::TypeTracker::end(), request).flowsTo(write.getADataNode()) and
      hasUnsafeExtension(write.getAPathArgument().getStringValue())
    }

    override DataFlow::FlowLabel getALabel() { result instanceof Label::InsecureURL }

    override DataFlow::Node getDownloadCall() { result = request }
  }
}
