/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * download of sensitive file through insecure connection, as well as
 * extension points for adding your own.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.typetracking.TypeTracking
private import codeql.ruby.frameworks.Files
private import codeql.ruby.frameworks.core.IO

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
    abstract Label::State getAFlowLabel();
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
    abstract Label::State getAFlowLabel();
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
     * Flow-labels for reasoning about download of sensitive file through insecure connection.
     */
    newtype State =
      /** A flow-label for a URL that is downloaded over an insecure connection. */
      InsecureState() or
      /** A flow-label for a URL that is sensitive. */
      SensitiveState() or
      /** A flow-label for file URLs that are both sensitive and downloaded over an insecure connection. */
      SensitiveInsecureState()
  }

  /**
   * A HTTP or FTP URL.
   */
  class InsecureUrl extends DataFlow::Node {
    string str;

    InsecureUrl() {
      str = this.asExpr().getConstantValue().getString() and
      str.regexpMatch("http://.*|ftp://.*")
    }
  }

  /**
   * A HTTP or FTP URL that refers to a file with a sensitive file extension,
   * seen as a source for downloads of sensitive files through an insecure connection.
   */
  class InsecureFileUrl extends Source, InsecureUrl {
    override Label::State getAFlowLabel() {
      result = Label::InsecureState()
      or
      hasUnsafeExtension(str) and
      result = Label::SensitiveInsecureState()
    }
  }

  /**
   * A string containing a sensitive file extension,
   * seen as a source for downloads of sensitive files through an insecure connection.
   */
  class SensitiveFileName extends Source {
    SensitiveFileName() { hasUnsafeExtension(this.asExpr().getConstantValue().getString()) }

    override Label::State getAFlowLabel() { result = Label::SensitiveState() }
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
   * A response from an outgoing HTTP request.
   * This is a sink if there are both insecure and sensitive parts of the URL.
   * In other words, if the URL is HTTP and the extension is in `unsafeExtension()`.
   */
  private class HttpResponseAsSink extends Sink {
    private Http::Client::Request req;

    HttpResponseAsSink() {
      this = req.getAUrlPart() and
      // If any part of the URL has an unsafe extension, we consider all parts of the URL to be sinks.
      hasUnsafeExtension(req.getAUrlPart().asExpr().getConstantValue().getString())
    }

    override DataFlow::Node getDownloadCall() { result = req }

    override Label::State getAFlowLabel() {
      result = Label::SensitiveInsecureState()
      or
      any(req.getAUrlPart()) instanceof InsecureUrl and result = Label::SensitiveState()
    }
  }

  /**
   * Gets a node for the response from `request`, type-tracked using `t`.
   */
  DataFlow::LocalSourceNode clientRequestResponse(TypeTracker t, Http::Client::Request request) {
    t.start() and
    result = request.getResponseBody()
    or
    exists(TypeTracker t2 | result = clientRequestResponse(t2, request).track(t2, t))
  }

  /**
   * A url that is downloaded through an insecure connection, where the result ends up being saved to a sensitive location.
   */
  class FileWriteSink extends Sink {
    Http::Client::Request request;

    FileWriteSink() {
      // For example, in:
      //
      // ```rb
      // f = File.open("foo.exe")
      // f.write(Excon.get(...).body) # $BAD=
      // ```
      //
      // `f` is the `FileSystemAccess` and the call `f.write` is the `IO::FileWriter`.
      // The call `Excon.get` is the `HTTP::Client::Request`.
      //
      // The `file = write` alternative models this case:
      // ```rb
      // File.write("foo.exe", Excon.get(...).body)
      // ```
      exists(IO::FileWriter write, FileSystemAccess file |
        this = request.getAUrlPart() and
        clientRequestResponse(TypeTracker::end(), request).flowsTo(write.getADataNode()) and
        (file.(DataFlow::LocalSourceNode).flowsTo(write.getReceiver()) or file = write) and
        hasUnsafeExtension(file.getAPathArgument().asExpr().getConstantValue().getString())
      )
    }

    override Label::State getAFlowLabel() { result = Label::InsecureState() }

    override DataFlow::Node getDownloadCall() { result = request }
  }
}
