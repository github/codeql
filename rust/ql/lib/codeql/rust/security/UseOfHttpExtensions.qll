/**
 * Provides classes and predicates for reasoning about the use of
 * non-HTTPS URLs in Rust code.
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts

/**
 * Provides default sources, sinks and barriers for detecting use of
 * non-HTTPS URLs, as well as extension points for adding your own.
 */
module UseOfHttp {
  /**
   * A data flow source for use of non-HTTPS URLs.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for use of non-HTTPS URLs.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "UseOfHttp" }
  }

  /**
   * A barrier for use of non-HTTPS URLs.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A string containing an HTTP URL.
   */
  class HttpStringLiteral extends StringLiteralExpr {
    HttpStringLiteral() {
      exists(string s | this.getTextValue() = s |
        // match HTTP URLs
        s.regexpMatch("(?i)\"http://.*\"") and
        // exclude private/local addresses:
        //  - IPv4: localhost / 127.0.0.1, 192.168.x.x, 10.x.x.x, 172.16.x.x -> 172.31.x.x
        //  - IPv6 (address inside []): ::1 (or 0:0:0:0:0:0:0:1), fc00::/7 (i.e. anything beginning `fcxx:` or `fdxx:`)
        not s.regexpMatch("(?i)\"http://(localhost|127\\.0\\.0\\.1|192\\.168\\.[0-9]+\\.[0-9]+|10\\.[0-9]+\\.[0-9]+\\.[0-9]+|172\\.(1[6-9]|2[0-9]|3[01])\\.[0-9]+|\\[::1\\]|\\[0:0:0:0:0:0:0:1\\]|\\[f[cd][0-9a-f]{2}:.*\\]).*\"")
      )
    }
  }

  /**
   * An HTTP string literal as a source.
   */
  private class HttpStringLiteralAsSource extends Source {
    HttpStringLiteralAsSource() { this.asExpr().getExpr() instanceof HttpStringLiteral }
  }

  /**
   * A sink for use of HTTP URLs from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "request-url") }
  }
}
