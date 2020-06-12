/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * download of sensitive file through insecure connection, as well as
 * extension points for adding your own.
 */

import javascript

module InsecureDownload {
  /**
   * A data flow source for download of sensitive file through insecure connection.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for download of sensitive file through insecure connection.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the call that downloads the sensitive file.
     */
    abstract DataFlow::Node getDownloadCall();
  }

  /**
   * A sanitizer for download of sensitive file through insecure connection.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A HTTP or FTP URL that refers to a file with a sensitive file extension,
   * seen as a source for download of sensitive file through insecure connection.
   */
  class SensitiveFileUrl extends Source {
    SensitiveFileUrl() {
      exists(string str | str = this.getStringValue() |
        str.regexpMatch("http://.*|ftp://.*") and
        exists(string suffix | suffix = unsafeExtension() |
          str.suffix(str.length() - suffix.length() - 1).toLowerCase() = "." + suffix
        )
      )
    }
  }

  /**
   * Gets a file-extension that can potentially be dangerous.
   *
   * Archives are included, because they often contain source-code.
   */
  string unsafeExtension() {
    result =
      ["exe", "dmg", "pkg", "tar.gz", "zip", "sh", "bat", "cmd", "app", "apk", "msi", "dmg",
          "tar.gz", "zip"]
  }

  /**
   * A url downloaded by a client-request, seen as a sink for download of
   * sensitive file through insecure connection.a
   */
  class ClientRequestURL extends Sink {
    ClientRequest request;

    ClientRequestURL() { this = request.getUrl() }

    override DataFlow::Node getDownloadCall() { result = request }
  }
}
